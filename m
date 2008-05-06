Return-Path: <linux-kernel-owner+w=401wt.eu-S1765653AbYEFJ3u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765653AbYEFJ3u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 05:29:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765604AbYEFJ1W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 05:27:22 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:40007 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765210AbYEFJ1V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 05:27:21 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, hch@infradead.org, viro@ZenIV.linux.org.uk,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [patch 08/15] fat: dont call notify_change
References: <20080505095440.820370974@szeredi.hu>
	<20080505095518.844178123@szeredi.hu>
	<87myn4lem9.fsf@duaron.myhome.or.jp>
	<E1JtIs2-0008VJ-Ge@pomaz-ex.szeredi.hu>
Date: Tue, 06 May 2008 18:27:08 +0900
In-Reply-To: <E1JtIs2-0008VJ-Ge@pomaz-ex.szeredi.hu> (Miklos Szeredi's message
	of "Tue, 06 May 2008 10:49:58 +0200")
Message-ID: <87wsm7rdeb.fsf@duaron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi <miklos@szeredi.hu> writes:

> security_inode_setattr() will call into the security module (selinux,
> smack, apparmor) to check if the file mode change is permitted or not.
> It's not really applicable to this case, since AFAICS the mode change
> here is just a side effect of the attribute change.

Yes.

> If it's not just a side effect, but another way to change the file
> mode, then the whole code is very wrong.  chmod() is perfectly fine
> for changing the file mode, there's no need for a separate ioctl to
> perform exactly the same task.

FAT doesn't have permission, it has just some flags. hidden, system,
read-only, etc., and FAT driver maps read-only to permission bit of
file/dir. Mainly this ioctl is to change FAT specific flags, but doesn't
handle read-only flag as special.

As result, this ioctl change permission.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
