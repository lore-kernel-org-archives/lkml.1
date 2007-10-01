Return-Path: <linux-kernel-owner+w=401wt.eu-S1756057AbXJAT4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756057AbXJAT4T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 15:56:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755381AbXJAT4E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 15:56:04 -0400
Received: from mail-gw1.sa.eol.hu ([212.108.200.67]:45790 "EHLO
	mail-gw1.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754259AbXJAT4C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 15:56:02 -0400
To: haveblue@us.ibm.com
CC: linux-kernel@vger.kernel.org, hch@infradead.org, miklos@szeredi.hu,
       haveblue@us.ibm.com
In-reply-to: <20070928181333.F3073089@kernel> (message from Dave Hansen on
	Fri, 28 Sep 2007 11:13:33 -0700)
Subject: Re: [RFC][PATCH 3/8] move mnt_want_write() out of may_open()
References: <20070928181330.27B367AC@kernel> <20070928181333.F3073089@kernel>
Message-Id: <E1IcRMo-0000Qm-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 01 Oct 2007 21:55:46 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> @@ -1687,10 +1679,8 @@ static int open_namei_create(struct name
>  	struct dentry *dir = nd->dentry;
>  
>  	/*
> -	 * This ensures that the mnt stays writable
> -	 * over the vfs_create() call to may_open(),
> -	 * which takes a more persistent
> -	 * mnt_want_write().
> +	 * This mnt_want_write() is potentially persistent,
> +	 * and balanced in __fput()
>  	 */
>  	error = mnt_want_write(nd->mnt);
>  	if (error) {

I'm confused: isn't it the mnt_want_write() in __dentry_open(), that
is balanced in __fput()?

Miklos
