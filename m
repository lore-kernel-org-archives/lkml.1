Return-Path: <linux-kernel-owner+w=401wt.eu-S933346AbXAaULF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933346AbXAaULF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 15:11:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933347AbXAaULF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 15:11:05 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:4498 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933346AbXAaULD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 15:11:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=gfUW69hMhdzUqXn10Ub5+kJD/ppdCCxkEPcfRNNWFJ5oMW+QgCypy4M8ccvqqljz0lpngrMWoaVw1q6cqp+/uopy0/Z61WmNitnsjauO4vqSnaeCJewdWoBSxLBEyM0qf9tu+K+MTePNze7JCb7i1UPLzOR007PJXRGQRHDh2GA=
Message-ID: <5157576d0701311210j737a3f40h63cef509dadc170f@mail.gmail.com>
Date: Wed, 31 Jan 2007 23:10:57 +0300
From: "Tomasz Kvarsin" <kvarsin@gmail.com>
To: "Andrew Morton" <akpm@osdl.org>, dcb314@hotmail.com
Subject: Re: fs/ufs/inode.c:817: warning: array subscript is above array bounds
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

d binderman wrote:
>Hello there,
>
>I just tried to compile Linux kernel 2.6.19.2 with the
>new GNU C compiler version 4.3 snapshot 20070126.
>
>The compiler said
>
>fs/ufs/inode.c:817: warning: array subscript is above array bounds
>
>The source code is
>
>        for (i = 0; i < (UFS_NDADDR + UFS_NINDIR); i++)
>            ufs_inode->ui_u2.ui_addr.ui_db[i] = ufsi->i_u1.i_data[i];
>
>but
>
>./include/linux/ufs_fs.h:                       __fs32  ui_db[UFS_NDADDR];/*
>0x28 data blocks */
>./include/linux/ufs_fs.h:                       __fs64
>ui_db[UFS_NDADDR]; /* 112: Direct disk blocks. */
>
>and
>
>        __fs32  i_data[15];
>
>and
>
>#define UFS_NDADDR 12
>#define UFS_NINDIR 3
>
>so the kernel seems to be trying to write fifteen bytes into an array only
>twelve
>bytes in size. Suggest code rework.


As I see, linux-kernel is very high volume(noise?) list,
may better wil be resend to relevant mantainer(Andrew Morton?)
