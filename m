Return-Path: <linux-kernel-owner+w=401wt.eu-S1754301AbYGZJhq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754301AbYGZJhq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 05:37:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751560AbYGZJhj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 05:37:39 -0400
Received: from in.cluded.net ([195.159.98.120]:52366 "EHLO in.cluded.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751447AbYGZJhi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 05:37:38 -0400
X-Greylist: delayed 1197 seconds by postgrey-1.27 at vger.kernel.org; Sat, 26 Jul 2008 05:37:37 EDT
Message-ID: <488AEA54.2030703@uw.no>
Date: Sat, 26 Jul 2008 09:11:48 +0000
From: "Daniel K." <dk@uw.no>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9a1) Gecko/20060307 SeaMonkey/1.5a
MIME-Version: 1.0
To: Peter Oruba <peter.oruba@amd.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch 8/9] [PATCH 8/9] x86: Major refactoring.
References: <20080725161723.636932280@amd.com> <20080725162003.347794240@amd.com>
In-Reply-To: <20080725162003.347794240@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Oruba wrote:
> Refactored code by introducing a two-module solution. There is one
> general module in which vendor specific modules can hook into.
>  
>  config MICROCODE
> -	tristate "/dev/cpu/microcode - Intel IA32 CPU microcode support"
> +	tristate "/dev/cpu/microcode - microcode support"
>  	select FW_LOADER
>  	---help---
>  	  If you say Y here, you will be able to update the microcode on
> @@ -791,14 +791,28 @@ config MICROCODE
>  	  actual microcode binary data itself which is not shipped with the
>  	  Linux kernel.
>  
> -	  For latest news and information on obtaining all the required
> -	  ingredients for this driver, check:
> -	  <http://www.urbanmyth.org/microcode/>.
> +	  This option selects the general module only, you need to select
> +	  at least one vendor specific module as well.
>  
>  	  To compile this driver as a module, choose M here: the
>  	  module will be called microcode.
>  
> -config MICROCODE_OLD_INTERFACE
> +config MICROCODE_INTEL
> +       tristate "Intel microcode patch loading support"
> +       depends on MICROCODE

	default MICROCODE

so that users doing make oldconfig don't get a surprise?

> +       select FW_LOADER
> +       --help---
> +         This options enables microcode patch loading support for Intel
> +         processors.
> +
> +         For latest news and information on obtaining all the required
> +         Intel ingredients for this driver, check:
> +         <http://www.urbanmyth.org/microcode/>.
> +
> +         This driver is only available as a module: the module
> +         will be called microcode_intel.  
> +
> +   config MICROCODE_OLD_INTERFACE

Kill the extra spaces.


Daniel K.
