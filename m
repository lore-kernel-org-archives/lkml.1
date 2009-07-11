Return-Path: <linux-kernel-owner+w=401wt.eu-S1754904AbZGKIC0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754904AbZGKIC0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 04:02:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751864AbZGKICE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 04:02:04 -0400
Received: from hera.kernel.org ([140.211.167.34]:40212 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751719AbZGKICD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 04:02:03 -0400
Subject: [FIX REQUEST] x86: smp.h is totally confused about processor ID
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Mike Travis <travis@sgi.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 11 Jul 2009 13:30:34 +0530
Message-Id: <1247299234.2678.10.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Latest -tip tree shows
http://git.kernel.org/?p=linux/kernel/git/x86/linux-2.6-tip.git;a=blob;f=arch/x86/include/asm/smp.h;h=6a84ed166aec136334a644cc4fbaa676368ae983;hb=HEAD :


27 DECLARE_PER_CPU(int, cpu_number);
28 
29 static inline struct cpumask *cpu_sibling_mask(int cpu)
30 {
31         return per_cpu(cpu_sibling_map, cpu);
32 }
33 
34 static inline struct cpumask *cpu_core_mask(int cpu)
35 {
36         return per_cpu(cpu_core_map, cpu);
37 }

it should be unsigned int cpu/cpu_number as it is non-negative.


47 
48 struct smp_ops {
49         void (*smp_prepare_boot_cpu)(void);
50         void (*smp_prepare_cpus)(unsigned max_cpus);
51         void (*smp_cpus_done)(unsigned max_cpus);
52 
53         void (*smp_send_stop)(void);
54         void (*smp_send_reschedule)(int cpu);
55 
56         int (*cpu_up)(unsigned cpu);
57         int (*cpu_disable)(void);
58         void (*cpu_die)(unsigned int cpu);
59         void (*play_dead)(void);
60 
61         void (*send_call_func_ipi)(const struct cpumask *mask);
62         void (*send_call_func_single_ipi)(int cpu);
63 };

In same structure it using int, unsigned and unsigned int cpu

It should be consistent either unsigned cpu or unsigned int cpu.

I think unsigned int cpu will be more better choice.

Similarly another instances in same file.

Thanks,
--
JSR




