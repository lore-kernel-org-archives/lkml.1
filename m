Return-Path: <linux-kernel-owner+w=401wt.eu-S1755234AbZLWTXj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755234AbZLWTXj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 14:23:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754157AbZLWTXi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 14:23:38 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:53574 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753625AbZLWTXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 14:23:37 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Eric Blake <ebb9@byu.net>
Cc: Jean-Pierre =?iso-8859-1?Q?Andr=E9?= 
	<jean-pierre.andre@wanadoo.fr>,
       fuse-devel@lists.sourceforge.net, Miklos Szeredi <miklos@szeredi.hu>,
       Christoph Hellwig <hch@lst.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       xfs@oss.sgi.com, ctrn3e8 <ctrn3e8@gmail.com>,
       bug-coreutils <bug-coreutils@gnu.org>
Subject: Re: [fuse-devel] utimensat fails to update ctime
References: <4B2B156D.9040604@byu.net> <87aaxclr4q.fsf@devron.myhome.or.jp>
	<4B2F7421.10005@byu.net> <4B2F7A95.3010708@byu.net>
	<87hbrkjrk8.fsf@devron.myhome.or.jp> <4B304D04.6040501@byu.net>
	<87d427jscr.fsf@devron.myhome.or.jp> <4B3097C4.3060803@wanadoo.fr>
	<874onjjnln.fsf@devron.myhome.or.jp> <4B30B67A.7080703@wanadoo.fr>
	<87ljgvi1an.fsf@devron.myhome.or.jp> <4B30F0C9.2020702@wanadoo.fr>
	<87my1aevro.fsf@devron.myhome.or.jp> <4B3212ED.4090208@byu.net>
Date: Thu, 24 Dec 2009 04:23:28 +0900
In-Reply-To: <4B3212ED.4090208@byu.net> (Eric Blake's message of "Wed, 23 Dec
	2009 05:54:05 -0700")
Message-ID: <87vdfxmr4f.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.90 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Blake <ebb9@byu.net> writes:

> By the way, is there any reliable way, other than uname() and checking for
> a minimum kernel version, to tell if all file systems will properly
> support UTIME_OMIT?

Um... sorry, I don't know. And it might be hard to detect efficiently if
the workaround is enough efficient like one fstat() syscall (Pass fd to
kernel.  I.e. just read from cached inode).

> For coreutils 8.3, we will be inserting a workaround where instead of
> using UTIME_OMIT, we call fstatat() in advance of utimensat() and pass
> the original timestamp down.  But it would be nice to avoid the
> penalty of the extra stat if there were a reliable way to ensure that,
> regardless of file system, the use of UTIME_OMIT will be honored.
> After all, coreutils wants touch(1) to work regardless of how old the
> user's kernel and file system drivers are.

Or it would depend on coreutils policy though, personally I think it's
ok that it ignores the bug as known fs bug, otherwise coreutils would
need to collect workarounds on several filesystems of several OSes.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
