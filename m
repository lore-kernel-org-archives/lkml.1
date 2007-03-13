Return-Path: <linux-kernel-owner+w=401wt.eu-S1161029AbXCMRPV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161029AbXCMRPV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 13:15:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161034AbXCMRPV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 13:15:21 -0400
Received: from gw.goop.org ([64.81.55.164]:55553 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161029AbXCMRPU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 13:15:20 -0400
Message-ID: <45F6DC27.8000200@goop.org>
Date: Tue, 13 Mar 2007 10:15:19 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Zachary Amsden <zach@vmware.com>,
       Jeremy Fitzhardinge <jeremy@xensource.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>
Subject: Re: [PATCH 8/8] Convert PDA into the percpu section
References: <1173184747.4644.23.camel@localhost.localdomain>	 <1173185592.4644.28.camel@localhost.localdomain>	 <1173185666.4644.30.camel@localhost.localdomain>	 <1173185734.4644.32.camel@localhost.localdomain>	 <1173185827.4644.34.camel@localhost.localdomain>	 <1173185909.4644.36.camel@localhost.localdomain>	 <1173186021.4644.38.camel@localhost.localdomain>	 <1173186107.4644.41.camel@localhost.localdomain> <1173186214.4644.44.camel@localhost.localdomain>
In-Reply-To: <1173186214.4644.44.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> +	pack_descriptor((u32 *)&gdt[GDT_ENTRY_PERCPU].a,
> +			(u32 *)&gdt[GDT_ENTRY_PERCPU].b,
> +			__per_cpu_offset[cpu], 0xFFFFF,
>  			0x80 | DESCTYPE_S | 0x2, 0); /* present read-write data segment */
>   

Why testing with qemu is not enough.

diff -r 8dcd1dc9b298 arch/i386/kernel/cpu/common.c
--- a/arch/i386/kernel/cpu/common.c	Tue Mar 13 00:33:37 2007 -0700
+++ b/arch/i386/kernel/cpu/common.c	Tue Mar 13 08:33:42 2007 -0700
@@ -627,7 +627,7 @@ __cpuinit void init_gdt(int cpu, struct 
 	pack_descriptor((u32 *)&gdt[GDT_ENTRY_PERCPU].a,
 			(u32 *)&gdt[GDT_ENTRY_PERCPU].b,
 			__per_cpu_offset[cpu], 0xFFFFF,
-			0x80 | DESCTYPE_S | 0x2, 0); /* present read-write data segment */
+			0x80 | DESCTYPE_S | 0x2, 0x8); /* present read-write data segment, G */
 	per_cpu(this_cpu_off, cpu) = __per_cpu_offset[cpu];
 	per_cpu(cpu_number, cpu) = cpu;
 #endif /* SMP*/

    J
