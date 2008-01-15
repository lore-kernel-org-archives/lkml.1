Return-Path: <linux-kernel-owner+w=401wt.eu-S1756719AbYAOUVj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756719AbYAOUVj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 15:21:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751802AbYAOUVc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 15:21:32 -0500
Received: from nwd2mail10.analog.com ([137.71.25.55]:32042 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076AbYAOUVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 15:21:31 -0500
X-IronPort-AV: E=Sophos;i="4.24,288,1196658000"; 
   d="scan'208";a="60194728"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "Mathieu Desnoyers" <mathieu.desnoyers@polymtl.ca>
Subject: Re: Fix Blackfin HARDWARE_PM support
Date: Tue, 15 Jan 2008 15:22:38 -0500
User-Agent: KMail/1.9.5
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Adrian Bunk" <adrian.bunk@movial.fi>,
       "Randy Dunlap" <randy.dunlap@oracle.com>, bryan.wu@analog.com,
       linux-kernel@vger.kernel.org
References: <20080115174202.GD8375@Krystal>
In-Reply-To: <20080115174202.GD8375@Krystal>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801151522.38371.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 15 Jan 2008 20:21:29.0257 (UTC) FILETIME=[360C6190:01C857B4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 15 Jan 2008 12:42, Mathieu Desnoyers pondered:
> This patch restores the blackfin Hardware Performance Monitor Profiling
> support that was killed by
> commit 09cadedbdc01f1a4bea1f427d4fb4642eaa19da9.
> 
> Since there seems to be no good reason to behave differently from other
> architectures, it now automatically selects the hardware performance
> counters whenever the profiling is activated.
> 
> mach-common/irqpanic.c: pm_overflow
> calls pm_overflow_handler which is in oprofile/op_model_bf533.c. I doubt
> that setting HARDWARE_PM as "m" will work at all, since the
> pm_overflow_handler should be in the core kernel image because it is
> called by irqpanic.c. 
> 
> Therefore, I change HARDWARE_PM from a tristate to a bool.
> 
> The whole arch/$(ARCH)/oprofile/ is built depending on CONFIG_OPROFILE.
> Since part of the HARDWARE_PM support files sits in this directory, it makes
> sense to also depend on OPROFILE, not only PROFILING. Since OPROFILE already
> depends on PROFILING, it is correct to only depend on OPROFILE only.
> 
> Thanks to Adrian Bunk for finding this bug and providing an initial
> patch.
> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> CC: Linus Torvalds <torvalds@linux-foundation.org>
> CC: Adrian Bunk <adrian.bunk@movial.fi>
> CC: Randy Dunlap <randy.dunlap@oracle.com>
> CC: bryan.wu@analog.com
> CC: Robin Getz <rgetz@blackfin.uclinux.org>

Acked-by: Robin Getz <rgetz@blackfin.uclinux.org>

> ---
>  arch/blackfin/Kconfig |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> Index: linux-2.6-lttng/arch/blackfin/Kconfig
> ===================================================================
> --- linux-2.6-lttng.orig/arch/blackfin/Kconfig	2007-12-29
> 11:00:05.000000000 -0500
> +++ linux-2.6-lttng/arch/blackfin/Kconfig	2007-12-29
> 11:25:39.000000000 -0500
> @@ -65,6 +65,10 @@ config GENERIC_CALIBRATE_DELAY
>  	bool
>  	default y
>  
> +config HARDWARE_PM
> +	def_bool y
> +	depends on OPROFILE
> +
>  source "init/Kconfig"
>  source "kernel/Kconfig.preempt"
>  
> 
> 
