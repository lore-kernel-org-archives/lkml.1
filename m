Return-Path: <linux-kernel-owner+w=401wt.eu-S1757886AbXLRPF6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757886AbXLRPF6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 10:05:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755072AbXLRPFv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 10:05:51 -0500
Received: from el-out-1112.google.com ([209.85.162.178]:14982 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753626AbXLRPFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 10:05:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=dx3LH38Rrs3XncsrmcqD/mj8WJL5eDhqw6W6f91QnPJIWsyu35wYt1jVI80PqiC5Unxzpcvfg7pXlnIWOdvH8zThfbbUPho52QyEeiw+StfxFBrNm0VEGP8H63b9n4Vf8YpybOhsBSDuLiY0DUnUon3Mq2wtunFyiAnLlZCCBvM=
Message-ID: <105610bf0712180705m7d007bf0webee723005f77fef@mail.gmail.com>
Date: Tue, 18 Dec 2007 23:05:48 +0800
From: Zhanhua <is01kzh@gmail.com>
To: "Jan Engelhardt" <jengelh@computergmbh.de>
Subject: Re: About mounting the sysfs
Cc: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0712181337090.32270@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <105610bf0712172310ob56ae9ch4fa63e132011ae18@mail.gmail.com>
	 <Pine.LNX.4.64.0712181337090.32270@fbirervta.pbzchgretzou.qr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2007/12/18, Jan Engelhardt <jengelh@computergmbh.de>:
>
> On Dec 18 2007 15:10, wit wrote:
> >
> >1. What is the d_alloc_root used for? Actually, the question should
> >be: why we have to call d_alloc_root.
>
> >I think the root already has its dentry,
>
> It does not.
There's no dentry for the "/"? I mean the rootfs.

>
> >why we have to allocate another while we mounting a file
> >system?
> >
> >2. Why we call d_alloc_root to allocate a dentry for the mount point
> >while the usual mount point of sysfs is defined by the user (something
> >like /sysfs but not /).
>
> /sys is a dentry that belongs to the / vfsmount, but we need a
> / that belongs to the <whatever you are going to mount> vfsmount.

Why we need such a vfsmount (for the "/", not the rootfs)? And where
we store the mount point info (path) when mount_root, s_root and the
mnt_mountpoint are all points to the "/" which is allocated by
d_alloc_root? Or do we have to store such info? Why?

>
> > See below:
> >       root = d_alloc_root(inode);
> >       if (!root) {
> >               pr_debug("%s: could not get root dentry!\n",__FUNCTION__);
> >               iput(inode);
> >               return -ENOMEM;
> >       }
> >       root->d_fsdata = &sysfs_root;
> >       sb->s_root = root;
> >
> >does this means settting the sysfs' mount point to "/" but not "/sysfs".
>
