Return-Path: <linux-kernel-owner+w=401wt.eu-S1030584AbXAaVYl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030584AbXAaVYl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 16:24:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030586AbXAaVYl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 16:24:41 -0500
Received: from smtp.osdl.org ([65.172.181.24]:52028 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030584AbXAaVYk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 16:24:40 -0500
Date: Wed, 31 Jan 2007 13:24:32 -0800
From: Andrew Morton <akpm@osdl.org>
To: "Tomasz Kvarsin" <kvarsin@gmail.com>
Cc: dcb314@hotmail.com, linux-kernel@vger.kernel.org,
       Evgeniy Dushistov <dushistov@mail.ru>
Subject: Re: fs/ufs/inode.c:817: warning: array subscript is above array
 bounds
Message-Id: <20070131132432.e2dc4058.akpm@osdl.org>
In-Reply-To: <5157576d0701311210j737a3f40h63cef509dadc170f@mail.gmail.com>
References: <5157576d0701311210j737a3f40h63cef509dadc170f@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Jan 2007 23:10:57 +0300
"Tomasz Kvarsin" <kvarsin@gmail.com> wrote:

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

Evgeniy, please consider raising a patch against ./MAINTAINERS ;)
