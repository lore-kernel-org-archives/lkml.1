Return-Path: <linux-kernel-owner+w=401wt.eu-S1758002AbZFMNrW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758002AbZFMNrW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 09:47:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753793AbZFMNrQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 09:47:16 -0400
Received: from fifo99.com ([67.223.236.141]:51481 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753572AbZFMNrQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 09:47:16 -0400
X-Greylist: delayed 342 seconds by postgrey-1.27 at vger.kernel.org; Sat, 13 Jun 2009 09:47:15 EDT
Subject: Re: [PATCH 05/14] Pramfs: File operations for files
From: Daniel Walker <dwalker@fifo99.com>
To: Marco <marco.stornelli@gmail.com>
Cc: Linux FS Devel <linux-fsdevel@vger.kernel.org>,
       Linux Embedded <linux-embedded@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <4A33A7E2.9020803@gmail.com>
References: <4A33A7E2.9020803@gmail.com>
Content-Type: text/plain
Date: Sat, 13 Jun 2009 06:47:17 -0700
Message-Id: <1244900837.5982.213.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-06-13 at 15:21 +0200, Marco wrote:
> From: Marco Stornelli <marco.stornelli@gmail.com>
> 
> File operations for files.
> 
> Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
> ---
> 
> diff -uprN linux-2.6.30-orig/fs/pramfs/file.c linux-2.6.30/fs/pramfs/file.c
> --- linux-2.6.30-orig/fs/pramfs/file.c	1970-01-01 01:00:00.000000000 +0100
> +++ linux-2.6.30/fs/pramfs/file.c	2009-06-13 12:52:56.000000000 +0200
> @@ -0,0 +1,141 @@
> +/*
> + * FILE NAME fs/pramfs/file.c
> + *
> + * BRIEF DESCRIPTION
> + *
> + * File operations for files.
> + *
> + * Copyright 2009 Marco Stornelli <marco.stornelli@gmail.com>
> + * Copyright 2003 Sony Corporation
> + * Copyright 2003 Matsushita Electric Industrial Co., Ltd.
> + * 2003-2004 (c) MontaVista Software, Inc. , Steve Longerbeam
> + * This file is licensed under the terms of the GNU General Public
> + * License version 2. This program is licensed "as is" without any
> + * warranty of any kind, whether express or implied.
> + */
> +#include <linux/fs.h>
> +#include <linux/sched.h>
> +#include <linux/slab.h>
> +#include <linux/uio.h>
> +#include <linux/uaccess.h>
> +#include "pram_fs.h"
> +#include "xip.h"

It would be cleaner if the xip.h include was added in patch 14 of 14,
since that's the XIP support patch.

> +static int pram_open_file(struct inode *inode, struct file *filp)
> +{
> +#ifndef CONFIG_PRAMFS_XIP
> +	/* Without XIP we force to use Direct IO */
> +	filp->f_flags |= O_DIRECT;
> +#endif

Same as above .. It's better to have all the support for a given feature
all in the same patch. The rest of your patches are dotted with these
bits of code that should really be refactored into other patches.

Daniel

