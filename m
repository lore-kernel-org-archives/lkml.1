Return-Path: <linux-kernel-owner+w=401wt.eu-S1758189AbXFISCI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758189AbXFISCI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 14:02:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754025AbXFISBv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 14:01:51 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:23071 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753527AbXFISBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 14:01:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=DXVLQ5ExpZ1XcAwKk/xwcPfLwj53BAc+5KuPLBfxzLgxm4JOksMDQ/IVOjqSENL/9D/nPOseIfRPYRng0FNIOwsscQzJpOfChZzuJU5MsT20s4SfapELLKB628afy/Y24CosUrzDA/w90eteaBcF2t9VnuAsPUjTjLPZ5uglrrA=
Date: Sat, 9 Jun 2007 22:03:18 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Jack Stone <jack@hawkeye.stone.uk.eu.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, Ian Kent <raven@themaw.net>
Subject: Re: [PATCH 6/7] Add pr_debug_pid to kernel.h
Message-ID: <20070609180318.GB5760@martell.zuzino.mipt.ru>
References: <4669D5B7.7050005@hawkeye.stone.uk.eu.org> <466A5E28.2000707@hawkeye.stone.uk.eu.org> <466A625C.4030700@hawkeye.stone.uk.eu.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <466A625C.4030700@hawkeye.stone.uk.eu.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 09, 2007 at 09:18:36AM +0100, Jack Stone wrote:
> This patch adds a new function to kernel.h. This function prints out the
> pid of the current process and the name of the function where it was
> called from followed by the debug message and a newline.

NO! We don't add macros for every debug format people use into core
headers. I think you should stop after pr_err().

> --- linux.orig/include/linux/kernel.h
> +++ linux/include/linux/kernel.h
> @@ -228,6 +228,8 @@ extern void print_hex_dump(const char *l
>  /* If you are writing a driver, please use dev_dbg instead */
>  #define pr_debug(fmt,arg...) \
>  	printk(KERN_DEBUG fmt,##arg)
> +#define pr_debug_pid(fmt,arg...) \
> +	printk(KERN_DEBUG "pid %d: %s: " fmt "\n" , current->pid ,
> __FUNCTION__, ##args)
>  #define pr_err(fmt,arg...) \
>  	printk(KERN_ERR fmt,##arg)
>  #else
> @@ -236,6 +238,11 @@ static inline int __attribute__ ((format
>  	return 0;
>  }
> 
> +static inline int __attribute__ ((format (printf, 1, 2)))
> pr_debug_pid(const char * fmt, ...)
> +{
> +	return 0;
> +}

