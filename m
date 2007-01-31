Return-Path: <linux-kernel-owner+w=401wt.eu-S1161031AbXAaVcE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161031AbXAaVcE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 16:32:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161037AbXAaVcE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 16:32:04 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:57030 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161031AbXAaVcC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 16:32:02 -0500
Date: Wed, 31 Jan 2007 13:27:35 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "Tomasz Kvarsin" <kvarsin@gmail.com>
Cc: "Andrew Morton" <akpm@osdl.org>, dcb314@hotmail.com,
       linux-kernel@vger.kernel.org, dushistov@mail.ru
Subject: Re: fs/ufs/inode.c:817: warning: array subscript is above array
 bounds
Message-Id: <20070131132735.6d22c90a.randy.dunlap@oracle.com>
In-Reply-To: <5157576d0701311210j737a3f40h63cef509dadc170f@mail.gmail.com>
References: <5157576d0701311210j737a3f40h63cef509dadc170f@mail.gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.0 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Jan 2007 23:10:57 +0300 Tomasz Kvarsin wrote:

> d binderman wrote:
> >Hello there,
> >
> >I just tried to compile Linux kernel 2.6.19.2 with the
> >new GNU C compiler version 4.3 snapshot 20070126.
> >
> >The compiler said
> >
> >fs/ufs/inode.c:817: warning: array subscript is above array bounds
> >
> >The source code is
> >
> >        for (i = 0; i < (UFS_NDADDR + UFS_NINDIR); i++)
> >            ufs_inode->ui_u2.ui_addr.ui_db[i] = ufsi->i_u1.i_data[i];
> >
> >but
> >
> >./include/linux/ufs_fs.h:                       __fs32  ui_db[UFS_NDADDR];/*
> >0x28 data blocks */
> >./include/linux/ufs_fs.h:                       __fs64
> >ui_db[UFS_NDADDR]; /* 112: Direct disk blocks. */
> >
> >and
> >
> >        __fs32  i_data[15];
> >
> >and
> >
> >#define UFS_NDADDR 12
> >#define UFS_NINDIR 3
> >
> >so the kernel seems to be trying to write fifteen bytes into an array only
> >twelve
> >bytes in size. Suggest code rework.
> 
> 
> As I see, linux-kernel is very high volume(noise?) list,
> may better wil be resend to relevant mantainer(Andrew Morton?)

UFS doesn't have a known maintainer in the MAINTAINERS file.
The last big patcher of it is:
  Evgeniy Dushistov <dushistov@mail.ru>


---
~Randy
