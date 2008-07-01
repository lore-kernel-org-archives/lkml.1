Return-Path: <linux-kernel-owner+w=401wt.eu-S1754902AbYGAMUu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754902AbYGAMUu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 08:20:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754119AbYGAMUm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 08:20:42 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:39279 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753676AbYGAMUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 08:20:42 -0400
Date: Tue, 1 Jul 2008 08:20:40 -0400
From: Christoph Hellwig <hch@infradead.org>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/7] fat: Fix VFAT_IOCTL_READDIR_xxx and cleanup for
	userland
Message-ID: <20080701122039.GB25580@infradead.org>
References: <9edbdefc3e848699cfe111608.ps@mail.parknet.co.jp> <129170883e848699cff211608.ps@mail.parknet.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <129170883e848699cff211608.ps@mail.parknet.co.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  
>  #include <linux/magic.h>
> +#include <asm/byteorder.h>

Why do we need this in the user-visible part of the header?

> +struct __fat_dirent {
> +	long		d_ino;
> +	__kernel_off_t	d_off;
> +	unsigned short	d_reclen;
> +	char		d_name[256]; /* We must not include limits.h! */
> +};

Any reason this is not called fat_dirent? 

