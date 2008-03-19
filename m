Return-Path: <linux-kernel-owner+w=401wt.eu-S936125AbYCSXbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936125AbYCSXbU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 19:31:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161315AbYCSWC3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 18:02:29 -0400
Received: from gw.goop.org ([64.81.55.164]:34801 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753522AbYCSWC1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 18:02:27 -0400
Message-ID: <47E18C9D.4010007@goop.org>
Date: Wed, 19 Mar 2008 14:58:53 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>, Ian Campbell <ijc@hellion.org.uk>
Subject: Re: [PATCH 00 of 31] x86: unification and xen updates
References: <patchbomb.1205797011@localhost> <20080319190536.GA11432@elte.hu> <20080319194648.GA20088@elte.hu> <47E17171.9090108@goop.org> <20080319200931.GA24828@elte.hu> <20080319213343.GA2195@elte.hu> <47E18B8E.8080104@goop.org> <20080319220028.GA10480@elte.hu>
In-Reply-To: <20080319220028.GA10480@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>
>   
>> Hm, OK.  I can't see how it can avoid enabling interrupts on that 
>> path, but I'll look more closely.  What's the .config.  32-bit, 
>> obviously.  Paravirt?
>>     
>
> config attached. randconfig generated, so it can have random surprises 
> enabled :)
>   

Thanks.  What was the workload?  Did it just happen, or were you doing 
something specific?

BTW, that other pud_populate config you sent fails to link for me:

  LD      .tmp_vmlinux1
arch/x86/kernel/built-in.o: In function `MP_processor_info':
mpparse_32.c:(.cpuinit.text+0x32b2): undefined reference to `x86_cpu_to_apicid_early_ptr'
mpparse_32.c:(.cpuinit.text+0x32c4): undefined reference to `x86_bios_cpu_apicid_early_ptr'
mpparse_32.c:(.cpuinit.text+0x3363): undefined reference to `per_cpu__x86_cpu_to_apicid'
mpparse_32.c:(.cpuinit.text+0x336e): undefined reference to `per_cpu__x86_bios_cpu_apicid'
arch/x86/mach-generic/built-in.o: In function `cpu_present_to_apicid':
summit.c:(.text+0xaf): undefined reference to `per_cpu__x86_bios_cpu_apicid'
arch/x86/mach-generic/built-in.o: In function `cpu_present_to_apicid':
bigsmp.c:(.text+0x47f): undefined reference to `per_cpu__x86_bios_cpu_apicid'
arch/x86/mach-generic/built-in.o: In function `init_apic_ldr':
bigsmp.c:(.text+0x6cc): undefined reference to `per_cpu__x86_bios_cpu_apicid'
arch/x86/mach-generic/built-in.o: In function `cpu_present_to_apicid':
es7000.c:(.text+0x774): undefined reference to `per_cpu__x86_bios_cpu_apicid'
arch/x86/mach-generic/built-in.o:es7000.c:(.text+0x906): more undefined references to `per_cpu__x86_bios_cpu_apicid' follow
make[2]: *** [.tmp_vmlinux1] Error 1

	J


