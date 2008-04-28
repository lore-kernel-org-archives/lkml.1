Return-Path: <linux-kernel-owner+w=401wt.eu-S965125AbYD1R77@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965125AbYD1R77 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 13:59:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934421AbYD1R7k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 13:59:40 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45598 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934380AbYD1R7j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 13:59:39 -0400
Date: Mon, 28 Apr 2008 19:59:13 +0200
From: Ingo Molnar <mingo@elte.hu>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Adrian Bunk <bunk@kernel.org>, Alexey Starikovskiy <astarikovskiy@suse.de>,
       tglx@linutronix.de, hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: Voyager phys_cpu_present_map compile error
Message-ID: <20080428175913.GA31911@elte.hu>
References: <20080421000238.GD26897@cs181133002.pp.htv.fi> <20080421085314.GI26897@cs181133002.pp.htv.fi> <20080421120054.GA6788@elte.hu> <20080421132705.GG6011@cs181133002.pp.htv.fi> <20080421201434.GN8770@elte.hu> <1209135044.3087.3.camel@localhost.localdomain> <20080425161745.GA21168@cs181133002.pp.htv.fi> <1209141233.3087.14.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1209141233.3087.14.camel@localhost.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> Oh ... oops ... unfortunately one I wouldn't spot in a voyager build.
> 
> This should be the corrected patch; thanks.

randconfig testing on x86.git found the build breakage below, i bisected 
it down to your patch. The config is:

  http://redhat.com/~mingo/misc/config-Mon_Apr_28_19_39_30_CEST_2008.bad

reverted the patch for now.

	Ingo

------------>
arch/x86/kernel/built-in.o: In function `physflat_cpu_mask_to_apicid':
genapic_flat_64.c:(.text+0x14373): undefined reference to `per_cpu__x86_cpu_to_apicid'
arch/x86/kernel/built-in.o: In function `physflat_send_IPI_mask':
genapic_flat_64.c:(.text+0x1447f): undefined reference to `per_cpu__x86_cpu_to_apicid'
arch/x86/kernel/built-in.o: In function `flat_apic_id_registered':
genapic_flat_64.c:(.text+0x14558): undefined reference to `phys_cpu_present_map'
genapic_flat_64.c:(.text+0x1455f): undefined reference to `phys_cpu_present_map'
arch/x86/kernel/built-in.o: In function `uv_cpu_mask_to_apicid':
genx2apic_uv_x.c:(.text+0x14627): undefined reference to `per_cpu__x86_cpu_to_apicid'
arch/x86/kernel/built-in.o: In function `uv_send_IPI_mask':
genx2apic_uv_x.c:(.text+0x14658): undefined reference to `per_cpu__x86_cpu_to_apicid'
arch/x86/kernel/built-in.o: In function `acpi_register_lapic_address':
boot.c:(.init.text+0x3b1b): undefined reference to `boot_cpu_physical_apicid'
boot.c:(.init.text+0x3b2c): undefined reference to `boot_cpu_physical_apicid'
arch/x86/kernel/built-in.o: In function `__get_smp_config':
mpparse.c:(.init.text+0x53ad): undefined reference to `num_processors'
mpparse.c:(.init.text+0x53c4): undefined reference to `num_processors'
mpparse.c:(.init.text+0x543c): undefined reference to `num_processors'
arch/x86/kernel/built-in.o: In function `init_apic_mappings':
: undefined reference to `boot_cpu_physical_apicid'
arch/x86/kernel/built-in.o: In function `init_apic_mappings':
: undefined reference to `boot_cpu_physical_apicid'
arch/x86/kernel/built-in.o: In function `APIC_init_uniprocessor':
: undefined reference to `boot_cpu_physical_apicid'
arch/x86/kernel/built-in.o: In function `APIC_init_uniprocessor':
: undefined reference to `phys_cpu_present_map'
arch/x86/kernel/built-in.o: In function `APIC_init_uniprocessor':
: undefined reference to `boot_cpu_physical_apicid'
arch/x86/kernel/built-in.o: In function `early_init_lapic_mapping':
: undefined reference to `boot_cpu_physical_apicid'
arch/x86/kernel/built-in.o: In function `acpi_register_lapic':
boot.c:(.cpuinit.text+0x177a): undefined reference to `disabled_cpus'
arch/x86/kernel/built-in.o: In function `MP_processor_info':
mpparse.c:(.cpuinit.text+0x179d): undefined reference to `disabled_cpus'
mpparse.c:(.cpuinit.text+0x17b4): undefined reference to `boot_cpu_physical_apicid'
arch/x86/kernel/built-in.o: In function `setup_secondary_APIC_clock':
: undefined reference to `boot_cpu_physical_apicid'
arch/x86/kernel/built-in.o: In function `generic_processor_info':
: undefined reference to `num_processors'
arch/x86/kernel/built-in.o: In function `generic_processor_info':
: undefined reference to `num_processors'
arch/x86/kernel/built-in.o: In function `generic_processor_info':
: undefined reference to `phys_cpu_present_map'
arch/x86/kernel/built-in.o: In function `generic_processor_info':
: undefined reference to `per_cpu__x86_cpu_to_apicid'
arch/x86/kernel/built-in.o: In function `uv_cpu_init':
: undefined reference to `per_cpu__x86_cpu_to_apicid'
arch/x86/kernel/built-in.o: In function `uv_cpu_init':
: undefined reference to `per_cpu__x86_cpu_to_apicid'
arch/x86/kernel/built-in.o: In function `uv_cpu_init':
: undefined reference to `per_cpu__x86_cpu_to_apicid'

