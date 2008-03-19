Return-Path: <linux-kernel-owner+w=401wt.eu-S942936AbYCSXdf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S942936AbYCSXdf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 19:33:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161505AbYCSWEv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 18:04:51 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55126 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161496AbYCSWEt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 18:04:49 -0400
Date: Wed, 19 Mar 2008 23:04:33 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ian Campbell <ijc@hellion.org.uk>
Subject: Re: [PATCH 00 of 31] x86: unification and xen updates
Message-ID: <20080319220431.GA11606@elte.hu>
References: <patchbomb.1205797011@localhost> <20080319190536.GA11432@elte.hu> <20080319194648.GA20088@elte.hu> <47E17171.9090108@goop.org> <20080319200931.GA24828@elte.hu> <20080319213343.GA2195@elte.hu> <47E18B8E.8080104@goop.org> <20080319220028.GA10480@elte.hu> <47E18C9D.4010007@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47E18C9D.4010007@goop.org>
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


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

>> config attached. randconfig generated, so it can have random 
>> surprises enabled :)
>
> Thanks.  What was the workload?  Did it just happen, or were you doing 
> something specific?

simple bootup triggered it.

> BTW, that other pud_populate config you sent fails to link for me:
>
>  LD      .tmp_vmlinux1
> arch/x86/kernel/built-in.o: In function `MP_processor_info':
> mpparse_32.c:(.cpuinit.text+0x32b2): undefined reference to `x86_cpu_to_apicid_early_ptr'
> mpparse_32.c:(.cpuinit.text+0x32c4): undefined reference to `x86_bios_cpu_apicid_early_ptr'
> mpparse_32.c:(.cpuinit.text+0x3363): undefined reference to `per_cpu__x86_cpu_to_apicid'
> mpparse_32.c:(.cpuinit.text+0x336e): undefined reference to `per_cpu__x86_bios_cpu_apicid'
> arch/x86/mach-generic/built-in.o: In function `cpu_present_to_apicid':
> summit.c:(.text+0xaf): undefined reference to `per_cpu__x86_bios_cpu_apicid'
> arch/x86/mach-generic/built-in.o: In function `cpu_present_to_apicid':
> bigsmp.c:(.text+0x47f): undefined reference to `per_cpu__x86_bios_cpu_apicid'
> arch/x86/mach-generic/built-in.o: In function `init_apic_ldr':
> bigsmp.c:(.text+0x6cc): undefined reference to `per_cpu__x86_bios_cpu_apicid'
> arch/x86/mach-generic/built-in.o: In function `cpu_present_to_apicid':
> es7000.c:(.text+0x774): undefined reference to `per_cpu__x86_bios_cpu_apicid'
> arch/x86/mach-generic/built-in.o:es7000.c:(.text+0x906): more undefined references to `per_cpu__x86_bios_cpu_apicid' follow
> make[2]: *** [.tmp_vmlinux1] Error 1

"git-remote update" should solve that for you.

	Ingo
