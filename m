Return-Path: <linux-kernel-owner+w=401wt.eu-S1760232AbYDAUKG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760232AbYDAUKG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 16:10:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758133AbYDAUJy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 16:09:54 -0400
Received: from nijmegen.renzel.net ([195.243.213.130]:48861 "EHLO
	nijmegen.renzel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756948AbYDAUJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 16:09:53 -0400
Message-ID: <47F29687.3060403@twisted-brains.org>
Date: Tue, 01 Apr 2008 22:09:43 +0200
From: mws@twisted-brains.org
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: Jason Baron <jbaron@redhat.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [patch 1/3] dynamic printk - core infrastructure
References: <20080401194951.GC12029@redhat.com>
In-Reply-To: <20080401194951.GC12029@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

Jason Baron schrieb:
> Add the ability to dynamically enable/disable pr_debug()/dev_dbg() in the
> kernel. Yes, these calls could be converted to printk(KERN_DEBUG), but there
> are enough to cause overhead. Additionally, the logs become difficult to read.
> Here, one can turn on and off these messages per .c source file via:
> 
> echo "add file.c" > /sys/kernel/debug/dynamic_printk/files
> echo "remove file.c" > /sys/kernel/debug/dynamic_printk/files
> 
> There is also a special 'all' value that turns on all the debugging messages.
> 
> Signed-off-by: Jason Baron <jbaron@redhat.com>
> ---
> 
--snip --

> diff --git a/include/linux/device.h b/include/linux/device.h
> index db375be..b007f61 100644
> --- a/include/linux/device.h
> +++ b/include/linux/device.h
> @@ -587,6 +587,17 @@ extern const char *dev_driver_string(struct device *dev);
>  #define dev_info(dev, format, arg...)		\
>  	dev_printk(KERN_INFO , dev , format , ## arg)
>  
> +#ifdef CONFIG_DYNAMIC_PRINTK
> +extern void dyanmic_printk(char *, char *, ...);

this external should be dynamic_printk (typo), shouldn't it?

regards
marcel



