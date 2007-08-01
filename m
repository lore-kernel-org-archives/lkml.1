Return-Path: <linux-kernel-owner+w=401wt.eu-S1756720AbXHAQ31@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756720AbXHAQ31 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 12:29:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754168AbXHAQ3J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 12:29:09 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:38472 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753687AbXHAQ3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 12:29:06 -0400
Date: Wed, 1 Aug 2007 09:32:33 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Randy Dunlap <rdunlap@xenotime.net>, Dave Jones <davej@redhat.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH] fix slown down printk on boot compile error
Message-Id: <20070801093233.98b1693a.randy.dunlap@oracle.com>
In-Reply-To: <20070801111644.GB12124@osiris.boeblingen.de.ibm.com>
References: <20070731230932.a9459617.akpm@linux-foundation.org>
	<20070801111644.GB12124@osiris.boeblingen.de.ibm.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Aug 2007 13:16:44 +0200 Heiko Carstens wrote:

> From: Heiko Carstens <heiko.carstens@de.ibm.com>
> 
> The slow-down-printk-during-boot patch depends on preset_lpj being
> available. That's not the case for architectures that have it's own
> calibrate_delay() function.
> 
> kernel/sched.c:3840: undefined reference to `preset_lpj'

Thanks.

> Cc: Randy Dunlap <rdunlap@xenotime.net>
> Cc: Dave Jones <davej@redhat.com>
> Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
> Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
> ---
>  lib/Kconfig.debug |    2 +-
>  1 files changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux-2.6.22/lib/Kconfig.debug
> ===================================================================
> --- linux-2.6.22.orig/lib/Kconfig.debug
> +++ linux-2.6.22/lib/Kconfig.debug
> @@ -436,7 +436,7 @@ config FORCED_INLINING
>  
>  config BOOT_PRINTK_DELAY
>  	bool "Delay each boot printk message by N milliseconds"
> -	depends on DEBUG_KERNEL && PRINTK
> +	depends on DEBUG_KERNEL && PRINTK && GENERIC_CALIBRATE_DELAY
>  	help
>  	  This build option allows you to read kernel boot messages
>  	  by inserting a short delay after each one.  The delay is

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
