Return-Path: <linux-kernel-owner+w=401wt.eu-S1755683AbZIVJXl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755683AbZIVJXl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 05:23:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754385AbZIVJXk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 05:23:40 -0400
Received: from casper.infradead.org ([85.118.1.10]:57633 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754360AbZIVJXk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 05:23:40 -0400
Date: Tue, 22 Sep 2009 11:23:51 +0200
From: Arjan van de Ven <arjan@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: Tony Vroon <tony@linx.net>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, "Langsdorf, Mark" <mark.langsdorf@amd.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: 2.6.31-07068-g43c1266 Early boot exception
Message-ID: <20090922112351.6b07d259@infradead.org>
In-Reply-To: <4AB89417.7090005@kernel.org>
References: <1253560490.2934.42.camel@localhost>
	<4AB7D349.4000802@zytor.com>
	<1253566046.2773.10.camel@localhost>
	<4AB89417.7090005@kernel.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Sep 2009 18:08:39 +0900
Tejun Heo <tj@kernel.org> wrote:

> Tony Vroon wrote:
> > Thanks Ingo. 11-step bisection reveals:
> > 
> > chainsaw@prometheus /cvs/linux-2.6 $ git bisect bad
> > fd1e8a1fe2b54df6c185b4fa65f181f50b9c4d4e is the first bad commit
> > commit fd1e8a1fe2b54df6c185b4fa65f181f50b9c4d4e
> > Author: Tejun Heo <tj@kernel.org>
> > Date:   Fri Aug 14 15:00:51 2009 +0900
> > 
> >     percpu: introduce pcpu_alloc_info and pcpu_group_info
> > 
> > I will repeat the early exception here:
> > IOAPIC[0]: apic_id 0, version 17, address 0xfec00000, GSI 0-23
> > ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
> > ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
> > ACPI: INT_SRC_OVR (bus 0 bus_irq 14 global_irq 14 high edge)
> > ACPI: INT_SRC_OVR (bus 0 bus_irq 15 global_irq 15 high edge)
> > Using ACPI (MADT) for SMP configuration information
> > ACPI: HPET id: 0x10de8201 base: 0xfed00000
> > SMP: allowing 12 CPUs, 0 hotplug CPUs
> > Allocating PCI resources starting at b00000000
> > (gap:b00000000:3000000 NR_CPUS: 12 nr_cpumask_bits:12 nr_cpu_ids:12
> > nr_node_ids:2 PERCPU: Embedded 23 pages/cpu @ffff880028200000
> > s73688 r0 d20520 u262 PANIC: early exception 06 rip
> > 10:ffffffff815a50e6 error 0 cr2 d0fff6 Pid: 0, comm: swapper Not
> > tained 2.6.31-07068-g43c266 #1 Call Trace:
> > [<ffffffff81591175>] early_idt_handler+0x55/0x68
> > [<ffffffff815a50e6>] ? pcpu_setup_first_chunk+0x40b/0x692
> > [<ffffffff815a50ff>] ? pcpu_setup_first_chunk+0x424/0x692
> > [<ffffffff815a5867>] pcpu_embed_first_chunk+0x1e2/0x241
> > [<ffffffff81598c14>] ? pcpu_fc_alloc+0x0/0xac
> > [<ffffffff81598bf5>] ? pcpu_fc_free+0x0/0x1f
> > [<ffffffff81598a36>] setup_per_cpu_areas+0x65/0x219
> > [<ffffffff815919bf>] start_kernel+0x124/0x2c5
> > [<ffffffff81591252>] x86_64_start_reservations+0x82/0x86
> > [<ffffffff8159133a>] x86_64_start_kernel+0xe4/0xeb
> > RIP pcpu_setup_first_chunk+0x40b/0x692
> 
> Can you please try the patch below?  Also, please build the kernel
> with debug info and ask gdb which line the crash corresponds to?
> ie. l *pcpu_embed_first_chunk+0x1e2

if you build with debuginfo.. run
perl scripts/markup_oops.pl on your dmesg

that gives you not just the line, but the whole context of the crash.



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
