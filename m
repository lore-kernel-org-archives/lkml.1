Return-Path: <linux-kernel-owner+w=401wt.eu-S932409AbXBSQzu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932409AbXBSQzu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 11:55:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932412AbXBSQzu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 11:55:50 -0500
Received: from mail.parknet.jp ([210.171.160.80]:1551 "EHLO parknet.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932409AbXBSQzt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 11:55:49 -0500
X-AuthUser: hirofumi@parknet.jp
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Racy NLS behaviour in FAT (and possible other fs)
References: <45D9C80A.2030905@drzeus.cx>
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Date: Tue, 20 Feb 2007 01:55:39 +0900
In-Reply-To: <45D9C80A.2030905@drzeus.cx> (Pierre Ossman's message of "Mon\, 19 Feb 2007 16\:53\:46 +0100")
Message-ID: <87tzxim6ic.fsf@duaron.myhome.or.jp>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.93 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pierre Ossman <drzeus-list@drzeus.cx> writes:

> Hi,

Hi,

> I'm experiencing a rather odd behaviour with the character set
> conversion. If I mount a vfat fs with utf8 and then create a file
> with invalid utf-8 sequences, the file will briefly exist with these
> invalid sequences, then quickly convert to a stripped version.

Yes. utf8 support is broken, and it will fail to convert letter case
on many case. And it's why that is not recommended.

> I haven't found an easy way to catch the race, but if I have
> nautilus open it tends to catch it now and then (I get a file name
> with "<?>" replacing each bad byte).

`?' is meaning the character can't be converted.

> The race also seems to corrupt the in-memory state of the fs now and then. I
> managed to create a file where "ls" shows "?" for most fields. Data seemed to
> have made it to disk ok though (fsck didn't complain and a remount showed
> everything as it should be).

It seems readdir() was success, but stat() was failed. And the dosfsck
doesn't check filename correctly.

Those problem seem to be relateing to poor utf8 support...

> Third, there seems to be a problem with not all syscalls being subjected to the
> NLS transformation. Example:
>
> $ echo foo > baråäö.txt
> $ ls
> foo.txt
> $ echo foo > baråäö.txt
> bash: baråäö.txt: File exists
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
