Return-Path: <linux-kernel-owner+w=401wt.eu-S1754136AbXFKEfT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754136AbXFKEfT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 00:35:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750726AbXFKEfH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 00:35:07 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:42512 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750709AbXFKEfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 00:35:06 -0400
X-Sasl-enc: 5/pQaANzp0Up1gu0kFPK6nkno4agjg/y1A6oSUQwSSRA 1181536502
Subject: Re: [PATCH 1/7] Add a new debug function to kernel.h
From: Ian Kent <raven@themaw.net>
To: Jack Stone <jack@hawkeye.stone.uk.eu.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com
In-Reply-To: <466A5F8A.4080700@hawkeye.stone.uk.eu.org>
References: <4669D5B7.7050005@hawkeye.stone.uk.eu.org>
	 <466A5E28.2000707@hawkeye.stone.uk.eu.org>
	 <466A5F8A.4080700@hawkeye.stone.uk.eu.org>
Content-Type: text/plain
Date: Mon, 11 Jun 2007 12:34:57 +0800
Message-Id: <1181536497.3423.10.camel@shark.themaw.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-06-09 at 09:06 +0100, Jack Stone wrote:
> This patch adds a new macro to print to KERN_ERR initially for ncp but
> others may want to use it

Yes, the patch set takes away local control of debug printing that I may
need to turn on for the module without re-compiling the kernel.

> 
> Signed-off-by: Jack Stone <jack@hawkeye.stone.uk.eu.org>
> ---
> Index: linux/include/linux/kernel.h
> ===================================================================
> --- linux.orig/include/linux/kernel.h
> +++ linux/include/linux/kernel.h
> @@ -228,11 +228,18 @@ extern void print_hex_dump(const char *l
>  /* If you are writing a driver, please use dev_dbg instead */
>  #define pr_debug(fmt,arg...) \
>  	printk(KERN_DEBUG fmt,##arg)
> +#define pr_err(fmt,arg...) \
> +	printk(KERN_ERR fmt,##arg)
>  #else
>  static inline int __attribute__ ((format (printf, 1, 2)))
> pr_debug(const char * fmt, ...)
>  {
>  	return 0;
>  }
> +
> +static inline int __attribute__ ((format (printf, 1, 2))) pr_err(const
> char * fmt, ...)
> +{
> +	return 0;
> +}
>  #endif
> 
>  #define pr_info(fmt,arg...) \
> 
> 

