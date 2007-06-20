Return-Path: <linux-kernel-owner+w=401wt.eu-S1758901AbXFTS0G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758901AbXFTS0G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 14:26:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754420AbXFTSZz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 14:25:55 -0400
Received: from byss.tchmachines.com ([208.76.80.75]:52274 "EHLO
	byss.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754378AbXFTSZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 14:25:54 -0400
Date: Wed, 20 Jun 2007 11:25:48 -0700
From: Ravikiran G Thirumalai <kiran@scalex86.org>
To: Len Brown <lenb@kernel.org>
Cc: Andreas Herrmann <andreas.herrmann3@amd.com>,
       Steven Whitehouse <swhiteho@redhat.com>, Andi Kleen <ak@suse.de>,
       Shai Fultheim <shai@scalex86.org>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: [PATCH 7/12] acpi: fix another compile warning
Message-ID: <20070620182548.GA561@localdomain>
References: <20070619225035.GI5193@alberich.amd.com> <200706192338.02807.lenb@kernel.org> <20070620084911.GO5193@alberich.amd.com> <200706200936.31236.lenb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706200936.31236.lenb@kernel.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - byss.tchmachines.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - scalex86.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 20, 2007 at 09:36:30AM -0400, Len Brown wrote:
> On Wednesday 20 June 2007 04:49, Andreas Herrmann wrote:
> > On Tue, Jun 19, 2007 at 11:38:02PM -0400, Len Brown wrote:
> > > On Tuesday 19 June 2007 18:50, Andreas Herrmann wrote:
> 
> I fear, however, that this patch defeats the purpose of 
> b0bd35e622ffbda2c01dc67a0381c6a18817a29a -- which was to make selecting
> NUMA more user-friendly.  So it might make more sense to simply revert that
> patch entirely.
> 
> The underlying problem is that Kconfig doesn't support using select
> on targets which themselves have dependencies.
> 
> Signed-off-by: Len Brown <len.brown@intel.com>
> 
> 
> diff --git a/arch/x86_64/Kconfig b/arch/x86_64/Kconfig
> index 5ce9443..e9d7767 100644
> --- a/arch/x86_64/Kconfig
> +++ b/arch/x86_64/Kconfig
> @@ -364,9 +364,9 @@ config NODES_SHIFT
>  config X86_64_ACPI_NUMA
>         bool "ACPI NUMA detection"
>         depends on NUMA
> -       select ACPI 
> +       depends on ACPI 
>  	select PCI
> -       select ACPI_NUMA
> +       depends on ACPI_NUMA
>         default y
>         help
>  	 Enable ACPI SRAT based node topology detection.
> -

arch/x86_64/Kconfig:706:error: found recursive dependency: PCI -> ACPI ->
X86_64_ACPI_NUMA -> PCI
 -> USB_ARCH_HAS_OHCI -> USB_ARCH_HAS_HCD -> MOUSE_APPLETOUCH -> USB ->
USB_SISUSBVGAmake[1]: *** [menuconfig] Error 1

I guess we have to change PCI to 'depends on' as well.
Else, select PM?

I am OK with either approach.

Thanks,
Kiran

Paper over 'select' inadequacies.  

Signed-off-by: Ravikiran Thirumalai <kiran@scalex86.org>

Index: linux-2.6.22-rc5/arch/x86_64/Kconfig
===================================================================
--- linux-2.6.22-rc5.orig/arch/x86_64/Kconfig	2007-06-18 16:02:19.571323415 -0700
+++ linux-2.6.22-rc5/arch/x86_64/Kconfig	2007-06-20 11:34:29.845354250 -0700
@@ -366,6 +366,7 @@ config X86_64_ACPI_NUMA
        depends on NUMA
        select ACPI 
 	select PCI
+  	select PM
        select ACPI_NUMA
        default y
        help
