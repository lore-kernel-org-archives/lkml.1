Return-Path: <linux-kernel-owner+w=401wt.eu-S1751818AbYEPXbq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751818AbYEPXbq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 19:31:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752695AbYEPXbh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 19:31:37 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:35772 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752422AbYEPXbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 19:31:36 -0400
Message-ID: <482E1955.8080506@suse.de>
Date: Sat, 17 May 2008 03:31:33 +0400
From: Alexey Starikovskiy <astarikovskiy@suse.de>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/5] x86: Move es7000_plat out of mpparse.c
References: <20080514150251.24443.5516.stgit@thinkpad> <20080516124319.GB16520@elte.hu> <20080516130342.GA22993@elte.hu> <20080516130422.GA24607@elte.hu>
In-Reply-To: <20080516130422.GA24607@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,
I seem to have lost the track of changes... Why the ifdef LOCAL_APIC was 
switched to MPPARSE?

Reverting it back makes the error to go away...

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 089ddfa..c86bda7 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -12,7 +12,7 @@
 #include <asm/mpspec.h>
 #include <asm/apicdef.h>
 
-#ifdef CONFIG_X86_MPPARSE
+#ifdef CONFIG_X86_LOCAL_APIC
 unsigned int num_processors;
 unsigned disabled_cpus __cpuinitdata;


Ingo Molnar wrote:
> the build failure is:
> 
> arch/x86/kernel/built-in.o: In function `init_apic_mappings':
> : undefined reference to `boot_cpu_physical_apicid'
> arch/x86/kernel/built-in.o: In function `init_apic_mappings':
> : undefined reference to `boot_cpu_physical_apicid'
> arch/x86/kernel/built-in.o: In function `APIC_init_uniprocessor':
> : undefined reference to `boot_cpu_physical_apicid'
> arch/x86/kernel/built-in.o: In function `APIC_init_uniprocessor':
> : undefined reference to `boot_cpu_physical_apicid'
> arch/x86/kernel/built-in.o: In function `APIC_init_uniprocessor':
> : undefined reference to `phys_cpu_present_map'
> arch/x86/kernel/built-in.o: In function `setup_local_APIC':
> : undefined reference to `phys_cpu_present_map'
> arch/x86/kernel/built-in.o: In function `generic_processor_info':
> : undefined reference to `phys_cpu_present_map'
> arch/x86/kernel/built-in.o: In function `generic_processor_info':
> : undefined reference to `num_processors'
> arch/x86/kernel/built-in.o: In function `generic_processor_info':
> : undefined reference to `num_processors'
> arch/x86/mach-visws/built-in.o: In function `find_smp_config':
> : undefined reference to `boot_cpu_physical_apicid'
> arch/x86/mach-visws/built-in.o: In function `find_smp_config':
> : undefined reference to `phys_cpu_present_map'
> 

