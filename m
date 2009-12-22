Return-Path: <linux-kernel-owner+w=401wt.eu-S1751529AbZLVKEp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751529AbZLVKEp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 05:04:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751149AbZLVKEo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 05:04:44 -0500
Received: from smtp2b.orange.fr ([80.12.242.144]:45456 "EHLO smtp2b.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750956AbZLVKEn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 05:04:43 -0500
X-ME-UUID: 20091222095621419.6648B7004E5F@mwinf2b03.orange.fr
X-ME-User-Auth: jean-pierre.andre
Message-ID: <4B3097C4.3060803@wanadoo.fr>
Date: Tue, 22 Dec 2009 10:56:20 +0100
From: =?ISO-8859-1?Q?Jean-Pierre_Andr=E9?= <jean-pierre.andre@wanadoo.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4) Gecko/20091027 Fedora/2.0-7.fc13 SeaMonkey/2.0
MIME-Version: 1.0
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
CC: Eric Blake <ebb9@byu.net>, fuse-devel@lists.sourceforge.net,
       Miklos Szeredi <miklos@szeredi.hu>, Christoph Hellwig <hch@lst.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       xfs@oss.sgi.com
Subject: Re: [fuse-devel] utimensat fails to update ctime
References: <4B2B156D.9040604@byu.net> <87aaxclr4q.fsf@devron.myhome.or.jp>	<4B2F7421.10005@byu.net> <4B2F7A95.3010708@byu.net>	<87hbrkjrk8.fsf@devron.myhome.or.jp> <4B304D04.6040501@byu.net> <87d427jscr.fsf@devron.myhome.or.jp>
In-Reply-To: <87d427jscr.fsf@devron.myhome.or.jp>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,


OGAWA Hirofumi wrote:
> Eric Blake<ebb9@byu.net>  writes:
>
>    
> It is likely the issue of libfuse or ntfs-3g. I don't know about ntfs-3g
> people at all. So, for now, just Cc: to fuse people.
>    

Which ntfs-3g version are you using ?

>> utimensat(0, NULL, {UTIME_OMIT, UTIME_NOW}, 0) = 0
>>      
>    

Currently ntfs-3g does not set sub-second precision.

There is also a slight problem in the fuse interface :
the time buffer is never passed as NULL, consequently
in some circumstances ntfs-3g cannot decide correctly
over permissions. A permissive action is taken in this
situation.

> > From this, "ia_valid" will have "ATTR_CTIME | ATTR_MTIME". And the
> request would pass to userland via fuse of kernel part, then it will be
> handled by libfuse.
>
> > From quick grep of libfuse and ntfs-3g (would not be latest), ntfs-3g is
> using "struct fuse_operations", not "struct fuse_lowlevel_ops".
>    

With the latest ntfs-3g, currently as a release candidate,
you can (optionally) use the low level fuse interface
http://pagesperso-orange.fr/b.andre/advanced-ntfs-3g.html
use the "lowntfs-3g" driver instead of "ntfs-3g"

Hope this helps

Regards

Jean-Pierre



