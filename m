Return-Path: <linux-kernel-owner+w=401wt.eu-S966293AbYD1TJ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966293AbYD1TJ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 15:09:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934100AbYD1TJS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 15:09:18 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:52076 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934017AbYD1TJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 15:09:17 -0400
Subject: Re: Voyager phys_cpu_present_map compile error
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Adrian Bunk <bunk@kernel.org>, Alexey Starikovskiy <astarikovskiy@suse.de>,
       tglx@linutronix.de, hpa@zytor.com, linux-kernel@vger.kernel.org
In-Reply-To: <20080428175913.GA31911@elte.hu>
References: <20080421000238.GD26897@cs181133002.pp.htv.fi>
	 <20080421085314.GI26897@cs181133002.pp.htv.fi>
	 <20080421120054.GA6788@elte.hu>
	 <20080421132705.GG6011@cs181133002.pp.htv.fi>
	 <20080421201434.GN8770@elte.hu>
	 <1209135044.3087.3.camel@localhost.localdomain>
	 <20080425161745.GA21168@cs181133002.pp.htv.fi>
	 <1209141233.3087.14.camel@localhost.localdomain>
	 <20080428175913.GA31911@elte.hu>
Content-Type: text/plain
Date: Mon, 28 Apr 2008 15:09:10 -0400
Message-Id: <1209409750.3367.41.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-4.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-04-28 at 19:59 +0200, Ingo Molnar wrote:
> * James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> 
> > Oh ... oops ... unfortunately one I wouldn't spot in a voyager build.
> > 
> > This should be the corrected patch; thanks.
> 
> randconfig testing on x86.git found the build breakage below, i bisected 
> it down to your patch. The config is:
> 
>   http://redhat.com/~mingo/misc/config-Mon_Apr_28_19_39_30_CEST_2008.bad
> 
> reverted the patch for now.
> 
> 	Ingo
> 
> ------------>
> arch/x86/kernel/built-in.o: In function `physflat_cpu_mask_to_apicid':
> genapic_flat_64.c:(.text+0x14373): undefined reference to `per_cpu__x86_cpu_to_apicid'
> arch/x86/kernel/built-in.o: In function `physflat_send_IPI_mask':
> genapic_flat_64.c:(.text+0x1447f): undefined reference to `per_cpu__x86_cpu_to_apicid'
> arch/x86/kernel/built-in.o: In function `flat_apic_id_registered':
> genapic_flat_64.c:(.text+0x14558): undefined reference to `phys_cpu_present_map'
> genapic_flat_64.c:(.text+0x1455f): undefined reference to `phys_cpu_present_map'
> arch/x86/kernel/built-in.o: In function `uv_cpu_mask_to_apicid':
> genx2apic_uv_x.c:(.text+0x14627): undefined reference to `per_cpu__x86_cpu_to_apicid'
> arch/x86/kernel/built-in.o: In function `uv_send_IPI_mask':
> genx2apic_uv_x.c:(.text+0x14658): undefined reference to `per_cpu__x86_cpu_to_apicid'
> arch/x86/kernel/built-in.o: In function `acpi_register_lapic_address':
> boot.c:(.init.text+0x3b1b): undefined reference to `boot_cpu_physical_apicid'
> boot.c:(.init.text+0x3b2c): undefined reference to `boot_cpu_physical_apicid'
> arch/x86/kernel/built-in.o: In function `__get_smp_config':
> mpparse.c:(.init.text+0x53ad): undefined reference to `num_processors'
> mpparse.c:(.init.text+0x53c4): undefined reference to `num_processors'
> mpparse.c:(.init.text+0x543c): undefined reference to `num_processors'
> arch/x86/kernel/built-in.o: In function `init_apic_mappings':
> : undefined reference to `boot_cpu_physical_apicid'
> arch/x86/kernel/built-in.o: In function `init_apic_mappings':
> : undefined reference to `boot_cpu_physical_apicid'
> arch/x86/kernel/built-in.o: In function `APIC_init_uniprocessor':
> : undefined reference to `boot_cpu_physical_apicid'
> arch/x86/kernel/built-in.o: In function `APIC_init_uniprocessor':
> : undefined reference to `phys_cpu_present_map'
> arch/x86/kernel/built-in.o: In function `APIC_init_uniprocessor':
> : undefined reference to `boot_cpu_physical_apicid'
> arch/x86/kernel/built-in.o: In function `early_init_lapic_mapping':
> : undefined reference to `boot_cpu_physical_apicid'
> arch/x86/kernel/built-in.o: In function `acpi_register_lapic':
> boot.c:(.cpuinit.text+0x177a): undefined reference to `disabled_cpus'
> arch/x86/kernel/built-in.o: In function `MP_processor_info':
> mpparse.c:(.cpuinit.text+0x179d): undefined reference to `disabled_cpus'
> mpparse.c:(.cpuinit.text+0x17b4): undefined reference to `boot_cpu_physical_apicid'
> arch/x86/kernel/built-in.o: In function `setup_secondary_APIC_clock':
> : undefined reference to `boot_cpu_physical_apicid'
> arch/x86/kernel/built-in.o: In function `generic_processor_info':
> : undefined reference to `num_processors'
> arch/x86/kernel/built-in.o: In function `generic_processor_info':
> : undefined reference to `num_processors'
> arch/x86/kernel/built-in.o: In function `generic_processor_info':
> : undefined reference to `phys_cpu_present_map'
> arch/x86/kernel/built-in.o: In function `generic_processor_info':
> : undefined reference to `per_cpu__x86_cpu_to_apicid'
> arch/x86/kernel/built-in.o: In function `uv_cpu_init':
> : undefined reference to `per_cpu__x86_cpu_to_apicid'
> arch/x86/kernel/built-in.o: In function `uv_cpu_init':
> : undefined reference to `per_cpu__x86_cpu_to_apicid'
> arch/x86/kernel/built-in.o: In function `uv_cpu_init':
> : undefined reference to `per_cpu__x86_cpu_to_apicid'


Hmm, that's nasty.  What it's showing is that the non-SMP local APIC
configuration pulls in large numbers of SMP variables.  This was all
working right a while ago ... as in you need mpparse and the apic files
but not the SMP ones or the SMP variables.  The quickest fix is probably
this one, since in these days of multi-core I suspect optimising the
non-SMP but use APIC case for size has a lot less relevance.

James

---

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index c0c68c1..808daf1 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -12,6 +12,7 @@
 #include <asm/mpspec.h>
 #include <asm/apicdef.h>
 
+#ifdef CONFIG_X86_MPPARSE
 unsigned int num_processors;
 unsigned disabled_cpus __cpuinitdata;
 /* Processor that is doing the boot up */
@@ -23,8 +24,9 @@ EXPORT_PER_CPU_SYMBOL(x86_cpu_to_apicid);
 
 /* Bitmask of physically existing CPUs */
 physid_mask_t phys_cpu_present_map;
+#endif
 
-#if defined(CONFIG_HAVE_SETUP_PER_CPU_AREA) && defined(CONFIG_SMP)
+#if defined(CONFIG_HAVE_SETUP_PER_CPU_AREA) && defined(CONFIG_X86_SMP)
 /*
  * Copy data used in early init routines from the initial arrays to the
  * per cpu data areas.  These arrays then become expendable and the


