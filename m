Return-Path: <linux-kernel-owner+w=401wt.eu-S1753865AbXFKU0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753865AbXFKU0T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 16:26:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751533AbXFKU0M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 16:26:12 -0400
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:46766 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919AbXFKU0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 16:26:11 -0400
Message-ID: <466DAEDE.8050500@gmail.com>
Date: Mon, 11 Jun 2007 22:21:50 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070509)
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>
CC: Jan Engelhardt <jengelh@computergmbh.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andy Whitcroft <apw@shadowen.org>, Steve Fox <drfickle@us.ibm.com>,
       Mel Gorman <mel@csn.ul.ie>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] move the kernel to 16MB for NUMA-Q
References: <466D550C.4030600@shadowen.org> <63a08cc7547f14065becdf9a94d0d529@pinky> <20070611091558.f468f205.akpm@linux-foundation.org> <20070611172006.GI9174@redhat.com> <466D882D.70001@zytor.com> <Pine.LNX.4.64.0706112019310.19578@fbirervta.pbzchgretzou.qr> <20070611184621.GA25371@redhat.com> <466DAB95.2040909@gmail.com>
In-Reply-To: <466DAB95.2040909@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/11/2007 10:07 PM, Rene Herman wrote:

> But, it's just a default anyway. Would it be considered beneficial to 
> more explicitly provide a few options through a config menu, something 
> like the attached?

Ehm, so now where did that long help actually end up? :-|

If the notion is considered okay, this wants someone with a little more 
Kconfig insight it seems.

> diff --git a/arch/i386/Kconfig b/arch/i386/Kconfig
> index 8770a5d..6737529 100644
> --- a/arch/i386/Kconfig
> +++ b/arch/i386/Kconfig
> @@ -813,9 +813,10 @@ config CRASH_DUMP
>            PHYSICAL_START.
>  	  For more details see Documentation/kdump/kdump.txt
>  
> -config PHYSICAL_START
> -	hex "Physical address where the kernel is loaded" if (EMBEDDED || CRASH_DUMP)
> -	default "0x100000"
> +choice
> +	depends on EMBEDDED || CRASH_DUMP
> +	prompt "Physical address where the kernel is loaded"
> +	default PHYSICAL_START_1M
>  	help
>  	  This gives the physical address where the kernel is loaded.
>  
> @@ -854,6 +855,40 @@ config PHYSICAL_START
>  
>  	  Don't change this unless you know what you are doing.
>  
> +	config PHYSICAL_START_1M
> +		bool "1M"
> +		help
> +		  Choose this to load the kernel at the standard 1M address.
> +
> +	config PHYSICAL_START_4M
> +		bool "4M"
> +		help
> +		  Loading the kernel at a 4M aligned physical address can
> +		  make for a slightly faster kernel.
> +
> +		  Choose this if you have 8M or more installed.
> +
> +	config PHYSICAL_START_16M
> +		bool "16M"
> +		help
> +		  Loading the kernel at a 4M aligned physical address can
> +		  make for a slightly faster kernel.
> +
> +		  Additionally, loading it at 16M gets it out of the legacy
> +		  DMA zone which you might consider beneficial if you use
> +		  devices doing legacy DMA (such as a floppy drive, an ECP
> +		  parallel port or DMA capable ISA peripherals).
> +
> +		  Choose this if you have 20M or more installed and a need
> +		  for legacy DMA.
> +endchoice
> +
> +config PHYSICAL_START
> +	hex
> +	default "0x100000" if PHYSICAL_START_1M
> +	default "0x400000" if PHYSICAL_START_4M
> +	default "0x1000000" if PHYSICAL_START_16M
> +
>  config RELOCATABLE
>  	bool "Build a relocatable kernel(EXPERIMENTAL)"
>  	depends on EXPERIMENTAL

Rene.
