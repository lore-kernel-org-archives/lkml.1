Return-Path: <linux-kernel-owner+w=401wt.eu-S1756993AbZBTJw2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756993AbZBTJw2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 04:52:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755806AbZBTJwE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 04:52:04 -0500
Received: from verein.lst.de ([213.95.11.210]:56674 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754126AbZBTJwB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 04:52:01 -0500
Date: Fri, 20 Feb 2009 10:51:58 +0100
From: Christoph Hellwig <hch@lst.de>
To: Takashi Sato <t-sato@yk.jp.nec.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix FREEZE/THAW compat_ioctl regression
Message-ID: <20090220095158.GA9587@lst.de>
References: <20090216125725.GA3420@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090216125725.GA3420@lst.de>
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.001 () BAYES_44,UPPERCASE_25_50
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So who's going to send this to Linus?  Having freeze/thaw regressed in
2.6.29 would be very sad for all the xfs users.

On Mon, Feb 16, 2009 at 01:57:25PM +0100, Christoph Hellwig wrote:
> Commit 8e961870bb9804110d5c8211d5d9d500451c4518 removed the FREEZE/THAW
> handling in xfs_compat_ioctl but never added any compat handler back, so
> now any freeze/thaw request from a 32-bit binary ond 64-bit userspace
> will fail.
> 
> As these ioctls are 32/64-bit compatible two simple COMPATIBLE_IOCTL
> entries in fs/compat_ioctl.c will do the job.
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Index: xfs/fs/compat_ioctl.c
> ===================================================================
> --- xfs.orig/fs/compat_ioctl.c	2009-02-16 12:48:23.000000000 +0000
> +++ xfs/fs/compat_ioctl.c	2009-02-16 12:49:34.000000000 +0000
> @@ -1913,6 +1913,9 @@
>  /* 0x00 */
>  COMPATIBLE_IOCTL(FIBMAP)
>  COMPATIBLE_IOCTL(FIGETBSZ)
> +/* 'X' - originally XFS but some now in the VFS */
> +COMPATIBLE_IOCTL(FIFREEZE)
> +COMPATIBLE_IOCTL(FITHAW)
>  /* RAID */
>  COMPATIBLE_IOCTL(RAID_VERSION)
>  COMPATIBLE_IOCTL(GET_ARRAY_INFO)
---end quoted text---
