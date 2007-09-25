Return-Path: <linux-kernel-owner+w=401wt.eu-S1759262AbXIYEF1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759262AbXIYEF1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 00:05:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751298AbXIYEFU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 00:05:20 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:32842 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751183AbXIYEFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 00:05:19 -0400
Date: Tue, 25 Sep 2007 06:05:37 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.linux-foundation.org>,
       Andi Kleen <ak@muc.de>
Subject: Re: [PATCH 1/3] Virtualization config cleanup: Select
	CONFIG_PARAVIRT when required
Message-ID: <20070925040537.GL6800@stusta.de>
References: <1190692688.27805.276.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1190692688.27805.276.camel@localhost.localdomain>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2007 at 01:58:08PM +1000, Rusty Russell wrote:
> (Unless there are complaints, I'll push this as part of the lguest
> patches for 2.6.24, since there are lguest config changes there too).
> 
> Andi points out that PARAVIRT is an option best selected when needed.
> 
> We introduce PARAVIRT_GUEST for the menu itself, and select PARAVIRT
> if the user turns on anything which needs it.
> 
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> ---
>  arch/i386/Kconfig     |   33 ++++++++++++++++++++-------------
>  arch/i386/xen/Kconfig |    1 +
>  2 files changed, 21 insertions(+), 13 deletions(-)
> 
> ===================================================================
> --- a/arch/i386/Kconfig
> +++ b/arch/i386/Kconfig
> @@ -214,24 +214,30 @@ config X86_ES7000
>  
>  endchoice
>  
> -menuconfig PARAVIRT
> +config PARAVIRT
> +	bool
> +	depends on !(X86_VISWS || X86_VOYAGER)
> +	help
> +	  This changes the kernel so it can modify itself when it is run
> +	  under a hypervisor, potentially improving performance significantly
> +	  over full virtualization.  However, when run without a hypervisor
> +	  the kernel is theoretically slower and slightly larger.
> +
> +menuconfig PARAVIRT_GUEST
> -	bool "Paravirtualized guest support (EXPERIMENTAL)"
> -	depends on EXPERIMENTAL
> +	bool "Paravirtualized guest support"
> -	depends on !(X86_VISWS || X86_VOYAGER)
> -	help
> -	  Paravirtualization is a way of running multiple instances of
> -	  Linux on the same machine, under a hypervisor.  This option
> -	  changes the kernel so it can modify itself when it is run
> -	  under a hypervisor, improving performance significantly.
> -	  However, when run without a hypervisor the kernel is
> -	  theoretically slower.  If in doubt, say N.
> -
> -if PARAVIRT
> +	help
> +	  Say Y here to get to see options related to running Linux under
> +	  various hypervisors.  This option alone does not add any kernel code.
> +
> +	  If you say N, all options in this submenu will be skipped and disabled.
> +
> +if PARAVIRT_GUEST
>  
>  source "arch/i386/xen/Kconfig"
>  
>  config VMI
>  	bool "VMI Guest support"
> +	select PARAVIRT


depends on !(X86_VISWS || X86_VOYAGER)

>  	help
>  	  VMI provides a paravirtualized interface to the VMware ESX server
>  	  (it could be used by other hypervisors in theory too, but is not
> @@ -239,6 +246,7 @@ config VMI
>  
>  config LGUEST_GUEST
>  	bool "Lguest guest support"
> +	select PARAVIRT
>  	depends on !X86_PAE


depends on !(X86_VISWS || X86_VOYAGER)

>  	help
>  	  Lguest is a tiny in-kernel hypervisor.  Selecting this will
> ===================================================================
> --- a/arch/i386/xen/Kconfig
> +++ b/arch/i386/xen/Kconfig
> @@ -4,6 +4,7 @@
>  
>  config XEN
>  	bool "Xen guest support"
> +	select PARAVIRT
>  	depends on X86_CMPXCHG && X86_TSC && !NEED_MULTIPLE_NODES

depends on !(X86_VISWS || X86_VOYAGER)

>  	help
>  	  This is the Linux Xen port.  Enabling this will allow the

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

