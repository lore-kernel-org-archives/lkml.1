Return-Path: <linux-kernel-owner+w=401wt.eu-S933055AbXKOVIe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933055AbXKOVIe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 16:08:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754617AbXKOVIU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 16:08:20 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34770 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751718AbXKOVIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 16:08:19 -0500
Date: Thu, 15 Nov 2007 13:07:41 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Bradley Smith <bradjsmith@btinternet.com>
Cc: linux-kernel@vger.kernel.org, dz@debian.org
Subject: Re: [PATCH 2/2] I8K: Adds i8k driver to the x86_64 Kconfig
Message-Id: <20071115130741.34c24a6b.akpm@linux-foundation.org>
In-Reply-To: <20071028172613.236cac1b@debian.hob>
References: <20071028172613.236cac1b@debian.hob>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 28 Oct 2007 17:26:13 +0000
Bradley Smith <bradjsmith@btinternet.com> wrote:

> From: Bradley Smith <bradjsmith@btinternet.com>
> 
> Adds i8k driver to the x86_64 Kconfig.
> 
> Signed-off-by: Bradley Smith <bradjsmith@btinternet.com>
> 
> ---
> 
> Only applies on kernels >= 2.6.24.
> Depends on "[PATCH 1/2] I8K: Allow i8k driver to be built on x86_64 systems"
> 
> --- linux-2.6/arch/x86/Kconfig.x86_64.orig	2007-10-28 14:04:13.000000000 +0000
> +++ linux-2.6/arch/x86/Kconfig.x86_64	2007-10-28 13:59:06.000000000 +0000
> @@ -224,6 +224,26 @@ config X86_GOOD_APIC
>  	bool
>  	default y
>  
> +config I8K
> +	tristate "Dell laptop support"
> +	---help---
> +	  This adds a driver to safely access the System Management Mode
> +	  of the CPU on the Dell Inspiron 8000. The System Management Mode
> +	  is used to read cpu temperature and cooling fan status and to
> +	  control the fans on the I8K portables.
> +
> +	  This driver has been tested only on the Inspiron 8000 but it may
> +	  also work with other Dell laptops. You can force loading on other
> +	  models by passing the parameter `force=1' to the module. Use at
> +	  your own risk.
> +
> +	  For information on utilities to make use of this driver see the
> +	  I8K Linux utilities web site at:
> +	  <http://people.debian.org/~dz/i8k/>
> +
> +	  Say Y if you intend to run this kernel on a Dell Inspiron 8000.
> +	  Say N otherwise.
> +
>  config MICROCODE
>  	tristate "/dev/cpu/microcode - Intel CPU microcode support"
>  	select FW_LOADER

The i386 and x86_64 Kconfig files just got unified, so this patch became
agreeably simpler:



--- a/arch/x86/Kconfig~i8k-adds-i8k-driver-to-the-x86_64-kconfig
+++ a/arch/x86/Kconfig
@@ -641,7 +641,6 @@ config TOSHIBA
 
 config I8K
 	tristate "Dell laptop support"
-	depends on X86_32
 	---help---
 	  This adds a driver to safely access the System Management Mode
 	  of the CPU on the Dell Inspiron 8000. The System Management Mode
_

