Return-Path: <linux-kernel-owner+w=401wt.eu-S1759930AbYHUOdp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759930AbYHUOdp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 10:33:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756056AbYHUOdf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 10:33:35 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:46211 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755027AbYHUOdd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 10:33:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=NyE4msg1YJo06TK3hPjR+TryyP8G3GKCE5idUlUjfJzlH7drZoUT669o219G6+XlWm
         Rsy3Lx+kBPrOdCGzuk5JymVJa9tBTFp9Zu/ACm9sPjO6LYfAFi5e0gSSk9FDEt1abJHe
         MnPxjm3+vbuJ9+1McwT1+iHxx8luGI9DM0dDE=
Date: Thu, 21 Aug 2008 18:33:56 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: apic version warning.
Message-ID: <20080821143356.GA7214@lenovo>
References: <86802c440808210101u1101b480p74ee387082ebdcb6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440808210101u1101b480p74ee387082ebdcb6@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Yinghai Lu - Thu, Aug 21, 2008 at 01:01:19AM -0700]
| after following patch,
| 
| commit 1b313f4a6d7bee7b2c034b3f1e203bc360a71cca
| Author: Cyrill Gorcunov <gorcunov@gmail.com>
| Date:   Mon Aug 18 20:45:57 2008 +0400
| 
|     x86: apic - generic_processor_info
| 
|     - use physid_set instead of phys_cpu and physids_or
|     - set phys_cpu_present_map bit AFTER check for allowed
|       number of processors
|     - add checking for APIC valid version in 64bit mode
|       (mostly not needed but added for merging purpose)
|     - add apic_version definition for 64bit mode which
|       is used now
| 
| we are getting warning for acpi path on 64 bit system
| 
| please add #ifdef for that.
| actually, 64 bit doesn't use that apic_version[]
| 
| 
| or using following patch?
| 
| diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
| index 301678b..fc64412 100644
| --- a/arch/x86/kernel/acpi/boot.c
| +++ b/arch/x86/kernel/acpi/boot.c
| @@ -252,10 +252,8 @@ static void __cpuinit acpi_register_lapic(int id,
| u8 enabled)
|                 return;
|         }
| 
| -#ifdef CONFIG_X86_32
|         if (boot_cpu_physical_apicid != -1U)
|                 ver = apic_version[boot_cpu_physical_apicid];
| -#endif
| 
|         generic_processor_info(id, ver);
|  }
| @@ -775,10 +773,8 @@ static void __init
| acpi_register_lapic_address(unsigned long address)
|         set_fixmap_nocache(FIX_APIC_BASE, address);
|         if (boot_cpu_physical_apicid == -1U) {
|                 boot_cpu_physical_apicid  = read_apic_id();
| -#ifdef CONFIG_X86_32
|                 apic_version[boot_cpu_physical_apicid] =
|                          GET_APIC_VERSION(apic_read(APIC_LVR));
| -#endif
|         }
|  }
| 
| 
| YH
| 

Thanks, Yinghai!

		- Cyrill -
