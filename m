Return-Path: <linux-kernel-owner+w=401wt.eu-S1758069AbZBXN6w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758069AbZBXN6w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 08:58:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757511AbZBXN6g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 08:58:36 -0500
Received: from vsmtp04.dti.ne.jp ([202.216.231.139]:43814 "EHLO
	vsmtp04.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757120AbZBXN6f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 08:58:35 -0500
From: hooanon05@yahoo.co.jp
Subject: Re: New filesystem for Linux kernel 
To: Tarkan Erimer <tarkan.erimer@turknet.net.tr>
Cc: Miklos Szeredi <miklos@szeredi.hu>, tomas@slax.org,
       akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <49A3FA10.4090801@turknet.net.tr>
References: <7558.1235374266@jrobl> <7769.1235374482@jrobl> <49A268A7.1010708@slax.org> <49A26ACC.90804@slax.org> <49A3AC14.2050107@slax.org> <E1Lbvpf-0006fF-Tg@pomaz-ex.szeredi.hu> <11287.1235481490@jrobl> <49A3FA10.4090801@turknet.net.tr>
Date: Tue, 24 Feb 2009 22:57:40 +0900
Message-ID: <12063.1235483860@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Tarkan Erimer:
> I think there is a misunderstanding or confusion about merging the code 
> into the mainline. You needn't to drop some functionality/features to 
> make your code small and to make it reviewed by mergers. You have to 
> separate (Core FS functions, features etc.) your code into small pieces. 
> So that, mergers will look, for first, your core FS functionality code 
> to see that it *_breaks_* or *_touches_* any _*other areas of the 
> kernel*_. If everything goes well, your main Core FS functionality code 
> will be merged into the mainline. After that, you can send your 
> feature/functionality codes one by one.

Tarkan, thank you for your advise.
Actually I broke functions and files into small pieces. Additionally I
applied CONFIG_AUFS_* conditions in fs/aufs/Makefile. When you review
aufs source files, I'd suggest you to read in this order.

aufs-y := module.o sbinfo.o super.o branch.o xino.o sysaufs.o opts.o \
	wkq.o vfsub.o dcsub.o \
	cpup.o whout.o plink.o wbr_policy.o \
	dinfo.o dentry.o \
	finfo.o file.o f_op.o \
	dir.o vdir.o \
	iinfo.o inode.o i_op.o i_op_add.o i_op_del.o i_op_ren.o \
	ioctl.o
aufs-$(CONFIG_SYSFS) += sysfs.o
aufs-$(CONFIG_AUFS_BDEV_LOOP) += loop.o
aufs-$(CONFIG_AUFS_HINOTIFY) += hinotify.o
aufs-$(CONFIG_AUFS_DEBUG) += debug.o
aufs-$(CONFIG_AUFS_MAGIC_SYSRQ) += sysrq.o

If I am still misunderstanding, please let me know.

Thank you
J. R. Okajima
