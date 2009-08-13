Return-Path: <linux-kernel-owner+w=401wt.eu-S1752989AbZHMGoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752989AbZHMGoR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 02:44:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751928AbZHMGoQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 02:44:16 -0400
Received: from gate.crashing.org ([63.228.1.57]:52260 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751512AbZHMGoQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 02:44:16 -0400
Subject: Re: [PATCH] Disable PowerMac cpufreq on SMP kernels
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Bastian Blank <bastian@waldi.eu.org>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <20090811093931.GA15940@wavehammer.waldi.eu.org>
References: <20090811093931.GA15940@wavehammer.waldi.eu.org>
Content-Type: text/plain
Date: Thu, 13 Aug 2009 16:14:58 +1000
Message-Id: <1250144098.3587.111.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-08-11 at 11:39 +0200, Bastian Blank wrote:
> The build of a PowerMac 32bit kernel currently fails with
> 
> error: #warning "WARNING, CPUFREQ not recommended on SMP kernels"
> 
> This patch just disables this driver on SMP kernels, as it is obviously
> not supported.
> 
> Signed-off-by: Bastian Blank <waldi@debian.org>

Why not remove the #error instead ? :-) I don't think it's still
meaningful, especially since we use the timebase for delays nowadays
which doesn't depend on the CPU frequency...

Ben.

> diff --git a/arch/powerpc/platforms/Kconfig b/arch/powerpc/platforms/Kconfig
> index 04a8061..99d3564 100644
> --- a/arch/powerpc/platforms/Kconfig
> +++ b/arch/powerpc/platforms/Kconfig
> @@ -149,7 +149,7 @@ menu "CPU Frequency drivers"
>  
>  config CPU_FREQ_PMAC
>  	bool "Support for Apple PowerBooks"
> -	depends on ADB_PMU && PPC32
> +	depends on ADB_PMU && PPC32 && !SMP
>  	select CPU_FREQ_TABLE
>  	help
>  	  This adds support for frequency switching on Apple PowerBooks,
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

