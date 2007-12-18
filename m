Return-Path: <linux-kernel-owner+w=401wt.eu-S1755532AbXLRMji@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755532AbXLRMji (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 07:39:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752630AbXLRMjb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 07:39:31 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:43449 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752063AbXLRMjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 07:39:31 -0500
Date: Tue, 18 Dec 2007 13:39:29 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: wit <is01kzh@gmail.com>
cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: About mounting the sysfs
In-Reply-To: <105610bf0712172310ob56ae9ch4fa63e132011ae18@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0712181337090.32270@fbirervta.pbzchgretzou.qr>
References: <105610bf0712172310ob56ae9ch4fa63e132011ae18@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Dec 18 2007 15:10, wit wrote:
>
>1. What is the d_alloc_root used for? Actually, the question should
>be: why we have to call d_alloc_root.

>I think the root already has its dentry,

It does not.

>why we have to allocate another while we mounting a file
>system?
>
>2. Why we call d_alloc_root to allocate a dentry for the mount point
>while the usual mount point of sysfs is defined by the user (something
>like /sysfs but not /).

/sys is a dentry that belongs to the / vfsmount, but we need a
/ that belongs to the <whatever you are going to mount> vfsmount.

> See below:
>	root = d_alloc_root(inode);
>	if (!root) {
>		pr_debug("%s: could not get root dentry!\n",__FUNCTION__);
>		iput(inode);
>		return -ENOMEM;
>	}
>	root->d_fsdata = &sysfs_root;
>	sb->s_root = root;
>
>does this means settting the sysfs' mount point to "/" but not "/sysfs".
