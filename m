Return-Path: <linux-kernel-owner+w=401wt.eu-S1753446AbYKGHLr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753446AbYKGHLr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 02:11:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751265AbYKGHLh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 02:11:37 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43841 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750861AbYKGHLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 02:11:36 -0500
Date: Thu, 6 Nov 2008 23:11:02 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Hitoshi Mitake <mitake@clustcom.com>
Cc: Doug Thompson <norsk5@yahoo.com>, dougthompson@xmission.com,
       linux-kernel@vger.kernel.org, ktaka@clustcom.com
Subject: Re: [PATCH 1/1] edac x38: new MC driver module
Message-Id: <20081106231102.aab83cd4.akpm@linux-foundation.org>
In-Reply-To: <20081107153824.0ec934e6.mitake@clustcom.com>
References: <20081105222911.d76e7e1c.mitake@clustcom.com>
	<413709.12821.qm@web50106.mail.re2.yahoo.com>
	<20081106164641.ed369060.akpm@linux-foundation.org>
	<20081107152830.a42766f3.mitake@clustcom.com>
	<20081106223122.8a255211.akpm@linux-foundation.org>
	<20081107153824.0ec934e6.mitake@clustcom.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Nov 2008 15:38:24 +0000 Hitoshi Mitake <mitake@clustcom.com> wrote:

> 
> This patch makes x38_edac.c to use kernel's
> readq() function when it is compiled for x86_64.
> 
> Signed-off-by: Hitoshi Mitake <mitake@clustcom.com>
> Signed-off-by: Doug Thompson <dougthompson@xmission.com>
> ---
> 
> Index: linux-2.6.28-rc3-git2/drivers/edac/Kconfig
> ===================================================================
> --- linux-2.6.28-rc3-git2.orig/drivers/edac/Kconfig	2008-11-07 11:27:05.000000000 +0000
> +++ linux-2.6.28-rc3-git2/drivers/edac/Kconfig	2008-11-07 11:27:14.000000000 +0000
> @@ -104,7 +104,7 @@
>  
>  config EDAC_X38
>  	tristate "Intel X38"
> -	depends on EDAC_MM_EDAC && PCI && X86
> +	depends on EDAC_MM_EDAC && PCI && (X86 || X86_64)

CONFIG_X86 is true for both CONFIG_X86_32=y amek CONFIG_X86_64=y, so
this change isn't needed.  I'll fix that up.

> --- linux-2.6.28-rc3-git2.orig/drivers/edac/x38_edac.c	2008-11-07 11:27:06.000000000 +0000
> +++ linux-2.6.28-rc3-git2/drivers/edac/x38_edac.c	2008-11-07 11:27:29.000000000 +0000
> @@ -162,10 +162,12 @@
>  			 X38_ERRSTS_BITS);
>  }
>  
> -static u64 x38_readq(const void __iomem *addr)
> +#ifndef CONFIG_X86_64
> +static u64 readq(const void __iomem *addr)

hm, it'd be nice if there was some more general way of determining
whether the architecture provides readq/writeq.

