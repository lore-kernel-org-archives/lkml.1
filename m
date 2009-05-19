Return-Path: <linux-kernel-owner+w=401wt.eu-S1754612AbZESJsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754612AbZESJsT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 05:48:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752497AbZESJsN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 05:48:13 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:54717 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392AbZESJsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 05:48:12 -0400
To: jblunck@suse.de
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@zeniv.linux.org.uk, bharata@in.ibm.com, dwmw2@infradead.org,
       mszeredi@suse.cz, vaurora@redhat.com
In-reply-to: <1242662968-11684-1-git-send-email-jblunck@suse.de> (message from
	Jan Blunck on Mon, 18 May 2009 18:08:56 +0200)
Subject: Re: [PATCH 00/32] VFS based Union Mount (V3)
References: <1242662968-11684-1-git-send-email-jblunck@suse.de>
Message-Id: <E1M6LvU-0000mN-HN@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 19 May 2009 11:48:00 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 May 2009, Jan Blunck wrote:
> Here is another post of the VFS based union mount implementation.
> 
> Traditionally the mount operation is opaque, which means that the content of
> the mount point, the directory where the file system is mounted on, is hidden
> by the content of the mounted file system's root directory until the file
> system is unmounted again. Unlike the traditional UNIX mount mechanism, that
> hides the contents of the mount point, a union mount presents a view as if
> both filesystems are merged together. Although only the topmost layer of the
> mount stack can be altered, it appears as if transparent file system mounts
> allow any file to be created, modified or deleted.
> 
> Most people know the concepts and features of union mounts from other
> operating systems like Sun's Translucent Filesystem, Plan9 or BSD. For an
> in-depth review of union mounts and other unioning file systems, see:
> 
> http://lwn.net/Articles/324291/
> http://lwn.net/Articles/325369/
> http://lwn.net/Articles/327738/
> 
> Here are the key features of this implementation:
> - completely VFS based
> - does not change the namespace stacking
> - directory listings have duplicate entries removed in the kernel
> - writable unions: only the topmost file system layer may be writable
> - writable unions: new whiteout filetype handled inside the kernel
> 
> Major changes since last post:
> - Updated the whiteout patches:
>   - DCACHE_WHITEOUT flag set on a negative dentry
>   - uses filetype instead of reserved inode number on EXT2
> - Copy-up directories during lookup
> - Implemented fallthru support for in-kernel readdir() as proposed by
>   Valerie Aurora (Henson)

Does this copy up directories persistently?  If so, does this
implementation no longer supports union of all read-only branches?

Thanks,
Miklos
