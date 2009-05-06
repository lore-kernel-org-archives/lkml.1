Return-Path: <linux-kernel-owner+w=401wt.eu-S1759550AbZEFMus@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759550AbZEFMus (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 08:50:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754159AbZEFMuj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 08:50:39 -0400
Received: from wa4ehsobe004.messaging.microsoft.com ([216.32.181.14]:57004
	"EHLO WA4EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754540AbZEFMui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 08:50:38 -0400
X-BigFish: VPS-33(zz1432R62a3L98dR936eQ4015L1805Mzz1202hzzz32i6bh15fn43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KJ83O3-03-BMC-01
Date: Wed, 6 May 2009 14:50:27 +0200
From: Robert Richter <robert.richter@amd.com>
To: Andi Kleen <andi@firstfloor.org>
CC: oprofile-list@lists.sf.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [1/3] oprofile: re-add force_arch_perfmon option
Message-ID: <20090506125026.GM9593@erda.amd.com>
References: <20090427544.130860995@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20090427544.130860995@firstfloor.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 06 May 2009 12:50:28.0274 (UTC) FILETIME=[3B7CD120:01C9CE49]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi,

I applied your patches. Please see my follow on patches and test them.

Thanks,

-Robert

On 27.04.09 17:44:11, Andi Kleen wrote:
> 
> This re-adds the force_arch_perfmon option that was in the original
> arch perfmon patchkit. Originally this was rejected in favour 
> of a generalized perfmon=name option, but it turned out implementing
> the later in a reliable way is hard (and it would have been easy
> to crash the kernel if a user gets it wrong) 
> 
> But now Atom and Core i7 support being readded a user would
> need to update their oprofile userland to beyond 0.9.4 to use oprofile again
> on Atom or Core i7.
> 
> To avoid this problem readd the force_arch_perfmon option.
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> 
> ---
>  Documentation/kernel-parameters.txt |    6 ++++++
>  arch/x86/oprofile/nmi_int.c         |    6 ++++++
>  2 files changed, 12 insertions(+)
> 
> Index: linux-2.6.30-rc3-ak/Documentation/kernel-parameters.txt
> ===================================================================
> --- linux-2.6.30-rc3-ak.orig/Documentation/kernel-parameters.txt	2009-04-25 19:11:59.000000000 +0200
> +++ linux-2.6.30-rc3-ak/Documentation/kernel-parameters.txt	2009-04-27 13:20:29.000000000 +0200
> @@ -1648,6 +1648,12 @@
>  	oprofile.timer=	[HW]
>  			Use timer interrupt instead of performance counters
>  
> +	oprofile.force_arch_perfmon=1	[X86]
> +			Force use of architectural perfmon instead of
> +			the CPU specific event set.
> +			This might be useful if you have older oprofile
> +			userland or if you want common events over Intel CPUs.
> +
>  	osst=		[HW,SCSI] SCSI Tape Driver
>  			Format: <buffer_size>,<write_threshold>
>  			See also Documentation/scsi/st.txt.
> Index: linux-2.6.30-rc3-ak/arch/x86/oprofile/nmi_int.c
> ===================================================================
> --- linux-2.6.30-rc3-ak.orig/arch/x86/oprofile/nmi_int.c	2009-02-15 12:09:09.000000000 +0100
> +++ linux-2.6.30-rc3-ak/arch/x86/oprofile/nmi_int.c	2009-04-27 13:20:29.000000000 +0200
> @@ -389,10 +389,16 @@
>  	return 0;
>  }
>  
> +int force_arch_perfmon;
> +module_param(force_arch_perfmon, int, 0);
> +
>  static int __init ppro_init(char **cpu_type)
>  {
>  	__u8 cpu_model = boot_cpu_data.x86_model;
>  
> +	if (force_arch_perfmon && cpu_has_arch_perfmon)
> +		return 0;
> +
>  	switch (cpu_model) {
>  	case 0 ... 2:
>  		*cpu_type = "i386/ppro";
> 

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

