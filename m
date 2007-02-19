Return-Path: <linux-kernel-owner+w=401wt.eu-S932067AbXBSKyr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932067AbXBSKyr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 05:54:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932068AbXBSKyr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 05:54:47 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:33748 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932067AbXBSKyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 05:54:46 -0500
Date: Mon, 19 Feb 2007 10:54:45 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Artem Bityutskiy <dedekind@infradead.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@infradead.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 05/44 take 2] [UBI] internal common header
Message-ID: <20070219105445.GA16930@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Artem Bityutskiy <dedekind@infradead.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Frank Haverkamp <haver@vnet.ibm.com>,
	Josh Boyer <jwboyer@linux.vnet.ibm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	David Woodhouse <dwmw2@infradead.org>
References: <20070217165424.5845.4390.sendpatchset@localhost.localdomain> <20070217165449.5845.18238.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070217165449.5845.18238.sendpatchset@localhost.localdomain>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 17, 2007 at 06:54:49PM +0200, Artem Bityutskiy wrote:
> +#ifndef __UBI_UBI_H__
> +#define __UBI_UBI_H__
> +
> +#include <linux/mtd/ubi.h>
> +
> +/* Version of this UBI implementation */
> +#define UBI_VERSION 1

We shouldn't have versions for inkernel interfaces.

> +/* UBI messages printk level */
> +#define UBI_MSG_LEVEL  KERN_INFO
> +#define UBI_WARN_LEVEL KERN_WARNING
> +#define UBI_ERR_LEVEL  KERN_ERR

Please use the KERN_ macros directly.

> +/* Normal UBI messages */
> +#define ubi_msg(fmt, ...)                                                   \
> +	printk(UBI_MSG_LEVEL UBI_MSG_PREF " " fmt "\n", ##__VA_ARGS__)
> +/* UBI warning messages */
> +#define ubi_warn(fmt, ...)                                                  \
> +	printk(UBI_WARN_LEVEL UBI_WARN_PREF " %s: " fmt "\n", __FUNCTION__, \
> +	       ##__VA_ARGS__)
> +/* UBI error messages */
> +#define ubi_err(fmt, ...)                                                   \
> +	printk(UBI_ERR_LEVEL UBI_ERR_PREF " %s " fmt "\n", __FUNCTION__,    \
> +	       ##__VA_ARGS__)

you should probably use dev_printk and the wrappers around it in most
places.

> +extern int ubis_num;
> +extern struct ubi_info *ubis[UBI_MAX_INSTANCES];

Having this kind of global information directly exposed is a very
bad idea.  In general you only want to access it through more
specific information and avoid allocating the global array at all.

