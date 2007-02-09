Return-Path: <linux-kernel-owner+w=401wt.eu-S1946666AbXBIQkw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946666AbXBIQkw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 11:40:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946650AbXBIQkg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 11:40:36 -0500
Received: from mail.dbd-breitband.de ([217.188.211.21]:13655 "EHLO
	dbd-mpx01.dbd-breitband.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1946613AbXBIQkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 11:40:04 -0500
From: Marc Donner <donner@dbd-breitband.de>
Organization: DBD DeutscheBreitbandDienste
To: David Lang <david.lang@digitalinsight.com>,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: cpu load balancing problem on smp
Date: Fri, 9 Feb 2007 16:12:13 +0100
User-Agent: KMail/1.9.5
References: <200702061832.17771.donner@dbd-breitband.de> <45C96AC1.4030301@linux.intel.com> <Pine.LNX.4.63.0702080040550.2981@qynat.qvtvafvgr.pbz>
In-Reply-To: <Pine.LNX.4.63.0702080040550.2981@qynat.qvtvafvgr.pbz>
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_N9IzFWu6zijktM1"
Message-Id: <200702091612.13426.donner@dbd-breitband.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_N9IzFWu6zijktM1
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Thursday 08 February 2007 09:42, you wrote:
> On Wed, 7 Feb 2007, Arjan van de Ven wrote:
> > Marc Donner wrote:
> >> 501:     215717     209388     209430     202514   PCI-MSI-edge     
> >> eth10 502:        927       1019       1053        888   PCI-MSI-edge   
> >>   eth11
> >
> > this is odd, this is not an irq distribution that irqbalance should give
> > you 1
> >
> >> NMI:        451         39         42         46
> >> LOC:     170899     170864     170846     170788
> >> ERR:          0
> >>
> >> top output:
> >>
> >> top - 01:45:32 up 16 min,  2 users,  load average: 1.04, 0.92, 0.50
> >> Tasks:  81 total,   3 running,  78 sleeping,   0 stopped,   0 zombie
> >> Cpu0  :  0.0% us,  0.0% sy,  0.0% ni,  0.0% id,  0.0% wa,  0.0% hi,
> >> 100.0% si
> >
> > and this doesn't match the irq output...
> > sounds as if something has a real bug; can you send an lsmod ? maybe some
> > driver keeps doing si's
>
> since this only happens when he adds more iptables rules, is it possible
> that there sis some locking, or otherdata structure access that's
> serializing things under load?
>
> Marc, since you don't use modules, send your .config.
>
> David Lang

i've inserted some more iptables rules, and got 'softlockup detected' 
messages.

BUG: soft lockup detected on CPU#1!

Call Trace:
 <IRQ>  [<ffffffff8023fbdf>] softlockup_tick+0xda/0xec
 [<ffffffff80229ba5>] update_process_times+0x42/0x68
 [<ffffffff8021421e>] smp_local_timer_interrupt+0x32/0x55
 [<ffffffff804f162a>] ip_rcv+0x0/0x48e
 [<ffffffff8021484b>] smp_apic_timer_interrupt+0x4f/0x67
 [<ffffffff8020a206>] apic_timer_interrupt+0x66/0x70
 [<ffffffff804f162a>] ip_rcv+0x0/0x48e
 [<ffffffff8051bf4e>] ipt_do_table+0x2cd/0x315
 [<ffffffff804eb445>] nf_iterate+0x3f/0x7b
 [<ffffffff804f2aa0>] ip_forward_finish+0x0/0x3e
 [<ffffffff804eb4e0>] nf_hook_slow+0x5f/0xca
 [<ffffffff804f2aa0>] ip_forward_finish+0x0/0x3e
 [<ffffffff804f2c4c>] ip_forward+0x16e/0x212
 [<ffffffff804f1a71>] ip_rcv+0x447/0x48e
 [<ffffffff803de54c>] e1000_clean_rx_irq+0x41e/0x4ea
 [<ffffffff803e1dea>] e1000_clean+0x2f7/0x4b0
 [<ffffffff8021bf72>] task_rq_lock+0x3d/0x6f
 [<ffffffff804dcb1a>] net_rx_action+0x78/0x14a
 [<ffffffff802268b0>] __do_softirq+0x56/0xd3
 [<ffffffff80226699>] ksoftirqd+0x0/0x8f
 [<ffffffff8020a75c>] call_softirq+0x1c/0x28
 [<ffffffff8020c20a>] do_softirq+0x2c/0x7d
 [<ffffffff80214850>] smp_apic_timer_interrupt+0x54/0x67
 [<ffffffff8020a206>] apic_timer_interrupt+0x66/0x70
 <EOI>  [<ffffffff8020c259>] do_softirq+0x7b/0x7d
 [<ffffffff802266e8>] ksoftirqd+0x4f/0x8f
 [<ffffffff8023312a>] kthread+0xcb/0xf5
 [<ffffffff8020a3e8>] child_rip+0xa/0x12
 [<ffffffff8023305f>] kthread+0x0/0xf5
 [<ffffffff8020a3de>] child_rip+0x0/0x12


Marc

--Boundary-00=_N9IzFWu6zijktM1
Content-Type: text/plain;
  charset="iso-8859-1";
  name="x.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="x.txt"

BUG: soft lockup detected on CPU#1!

Call Trace:
 <IRQ>  [<ffffffff8023fbdf>] softlockup_tick+0xda/0xec
 [<ffffffff80229ba5>] update_process_times+0x42/0x68
 [<ffffffff8021421e>] smp_local_timer_interrupt+0x32/0x55
 [<ffffffff804f162a>] ip_rcv+0x0/0x48e
 [<ffffffff8021484b>] smp_apic_timer_interrupt+0x4f/0x67
 [<ffffffff8020a206>] apic_timer_interrupt+0x66/0x70
 [<ffffffff804f162a>] ip_rcv+0x0/0x48e
 [<ffffffff8051bf4e>] ipt_do_table+0x2cd/0x315
 [<ffffffff804eb445>] nf_iterate+0x3f/0x7b
 [<ffffffff804f2aa0>] ip_forward_finish+0x0/0x3e
 [<ffffffff804eb4e0>] nf_hook_slow+0x5f/0xca
 [<ffffffff804f2aa0>] ip_forward_finish+0x0/0x3e
 [<ffffffff804f2c4c>] ip_forward+0x16e/0x212
 [<ffffffff804f1a71>] ip_rcv+0x447/0x48e
 [<ffffffff803de54c>] e1000_clean_rx_irq+0x41e/0x4ea
 [<ffffffff803e1dea>] e1000_clean+0x2f7/0x4b0
 [<ffffffff8021bf72>] task_rq_lock+0x3d/0x6f
 [<ffffffff804dcb1a>] net_rx_action+0x78/0x14a
 [<ffffffff802268b0>] __do_softirq+0x56/0xd3
 [<ffffffff80226699>] ksoftirqd+0x0/0x8f
 [<ffffffff8020a75c>] call_softirq+0x1c/0x28
 [<ffffffff8020c20a>] do_softirq+0x2c/0x7d
 [<ffffffff80214850>] smp_apic_timer_interrupt+0x54/0x67
 [<ffffffff8020a206>] apic_timer_interrupt+0x66/0x70
 <EOI>  [<ffffffff8020c259>] do_softirq+0x7b/0x7d
 [<ffffffff802266e8>] ksoftirqd+0x4f/0x8f
 [<ffffffff8023312a>] kthread+0xcb/0xf5
 [<ffffffff8020a3e8>] child_rip+0xa/0x12
 [<ffffffff8023305f>] kthread+0x0/0xf5
 [<ffffffff8020a3de>] child_rip+0x0/0x12



BUG: soft lockup detected on CPU#1!

Call Trace:
 <IRQ>  [<ffffffff8023fbdf>] softlockup_tick+0xda/0xec
 [<ffffffff80229ba5>] update_process_times+0x42/0x68
 [<ffffffff8021421e>] smp_local_timer_interrupt+0x32/0x55
 [<ffffffff804f162a>] ip_rcv+0x0/0x48e
 [<ffffffff8021484b>] smp_apic_timer_interrupt+0x4f/0x67
 [<ffffffff8020a206>] apic_timer_interrupt+0x66/0x70
 [<ffffffff804f162a>] ip_rcv+0x0/0x48e
 [<ffffffff8051bd30>] ipt_do_table+0xaf/0x315
 [<ffffffff804eb445>] nf_iterate+0x3f/0x7b
 [<ffffffff804f2aa0>] ip_forward_finish+0x0/0x3e
 [<ffffffff804eb4e0>] nf_hook_slow+0x5f/0xca
 [<ffffffff804f2aa0>] ip_forward_finish+0x0/0x3e
 [<ffffffff804f2c4c>] ip_forward+0x16e/0x212
 [<ffffffff804f1a71>] ip_rcv+0x447/0x48e
 [<ffffffff803de54c>] e1000_clean_rx_irq+0x41e/0x4ea
 [<ffffffff803e1dea>] e1000_clean+0x2f7/0x4b0
 [<ffffffff80229c60>] lock_timer_base+0x1b/0x3c
 [<ffffffff80229fde>] __mod_timer+0xa6/0xb4
 [<ffffffff804dcb1a>] net_rx_action+0x78/0x14a
 [<ffffffff802268b0>] __do_softirq+0x56/0xd3
 [<ffffffff80226699>] ksoftirqd+0x0/0x8f
 [<ffffffff8020a75c>] call_softirq+0x1c/0x28
 [<ffffffff8020c20a>] do_softirq+0x2c/0x7d
 [<ffffffff80214850>] smp_apic_timer_interrupt+0x54/0x67
 [<ffffffff8020a206>] apic_timer_interrupt+0x66/0x70
 <EOI>  [<ffffffff8020c259>] do_softirq+0x7b/0x7d
 [<ffffffff802266e8>] ksoftirqd+0x4f/0x8f
 [<ffffffff8023312a>] kthread+0xcb/0xf5
 [<ffffffff8020a3e8>] child_rip+0xa/0x12
 [<ffffffff8023305f>] kthread+0x0/0xf5
 [<ffffffff8020a3de>] child_rip+0x0/0x12




BUG: soft lockup detected on CPU#1!

Call Trace:
 <IRQ>  [<ffffffff8023fbdf>] softlockup_tick+0xda/0xec
 [<ffffffff80229ba5>] update_process_times+0x42/0x68
 [<ffffffff8021421e>] smp_local_timer_interrupt+0x32/0x55
 [<ffffffff804f162a>] ip_rcv+0x0/0x48e
 [<ffffffff8021484b>] smp_apic_timer_interrupt+0x4f/0x67
 [<ffffffff8020a206>] apic_timer_interrupt+0x66/0x70
 [<ffffffff804f162a>] ip_rcv+0x0/0x48e
 [<ffffffff8051bd40>] ipt_do_table+0xbf/0x315
 [<ffffffff804eb445>] nf_iterate+0x3f/0x7b
 [<ffffffff804f2aa0>] ip_forward_finish+0x0/0x3e
 [<ffffffff804eb4e0>] nf_hook_slow+0x5f/0xca
 [<ffffffff804f2aa0>] ip_forward_finish+0x0/0x3e
 [<ffffffff804f2c4c>] ip_forward+0x16e/0x212
 [<ffffffff804f1a71>] ip_rcv+0x447/0x48e
 [<ffffffff803de54c>] e1000_clean_rx_irq+0x41e/0x4ea
 [<ffffffff803e1dea>] e1000_clean+0x2f7/0x4b0
 [<ffffffff802413d4>] handle_edge_irq+0x106/0x12f
 [<ffffffff802412ce>] handle_edge_irq+0x0/0x12f
 [<ffffffff8020c392>] do_IRQ+0x137/0x159
 [<ffffffff804dcb1a>] net_rx_action+0x78/0x14a
 [<ffffffff802268b0>] __do_softirq+0x56/0xd3
 [<ffffffff80226699>] ksoftirqd+0x0/0x8f
 [<ffffffff8020a75c>] call_softirq+0x1c/0x28
 [<ffffffff8020c20a>] do_softirq+0x2c/0x7d
 [<ffffffff80214850>] smp_apic_timer_interrupt+0x54/0x67
 [<ffffffff8020a206>] apic_timer_interrupt+0x66/0x70
 <EOI>  [<ffffffff8020c259>] do_softirq+0x7b/0x7d
 [<ffffffff802266e8>] ksoftirqd+0x4f/0x8f
 [<ffffffff8023312a>] kthread+0xcb/0xf5
 [<ffffffff8020a3e8>] child_rip+0xa/0x12
 [<ffffffff8023305f>] kthread+0x0/0xf5
 [<ffffffff8020a3de>] child_rip+0x0/0x12



BUG: soft lockup detected on CPU#1!

Call Trace:
 <IRQ>  [<ffffffff8023fbdf>] softlockup_tick+0xda/0xec
 [<ffffffff80229ba5>] update_process_times+0x42/0x68
 [<ffffffff8021421e>] smp_local_timer_interrupt+0x32/0x55
 [<ffffffff804f162a>] ip_rcv+0x0/0x48e
 [<ffffffff8021484b>] smp_apic_timer_interrupt+0x4f/0x67
 [<ffffffff8020a206>] apic_timer_interrupt+0x66/0x70
 [<ffffffff804f162a>] ip_rcv+0x0/0x48e
 [<ffffffff8051bf49>] ipt_do_table+0x2c8/0x315
 [<ffffffff804eb445>] nf_iterate+0x3f/0x7b
 [<ffffffff804f2aa0>] ip_forward_finish+0x0/0x3e
 [<ffffffff804eb4e0>] nf_hook_slow+0x5f/0xca
 [<ffffffff804f2aa0>] ip_forward_finish+0x0/0x3e
 [<ffffffff804f2c4c>] ip_forward+0x16e/0x212
 [<ffffffff804f1a71>] ip_rcv+0x447/0x48e
 [<ffffffff803de54c>] e1000_clean_rx_irq+0x41e/0x4ea
 [<ffffffff803e1dea>] e1000_clean+0x2f7/0x4b0
 [<ffffffff802413d4>] handle_edge_irq+0x106/0x12f
 [<ffffffff802412ce>] handle_edge_irq+0x0/0x12f
 [<ffffffff8020c392>] do_IRQ+0x137/0x159
 [<ffffffff804dcb1a>] net_rx_action+0x78/0x14a
 [<ffffffff802268b0>] __do_softirq+0x56/0xd3
 [<ffffffff80226699>] ksoftirqd+0x0/0x8f
 [<ffffffff8020a75c>] call_softirq+0x1c/0x28
 [<ffffffff8020c20a>] do_softirq+0x2c/0x7d
 [<ffffffff80214850>] smp_apic_timer_interrupt+0x54/0x67
 [<ffffffff8020a206>] apic_timer_interrupt+0x66/0x70
 <EOI>  [<ffffffff8020c259>] do_softirq+0x7b/0x7d
 [<ffffffff802266e8>] ksoftirqd+0x4f/0x8f
 [<ffffffff8023312a>] kthread+0xcb/0xf5
 [<ffffffff8020a3e8>] child_rip+0xa/0x12
 [<ffffffff8023305f>] kthread+0x0/0xf5
 [<ffffffff8020a3de>] child_rip+0x0/0x12



BUG: soft lockup detected on CPU#1!

Call Trace:
 <IRQ>  [<ffffffff8023fbdf>] softlockup_tick+0xda/0xec
 [<ffffffff80229ba5>] update_process_times+0x42/0x68
 [<ffffffff8021421e>] smp_local_timer_interrupt+0x32/0x55
 [<ffffffff804f162a>] ip_rcv+0x0/0x48e
 [<ffffffff8021484b>] smp_apic_timer_interrupt+0x4f/0x67
 [<ffffffff8020a206>] apic_timer_interrupt+0x66/0x70
 [<ffffffff804f162a>] ip_rcv+0x0/0x48e
 [<ffffffff8051bd40>] ipt_do_table+0xbf/0x315
 [<ffffffff804f162a>] ip_rcv+0x0/0x48e
 [<ffffffff804eb445>] nf_iterate+0x3f/0x7b
 [<ffffffff804f2aa0>] ip_forward_finish+0x0/0x3e
 [<ffffffff804eb4e0>] nf_hook_slow+0x5f/0xca
 [<ffffffff804f2aa0>] ip_forward_finish+0x0/0x3e
 [<ffffffff804f2c4c>] ip_forward+0x16e/0x212
 [<ffffffff804f1a71>] ip_rcv+0x447/0x48e
 [<ffffffff803de54c>] e1000_clean_rx_irq+0x41e/0x4ea
 [<ffffffff803e1dea>] e1000_clean+0x2f7/0x4b0
 [<ffffffff80229c60>] lock_timer_base+0x1b/0x3c
 [<ffffffff80229fde>] __mod_timer+0xa6/0xb4
 [<ffffffff804dcb1a>] net_rx_action+0x78/0x14a
 [<ffffffff802268b0>] __do_softirq+0x56/0xd3
 [<ffffffff8020a75c>] call_softirq+0x1c/0x28
 [<ffffffff8020c20a>] do_softirq+0x2c/0x7d
 [<ffffffff8020c392>] do_IRQ+0x137/0x159
 [<ffffffff80226699>] ksoftirqd+0x0/0x8f
 [<ffffffff80209b51>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff8020c259>] do_softirq+0x7b/0x7d
 [<ffffffff802266e8>] ksoftirqd+0x4f/0x8f
 [<ffffffff8023312a>] kthread+0xcb/0xf5
 [<ffffffff8020a3e8>] child_rip+0xa/0x12
 [<ffffffff8023305f>] kthread+0x0/0xf5
 [<ffffffff8020a3de>] child_rip+0x0/0x12




BUG: soft lockup detected on CPU#1!

Call Trace:
 <IRQ>  [<ffffffff8023fbdf>] softlockup_tick+0xda/0xec
 [<ffffffff80229ba5>] update_process_times+0x42/0x68
 [<ffffffff8021421e>] smp_local_timer_interrupt+0x32/0x55
 [<ffffffff804f162a>] ip_rcv+0x0/0x48e
 [<ffffffff8021484b>] smp_apic_timer_interrupt+0x4f/0x67
 [<ffffffff8020a206>] apic_timer_interrupt+0x66/0x70
 [<ffffffff804f162a>] ip_rcv+0x0/0x48e
 [<ffffffff8051bd44>] ipt_do_table+0xc3/0x315
 [<ffffffff8021421e>] smp_local_timer_interrupt+0x32/0x55
 [<ffffffff8040e3f6>] bnx2_start_xmit+0x0/0x487
 [<ffffffff804eb445>] nf_iterate+0x3f/0x7b
 [<ffffffff804f2aa0>] ip_forward_finish+0x0/0x3e
 [<ffffffff804eb4e0>] nf_hook_slow+0x5f/0xca
 [<ffffffff804f2aa0>] ip_forward_finish+0x0/0x3e
 [<ffffffff804f2c4c>] ip_forward+0x16e/0x212
 [<ffffffff804f1a71>] ip_rcv+0x447/0x48e
 [<ffffffff803de54c>] e1000_clean_rx_irq+0x41e/0x4ea
 [<ffffffff803e1dea>] e1000_clean+0x2f7/0x4b0
 [<ffffffff8020c392>] do_IRQ+0x137/0x159
 [<ffffffff804dcb1a>] net_rx_action+0x78/0x14a
 [<ffffffff802268b0>] __do_softirq+0x56/0xd3
 [<ffffffff8020a75c>] call_softirq+0x1c/0x28
 [<ffffffff8020c20a>] do_softirq+0x2c/0x7d
 [<ffffffff8020c392>] do_IRQ+0x137/0x159
 [<ffffffff80226699>] ksoftirqd+0x0/0x8f
 [<ffffffff80209b51>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff8020c259>] do_softirq+0x7b/0x7d
 [<ffffffff802266e8>] ksoftirqd+0x4f/0x8f
 [<ffffffff8023312a>] kthread+0xcb/0xf5
 [<ffffffff8020a3e8>] child_rip+0xa/0x12
 [<ffffffff8023305f>] kthread+0x0/0xf5
 [<ffffffff8020a3de>] child_rip+0x0/0x12




BUG: soft lockup detected on CPU#1!

Call Trace:
 <IRQ>  [<ffffffff8023fbdf>] softlockup_tick+0xda/0xec
 [<ffffffff80229ba5>] update_process_times+0x42/0x68
 [<ffffffff8021421e>] smp_local_timer_interrupt+0x32/0x55
 [<ffffffff804f162a>] ip_rcv+0x0/0x48e
 [<ffffffff8021484b>] smp_apic_timer_interrupt+0x4f/0x67
 [<ffffffff8020a206>] apic_timer_interrupt+0x66/0x70
 [<ffffffff804f162a>] ip_rcv+0x0/0x48e
 [<ffffffff8051bd57>] ipt_do_table+0xd6/0x315
 [<ffffffff804eb445>] nf_iterate+0x3f/0x7b
 [<ffffffff804f2aa0>] ip_forward_finish+0x0/0x3e
 [<ffffffff804eb4e0>] nf_hook_slow+0x5f/0xca
 [<ffffffff804f2aa0>] ip_forward_finish+0x0/0x3e
 [<ffffffff804f2c4c>] ip_forward+0x16e/0x212
 [<ffffffff804f1a71>] ip_rcv+0x447/0x48e
 [<ffffffff803de54c>] e1000_clean_rx_irq+0x41e/0x4ea
 [<ffffffff803e1dea>] e1000_clean+0x2f7/0x4b0
 [<ffffffff802413d4>] handle_edge_irq+0x106/0x12f
 [<ffffffff802412ce>] handle_edge_irq+0x0/0x12f
 [<ffffffff8020c392>] do_IRQ+0x137/0x159
 [<ffffffff804dcb1a>] net_rx_action+0x78/0x14a
 [<ffffffff802268b0>] __do_softirq+0x56/0xd3
 [<ffffffff80226699>] ksoftirqd+0x0/0x8f
 [<ffffffff8020a75c>] call_softirq+0x1c/0x28
 [<ffffffff8020c20a>] do_softirq+0x2c/0x7d
 [<ffffffff80214850>] smp_apic_timer_interrupt+0x54/0x67
 [<ffffffff8020a206>] apic_timer_interrupt+0x66/0x70
 <EOI>  [<ffffffff8020c259>] do_softirq+0x7b/0x7d
 [<ffffffff802266e8>] ksoftirqd+0x4f/0x8f
 [<ffffffff8023312a>] kthread+0xcb/0xf5
 [<ffffffff8020a3e8>] child_rip+0xa/0x12
 [<ffffffff8023305f>] kthread+0x0/0xf5
 [<ffffffff8020a3de>] child_rip+0x0/0x12




BUG: soft lockup detected on CPU#1!

Call Trace:
 <IRQ>  [<ffffffff8023fbdf>] softlockup_tick+0xda/0xec
 [<ffffffff80229ba5>] update_process_times+0x42/0x68
 [<ffffffff8021421e>] smp_local_timer_interrupt+0x32/0x55
 [<ffffffff804f162a>] ip_rcv+0x0/0x48e
 [<ffffffff8021484b>] smp_apic_timer_interrupt+0x4f/0x67
 [<ffffffff8020a206>] apic_timer_interrupt+0x66/0x70
 [<ffffffff804f162a>] ip_rcv+0x0/0x48e
 [<ffffffff8051bd4f>] ipt_do_table+0xce/0x315
 [<ffffffff80214850>] smp_apic_timer_interrupt+0x54/0x67
 [<ffffffff804eb445>] nf_iterate+0x3f/0x7b
 [<ffffffff804f2aa0>] ip_forward_finish+0x0/0x3e
 [<ffffffff804eb4e0>] nf_hook_slow+0x5f/0xca
 [<ffffffff804f2aa0>] ip_forward_finish+0x0/0x3e
 [<ffffffff804f2c4c>] ip_forward+0x16e/0x212
 [<ffffffff804f1a71>] ip_rcv+0x447/0x48e
 [<ffffffff803de54c>] e1000_clean_rx_irq+0x41e/0x4ea
 [<ffffffff803e1dea>] e1000_clean+0x2f7/0x4b0
 [<ffffffff80222bbd>] printk+0x4e/0x56
 [<ffffffff804dcb1a>] net_rx_action+0x78/0x14a
 [<ffffffff802268b0>] __do_softirq+0x56/0xd3
 [<ffffffff8020a75c>] call_softirq+0x1c/0x28
 [<ffffffff8020c20a>] do_softirq+0x2c/0x7d
 [<ffffffff8020c392>] do_IRQ+0x137/0x159
 [<ffffffff80226699>] ksoftirqd+0x0/0x8f
 [<ffffffff80209b51>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff8020c259>] do_softirq+0x7b/0x7d
 [<ffffffff802266e8>] ksoftirqd+0x4f/0x8f
 [<ffffffff8023312a>] kthread+0xcb/0xf5
 [<ffffffff8020a3e8>] child_rip+0xa/0x12
 [<ffffffff8023305f>] kthread+0x0/0xf5
 [<ffffffff8020a3de>] child_rip+0x0/0x12




BUG: soft lockup detected on CPU#1!

Call Trace:
 <IRQ>  [<ffffffff8023fbdf>] softlockup_tick+0xda/0xec
 [<ffffffff80229ba5>] update_process_times+0x42/0x68
 [<ffffffff8021421e>] smp_local_timer_interrupt+0x32/0x55
 [<ffffffff8040e3f6>] bnx2_start_xmit+0x0/0x487
 [<ffffffff8021484b>] smp_apic_timer_interrupt+0x4f/0x67
 [<ffffffff8020a206>] apic_timer_interrupt+0x66/0x70
 [<ffffffff8040e3f6>] bnx2_start_xmit+0x0/0x487
 [<ffffffff804e7c51>] __qdisc_run+0x1b9/0x1c2
 [<ffffffff804dea9d>] dev_queue_xmit+0x123/0x247
 [<ffffffff804f68f4>] ip_output+0x1e7/0x22b
 [<ffffffff804f2c94>] ip_forward+0x1b6/0x212
 [<ffffffff804f1a71>] ip_rcv+0x447/0x48e
 [<ffffffff803de54c>] e1000_clean_rx_irq+0x41e/0x4ea
 [<ffffffff803e1dea>] e1000_clean+0x2f7/0x4b0
 [<ffffffff80222bbd>] printk+0x4e/0x56
 [<ffffffff8021bf72>] task_rq_lock+0x3d/0x6f
 [<ffffffff804dcb1a>] net_rx_action+0x78/0x14a
 [<ffffffff802268b0>] __do_softirq+0x56/0xd3
 [<ffffffff80226699>] ksoftirqd+0x0/0x8f
 [<ffffffff8020a75c>] call_softirq+0x1c/0x28
 [<ffffffff8020c20a>] do_softirq+0x2c/0x7d
 [<ffffffff80214850>] smp_apic_timer_interrupt+0x54/0x67
 [<ffffffff8020a206>] apic_timer_interrupt+0x66/0x70
 <EOI>  [<ffffffff8020c259>] do_softirq+0x7b/0x7d
 [<ffffffff802266e8>] ksoftirqd+0x4f/0x8f
 [<ffffffff8023312a>] kthread+0xcb/0xf5
 [<ffffffff8020a3e8>] child_rip+0xa/0x12
 [<ffffffff8023305f>] kthread+0x0/0xf5
 [<ffffffff8020a3de>] child_rip+0x0/0x12




BUG: soft lockup detected on CPU#1!

Call Trace:
 <IRQ>  [<ffffffff8023fbdf>] softlockup_tick+0xda/0xec
 [<ffffffff80229ba5>] update_process_times+0x42/0x68
 [<ffffffff8021421e>] smp_local_timer_interrupt+0x32/0x55
 [<ffffffff804f162a>] ip_rcv+0x0/0x48e
 [<ffffffff8021484b>] smp_apic_timer_interrupt+0x4f/0x67
 [<ffffffff8020a206>] apic_timer_interrupt+0x66/0x70
 [<ffffffff804f162a>] ip_rcv+0x0/0x48e
 [<ffffffff8051bd3d>] ipt_do_table+0xbc/0x315
 [<ffffffff804eb445>] nf_iterate+0x3f/0x7b
 [<ffffffff804f2aa0>] ip_forward_finish+0x0/0x3e
 [<ffffffff804eb4e0>] nf_hook_slow+0x5f/0xca
 [<ffffffff804f2aa0>] ip_forward_finish+0x0/0x3e
 [<ffffffff804f2c4c>] ip_forward+0x16e/0x212
 [<ffffffff804f1a71>] ip_rcv+0x447/0x48e
 [<ffffffff803de54c>] e1000_clean_rx_irq+0x41e/0x4ea
 [<ffffffff803e1dea>] e1000_clean+0x2f7/0x4b0
 [<ffffffff8021bf72>] task_rq_lock+0x3d/0x6f
 [<ffffffff804dcb1a>] net_rx_action+0x78/0x14a
 [<ffffffff802268b0>] __do_softirq+0x56/0xd3
 [<ffffffff80226699>] ksoftirqd+0x0/0x8f
 [<ffffffff8020a75c>] call_softirq+0x1c/0x28
 [<ffffffff8020c20a>] do_softirq+0x2c/0x7d
 [<ffffffff80214850>] smp_apic_timer_interrupt+0x54/0x67
 [<ffffffff8020a206>] apic_timer_interrupt+0x66/0x70
 <EOI>  [<ffffffff8020c259>] do_softirq+0x7b/0x7d
 [<ffffffff802266e8>] ksoftirqd+0x4f/0x8f
 [<ffffffff8023312a>] kthread+0xcb/0xf5
 [<ffffffff8020a3e8>] child_rip+0xa/0x12
 [<ffffffff8023305f>] kthread+0x0/0xf5
 [<ffffffff8020a3de>] child_rip+0x0/0x12




BUG: soft lockup detected on CPU#1!

Call Trace:
 <IRQ>  [<ffffffff8023fbdf>] softlockup_tick+0xda/0xec
 [<ffffffff80229ba5>] update_process_times+0x42/0x68
 [<ffffffff8021421e>] smp_local_timer_interrupt+0x32/0x55
 [<ffffffff804f162a>] ip_rcv+0x0/0x48e
 [<ffffffff8021484b>] smp_apic_timer_interrupt+0x4f/0x67
 [<ffffffff8020a206>] apic_timer_interrupt+0x66/0x70
 [<ffffffff804f162a>] ip_rcv+0x0/0x48e
 [<ffffffff8051bd3d>] ipt_do_table+0xbc/0x315
 [<ffffffff804eb445>] nf_iterate+0x3f/0x7b
 [<ffffffff804f2aa0>] ip_forward_finish+0x0/0x3e
 [<ffffffff804eb4e0>] nf_hook_slow+0x5f/0xca
 [<ffffffff804f2aa0>] ip_forward_finish+0x0/0x3e
 [<ffffffff804f2c4c>] ip_forward+0x16e/0x212
 [<ffffffff804f1a71>] ip_rcv+0x447/0x48e
 [<ffffffff803de54c>] e1000_clean_rx_irq+0x41e/0x4ea
 [<ffffffff803e1dea>] e1000_clean+0x2f7/0x4b0
 [<ffffffff80222bbd>] printk+0x4e/0x56
 [<ffffffff804dcb1a>] net_rx_action+0x78/0x14a
 [<ffffffff802268b0>] __do_softirq+0x56/0xd3
 [<ffffffff8020a75c>] call_softirq+0x1c/0x28
 [<ffffffff8020c20a>] do_softirq+0x2c/0x7d
 [<ffffffff8020c392>] do_IRQ+0x137/0x159
 [<ffffffff80226699>] ksoftirqd+0x0/0x8f
 [<ffffffff80209b51>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff8020c259>] do_softirq+0x7b/0x7d
 [<ffffffff802266e8>] ksoftirqd+0x4f/0x8f
 [<ffffffff8023312a>] kthread+0xcb/0xf5
 [<ffffffff8020a3e8>] child_rip+0xa/0x12
 [<ffffffff8023305f>] kthread+0x0/0xf5
 [<ffffffff8020a3de>] child_rip+0x0/0x12




BUG: soft lockup detected on CPU#1!

Call Trace:
 <IRQ>  [<ffffffff8023fbdf>] softlockup_tick+0xda/0xec
 [<ffffffff80229ba5>] update_process_times+0x42/0x68
 [<ffffffff8021421e>] smp_local_timer_interrupt+0x32/0x55
 [<ffffffff8040e3f6>] bnx2_start_xmit+0x0/0x487
 [<ffffffff8021484b>] smp_apic_timer_interrupt+0x4f/0x67
 [<ffffffff8020a206>] apic_timer_interrupt+0x66/0x70
 [<ffffffff8040e3f6>] bnx2_start_xmit+0x0/0x487
 [<ffffffff804e7381>] eth_type_trans+0x3e/0xed
 [<ffffffff803de3f2>] e1000_clean_rx_irq+0x2c4/0x4ea
 [<ffffffff803e1dea>] e1000_clean+0x2f7/0x4b0
 [<ffffffff802413d4>] handle_edge_irq+0x106/0x12f
 [<ffffffff802412ce>] handle_edge_irq+0x0/0x12f
 [<ffffffff8020c392>] do_IRQ+0x137/0x159
 [<ffffffff804dcb1a>] net_rx_action+0x78/0x14a
 [<ffffffff802268b0>] __do_softirq+0x56/0xd3
 [<ffffffff80226699>] ksoftirqd+0x0/0x8f
 [<ffffffff8020a75c>] call_softirq+0x1c/0x28
 [<ffffffff8020c20a>] do_softirq+0x2c/0x7d
 [<ffffffff80214850>] smp_apic_timer_interrupt+0x54/0x67
 [<ffffffff8020a206>] apic_timer_interrupt+0x66/0x70
 <EOI>  [<ffffffff8020c259>] do_softirq+0x7b/0x7d
 [<ffffffff802266e8>] ksoftirqd+0x4f/0x8f
 [<ffffffff8023312a>] kthread+0xcb/0xf5
 [<ffffffff8020a3e8>] child_rip+0xa/0x12
 [<ffffffff8023305f>] kthread+0x0/0xf5
 [<ffffffff8020a3de>] child_rip+0x0/0x12




BUG: soft lockup detected on CPU#1!

Call Trace:
 <IRQ>  [<ffffffff8023fbdf>] softlockup_tick+0xda/0xec
 [<ffffffff80229ba5>] update_process_times+0x42/0x68
 [<ffffffff8021421e>] smp_local_timer_interrupt+0x32/0x55
 [<ffffffff804f162a>] ip_rcv+0x0/0x48e
 [<ffffffff8021484b>] smp_apic_timer_interrupt+0x4f/0x67
 [<ffffffff8020a206>] apic_timer_interrupt+0x66/0x70
 [<ffffffff804f162a>] ip_rcv+0x0/0x48e
 [<ffffffff8051bd57>] ipt_do_table+0xd6/0x315
 [<ffffffff80339ef8>] swiotlb_map_single+0x4d/0xf1
 [<ffffffff804eb445>] nf_iterate+0x3f/0x7b
 [<ffffffff804f2aa0>] ip_forward_finish+0x0/0x3e
 [<ffffffff804eb4e0>] nf_hook_slow+0x5f/0xca
 [<ffffffff804f2aa0>] ip_forward_finish+0x0/0x3e
 [<ffffffff804f2c4c>] ip_forward+0x16e/0x212
 [<ffffffff804f1a71>] ip_rcv+0x447/0x48e
 [<ffffffff803de54c>] e1000_clean_rx_irq+0x41e/0x4ea
 [<ffffffff803e1dea>] e1000_clean+0x2f7/0x4b0
 [<ffffffff80209b51>] ret_from_intr+0x0/0xa
 [<ffffffff8040e3f6>] bnx2_start_xmit+0x0/0x487
 [<ffffffff804dcb1a>] net_rx_action+0x78/0x14a
 [<ffffffff802268b0>] __do_softirq+0x56/0xd3
 [<ffffffff8020a75c>] call_softirq+0x1c/0x28
 [<ffffffff8020c20a>] do_softirq+0x2c/0x7d
 [<ffffffff8020c392>] do_IRQ+0x137/0x159
 [<ffffffff80226699>] ksoftirqd+0x0/0x8f
 [<ffffffff80209b51>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff8020c259>] do_softirq+0x7b/0x7d
 [<ffffffff802266e8>] ksoftirqd+0x4f/0x8f
 [<ffffffff8023312a>] kthread+0xcb/0xf5
 [<ffffffff8020a3e8>] child_rip+0xa/0x12
 [<ffffffff8023305f>] kthread+0x0/0xf5
 [<ffffffff8020a3de>] child_rip+0x0/0x12




BUG: soft lockup detected on CPU#1!

Call Trace:
 <IRQ>  [<ffffffff8023fbdf>] softlockup_tick+0xda/0xec
 [<ffffffff80229ba5>] update_process_times+0x42/0x68
 [<ffffffff8021421e>] smp_local_timer_interrupt+0x32/0x55
 [<ffffffff804f162a>] ip_rcv+0x0/0x48e
 [<ffffffff8021484b>] smp_apic_timer_interrupt+0x4f/0x67
 [<ffffffff8020a206>] apic_timer_interrupt+0x66/0x70
 [<ffffffff804f162a>] ip_rcv+0x0/0x48e
 [<ffffffff8051bd57>] ipt_do_table+0xd6/0x315
 [<ffffffff804eb445>] nf_iterate+0x3f/0x7b
 [<ffffffff804f2aa0>] ip_forward_finish+0x0/0x3e
 [<ffffffff804eb4e0>] nf_hook_slow+0x5f/0xca
 [<ffffffff804f2aa0>] ip_forward_finish+0x0/0x3e
 [<ffffffff804f2c4c>] ip_forward+0x16e/0x212
 [<ffffffff804f1a71>] ip_rcv+0x447/0x48e
 [<ffffffff803de54c>] e1000_clean_rx_irq+0x41e/0x4ea
 [<ffffffff803e1dea>] e1000_clean+0x2f7/0x4b0
 [<ffffffff80222bbd>] printk+0x4e/0x56
 [<ffffffff804dcb1a>] net_rx_action+0x78/0x14a
 [<ffffffff802268b0>] __do_softirq+0x56/0xd3
 [<ffffffff8020a75c>] call_softirq+0x1c/0x28
 [<ffffffff8020c20a>] do_softirq+0x2c/0x7d
 [<ffffffff8020c392>] do_IRQ+0x137/0x159
 [<ffffffff80226699>] ksoftirqd+0x0/0x8f
 [<ffffffff80209b51>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff8020c259>] do_softirq+0x7b/0x7d
 [<ffffffff802266e8>] ksoftirqd+0x4f/0x8f
 [<ffffffff8023312a>] kthread+0xcb/0xf5
 [<ffffffff8020a3e8>] child_rip+0xa/0x12
 [<ffffffff8023305f>] kthread+0x0/0xf5
 [<ffffffff8020a3de>] child_rip+0x0/0x12




BUG: soft lockup detected on CPU#1!

Call Trace:
 <IRQ>  [<ffffffff8023fbdf>] softlockup_tick+0xda/0xec
 [<ffffffff80229ba5>] update_process_times+0x42/0x68
 [<ffffffff8021421e>] smp_local_timer_interrupt+0x32/0x55
 [<ffffffff804f162a>] ip_rcv+0x0/0x48e
 [<ffffffff8021484b>] smp_apic_timer_interrupt+0x4f/0x67
 [<ffffffff8020a206>] apic_timer_interrupt+0x66/0x70
 [<ffffffff804f162a>] ip_rcv+0x0/0x48e
 [<ffffffff8051bf49>] ipt_do_table+0x2c8/0x315
 [<ffffffff804eb445>] nf_iterate+0x3f/0x7b
 [<ffffffff804f2aa0>] ip_forward_finish+0x0/0x3e
 [<ffffffff804eb4e0>] nf_hook_slow+0x5f/0xca
 [<ffffffff804f2aa0>] ip_forward_finish+0x0/0x3e
 [<ffffffff804f2c4c>] ip_forward+0x16e/0x212
 [<ffffffff804f1a71>] ip_rcv+0x447/0x48e
 [<ffffffff803de54c>] e1000_clean_rx_irq+0x41e/0x4ea
 [<ffffffff803e1dea>] e1000_clean+0x2f7/0x4b0
 [<ffffffff80229c60>] lock_timer_base+0x1b/0x3c
 [<ffffffff80229fde>] __mod_timer+0xa6/0xb4
 [<ffffffff804dcb1a>] net_rx_action+0x78/0x14a
 [<ffffffff802268b0>] __do_softirq+0x56/0xd3
 [<ffffffff8020a75c>] call_softirq+0x1c/0x28
 [<ffffffff8020c20a>] do_softirq+0x2c/0x7d
 [<ffffffff8020c392>] do_IRQ+0x137/0x159
 [<ffffffff80226699>] ksoftirqd+0x0/0x8f
 [<ffffffff80209b51>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff8020c259>] do_softirq+0x7b/0x7d
 [<ffffffff802266e8>] ksoftirqd+0x4f/0x8f
 [<ffffffff8023312a>] kthread+0xcb/0xf5
 [<ffffffff8020a3e8>] child_rip+0xa/0x12
 [<ffffffff8023305f>] kthread+0x0/0xf5
 [<ffffffff8020a3de>] child_rip+0x0/0x12






--Boundary-00=_N9IzFWu6zijktM1--
