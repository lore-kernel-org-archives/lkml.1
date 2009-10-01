Return-Path: <linux-kernel-owner+w=401wt.eu-S1756400AbZJATpz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756400AbZJATpz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 15:45:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756347AbZJATpy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 15:45:54 -0400
Received: from smtp2.caviumnetworks.com ([209.113.159.134]:17109 "EHLO
	smtp2.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752952AbZJATpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 15:45:54 -0400
Message-ID: <4AC506B2.2040409@caviumnetworks.com>
Date: Thu, 01 Oct 2009 12:44:50 -0700
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC PATCH] kernel.h: Add pr_debug_noopt
References: <1254424323.1799.84.camel@Joe-Laptop.home>
In-Reply-To: <1254424323.1799.84.camel@Joe-Laptop.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Oct 2009 19:44:51.0347 (UTC) FILETIME=[A42BAE30:01CA42CF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches wrote:
> Many times a developer always wants to emit a KERN_DEBUG level
> logging message even if DEBUG is not defined.
> 
> These messages today do not have a "pr_<level>" equivalent
> and must be coded with printk(KERN_DEBUG.
> 
> This means that pr_fmt is not used with these logging messages.
> 
> I propose a new shortcut #define pr_<level> be added to kernel.h
> to handle these KERN_DEBUG cases not prefixed with pr_fmt.
> 
> I'm not happy with the name.  Some good alternatives are
> already in use in a couple of places.
> 
> pr_dbg is #defined in drivers/char/isicom.c
> pr_vdebug is #defined in drivers/usb/gadget/u_serial.c
> 
> I think it's appropriate to remove and substitute one
> or both of these #defines from the files in drivers
> and use one or both in kernel.h
> 
> Suggestions?
> 
> diff --git a/include/linux/kernel.h b/include/linux/kernel.h
> index d3cd23f..f1f53b9 100644
> --- a/include/linux/kernel.h
> +++ b/include/linux/kernel.h
> @@ -380,6 +380,8 @@ static inline char *pack_hex_byte(char *buf, u8 byte)
>          printk(KERN_NOTICE pr_fmt(fmt), ##__VA_ARGS__)
>  #define pr_info(fmt, ...) \
>          printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
> +#define pr_debug_noopt(fmt, ...) \
> +	printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)


To me, 'noopt' is too much like 'nop'.

How about 'mand' or 'ungated' or something similar?

In general I like the concept.

David Daney
