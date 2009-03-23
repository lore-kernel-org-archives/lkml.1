Return-Path: <linux-kernel-owner+w=401wt.eu-S1756622AbZCWMt2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756622AbZCWMt2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 08:49:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755210AbZCWMtS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 08:49:18 -0400
Received: from bu3sch.de ([62.75.166.246]:59385 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753889AbZCWMtR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 08:49:17 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Francois Romieu <romieu@fr.zoreil.com>
Subject: Re: 2.6.27.19 + 28.7: network timeouts for r8169 and 8139too
Date: Mon, 23 Mar 2009 13:47:01 +0100
User-Agent: KMail/1.9.9
Cc: Rui Santos <rsantos@grupopie.com>,
       Michael =?utf-8?q?B=C3=BCker?= <m.bueker@berlin.de>,
       linux-kernel@vger.kernel.org
References: <200903041828.49972.m.bueker@berlin.de> <20090322211159.GA23042@electric-eye.fr.zoreil.com> <200903231247.13467.mb@bu3sch.de>
In-Reply-To: <200903231247.13467.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903231347.01707.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 23 March 2009 12:47:13 Michael Buesch wrote:
> On Sunday 22 March 2009 22:12:00 Francois Romieu wrote:
> > Can you see if one of the attached patches or a combination of them
> > makes a difference for the current (-git) kernel ?
> 
> I think I'm forced to run the test on 2.6.28.8, because current linus-git has
> major bugs in it that let pppd completely fail, which is required for proper operation
> of the machine.
> 
> These two patches apply cleanly (with a small offset) to 2.6.28.8, so I guess
> there's no problem with trying these on the stable kernel.
> 

Ok, it still happens with both patches applied to 2.6.28.8

[    0.723814] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    0.723895] r8169 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.723960] r8169 0000:01:00.0: setting latency timer to 64
[    0.724055] r8169 0000:01:00.0: irq 383 for MSI/MSI-X
[    0.724286] eth0: RTL8168c/8111c at 0xffffc20000542000, 00:1c:c0:8d:2b:47, XID 3c4000c0 IRQ 383
...
Mar 23 13:41:12 quimby kernel: [  185.663615] kjournald starting.  Commit interval 5 seconds
Mar 23 13:41:12 quimby kernel: [  185.693026] EXT3 FS on dm-1, internal journal
Mar 23 13:41:12 quimby kernel: [  185.693103] EXT3-fs: mounted filesystem with ordered data mode.
Mar 23 13:41:13 quimby kernel: [  187.056244] usb 1-7: USB disconnect, address 3
Mar 23 13:41:18 quimby kernel: [  192.003563] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
Mar 23 13:41:18 quimby kernel: [  192.004133] NFSD: starting 90-second grace period
Mar 23 13:41:22 quimby kernel: [  195.752381] warning: `ntpd' uses 32-bit capabilities (legacy support in use)
Mar 23 13:45:13 quimby kernel: [  426.804022] ------------[ cut here ]------------
Mar 23 13:45:13 quimby kernel: [  426.804077] WARNING: at net/sched/sch_generic.c:226 dev_watchdog+0x22e/0x240()
Mar 23 13:45:13 quimby kernel: [  426.804136] NETDEV WATCHDOG: eth0 (r8169): transmit timed out
Mar 23 13:45:13 quimby kernel: [  426.804181] Modules linked in:
Mar 23 13:45:13 quimby kernel: [  426.804247] Pid: 0, comm: swapper Not tainted 2.6.28.8 #10
Mar 23 13:45:13 quimby kernel: [  426.804291] Call Trace:
Mar 23 13:45:13 quimby kernel: [  426.804331]  <IRQ>  [<ffffffff80240aed>] warn_slowpath+0xcd/0x110
Mar 23 13:45:13 quimby kernel: [  426.804412]  [<ffffffff80235a53>] __wake_up+0x43/0x70
Mar 23 13:45:13 quimby kernel: [  426.804458]  [<ffffffff8023776c>] find_busiest_group+0x1dc/0x970
Mar 23 13:45:13 quimby kernel: [  426.804510]  [<ffffffff8025d838>] getnstimeofday+0x58/0xe0
Mar 23 13:45:13 quimby kernel: [  426.804559]  [<ffffffff8040bd81>] strlcpy+0x41/0x50
Mar 23 13:45:13 quimby kernel: [  426.804605]  [<ffffffff8062a2ce>] dev_watchdog+0x22e/0x240
Mar 23 13:45:13 quimby kernel: [  426.804652]  [<ffffffff8023db82>] scheduler_tick+0xd2/0x230
Mar 23 13:45:13 quimby kernel: [  426.804699]  [<ffffffff8062a0a0>] dev_watchdog+0x0/0x240
Mar 23 13:45:13 quimby kernel: [  426.804747]  [<ffffffff8024b1ee>] run_timer_softirq+0x12e/0x200
Mar 23 13:45:13 quimby kernel: [  426.804796]  [<ffffffff8025acfc>] ktime_get+0xc/0x50
Mar 23 13:45:13 quimby kernel: [  426.804843]  [<ffffffff80246833>] __do_softirq+0x93/0x160
Mar 23 13:45:13 quimby kernel: [  426.804892]  [<ffffffff8020d49c>] call_softirq+0x1c/0x30
Mar 23 13:45:13 quimby kernel: [  426.804939]  [<ffffffff8020ee45>] do_softirq+0x35/0x70
Mar 23 13:45:13 quimby kernel: [  426.804984]  [<ffffffff80246525>] irq_exit+0x95/0xa0
Mar 23 13:45:13 quimby kernel: [  426.805030]  [<ffffffff802200c6>] smp_apic_timer_interrupt+0x86/0xd0
Mar 23 13:45:13 quimby kernel: [  426.805080]  [<ffffffff8020ceeb>] apic_timer_interrupt+0x6b/0x70
Mar 23 13:45:13 quimby kernel: [  426.805126]  <EOI>  [<ffffffff8021f7f0>] lapic_next_event+0x0/0x20
Mar 23 13:45:13 quimby kernel: [  426.805202]  [<ffffffff8021469c>] mwait_idle+0x3c/0x50
Mar 23 13:45:13 quimby kernel: [  426.805248]  [<ffffffff8020b34e>] cpu_idle+0x5e/0xb0
Mar 23 13:45:13 quimby kernel: [  426.805292] ---[ end trace 2d80c75815a19f25 ]---
Mar 23 13:45:13 quimby kernel: [  426.821419] r8169: eth0: link up


-- 
Greetings, Michael.
