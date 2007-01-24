Return-Path: <linux-kernel-owner+w=401wt.eu-S965478AbXAXApt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965478AbXAXApt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 19:45:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965477AbXAXApt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 19:45:49 -0500
Received: from smtp4-g19.free.fr ([212.27.42.30]:40626 "EHLO smtp4-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965474AbXAXAps (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 19:45:48 -0500
Subject: Re: 2.6.19.2 sky2/acpi crashes
From: Lionel Landwerlin <landwer@free.fr>
To: Len Brown <lenb@kernel.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <200701231630.55096.lenb@kernel.org>
References: <1169542768.5537.11.camel@cocoduo>
	 <3877989d0701230122r426eb5b0h446c897780923d7a@mail.gmail.com>
	 <1169555238.5747.3.camel@cocoduo>  <200701231630.55096.lenb@kernel.org>
Content-Type: text/plain; charset=utf-8
Date: Wed, 24 Jan 2007 01:45:41 +0100
Message-Id: <1169599541.5235.4.camel@cocoduo>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 23 janvier 2007 à 16:30 -0500, Len Brown a écrit : 
> On Tuesday 23 January 2007 07:27, Lionel Landwerlin wrote:
> > Le mardi 23 janvier 2007 à 17:22 +0800, Luming Yu a écrit :
> > > Please try to remove processor module.
> > 
> > Ok, that's done. Same problem.
> 
> any difference with "idle=poll"?
> if yes, how about "idle=halt"?

idle=poll seems to fix the problem (cpu fan is running almost at full
speed). Maybe I should run a longer test... For now it consists to run
about 15 torrents and watching HDTV through ethernet device.

idle=halt does not : 

Jan 24 01:37:02 cocoduo kernel: [ 1562.672639] NETDEV WATCHDOG: eth0: transmit timed out
Jan 24 01:37:02 cocoduo kernel: [ 1562.672648] sky2 eth0: tx timeout
Jan 24 01:37:02 cocoduo kernel: [ 1562.672656] sky2 eth0: transmit ring 243 .. 222 report=244 done=244
Jan 24 01:37:02 cocoduo kernel: [ 1562.672660] sky2 status report lost?
Jan 24 01:37:11 cocoduo kernel: [ 1571.787958] BUG: soft lockup detected on CPU#0!
Jan 24 01:37:11 cocoduo kernel: [ 1571.787989]  [softlockup_tick+155/208] softlockup_tick+0x9b/0xd0
Jan 24 01:37:11 cocoduo kernel: [ 1571.788007]  [update_process_times+49/128] update_process_times+0x31/0x80
Jan 24 01:37:11 cocoduo kernel: [ 1571.788020]  [smp_apic_timer_interrupt+145/176] smp_apic_timer_interrupt+0x91/0xb0
Jan 24 01:37:11 cocoduo kernel: [ 1571.788032]  [apic_timer_interrupt+31/36] apic_timer_interrupt+0x1f/0x24
Jan 24 01:37:11 cocoduo kernel: [ 1571.788048]  [_spin_lock_bh+15/32] _spin_lock_bh+0xf/0x20
Jan 24 01:37:11 cocoduo kernel: [ 1571.788061]  [pg0+946730645/1068803072] sky2_tx_timeout+0xf5/0x1d0 [sky2]
Jan 24 01:37:11 cocoduo kernel: [ 1571.788083]  [dev_watchdog+0/208] dev_watchdog+0x0/0xd0
Jan 24 01:37:11 cocoduo kernel: [ 1571.788090]  [dev_watchdog+192/208] dev_watchdog+0xc0/0xd0
Jan 24 01:37:11 cocoduo kernel: [ 1571.788099]  [run_timer_softirq+273/400] run_timer_softirq+0x111/0x190
Jan 24 01:37:11 cocoduo kernel: [ 1571.788114]  [__do_softirq+116/240] __do_softirq+0x74/0xf0
Jan 24 01:37:11 cocoduo kernel: [ 1571.788125]  [do_softirq+59/80] do_softirq+0x3b/0x50
Jan 24 01:37:11 cocoduo kernel: [ 1571.788134]  [smp_apic_timer_interrupt+150/176] smp_apic_timer_interrupt+0x96/0xb0
Jan 24 01:37:11 cocoduo kernel: [ 1571.788143]  [apic_timer_interrupt+31/36] apic_timer_interrupt+0x1f/0x24
Jan 24 01:37:11 cocoduo kernel: [ 1571.788153]  [default_idle+0/112] default_idle+0x0/0x70
Jan 24 01:37:11 cocoduo kernel: [ 1571.788166]  [default_idle+54/112] default_idle+0x36/0x70
Jan 24 01:37:11 cocoduo kernel: [ 1571.788175]  [cpu_idle+116/208] cpu_idle+0x74/0xd0
Jan 24 01:37:11 cocoduo kernel: [ 1571.788184]  [start_kernel+872/1072] start_kernel+0x368/0x430
Jan 24 01:37:11 cocoduo kernel: [ 1571.788194]  [unknown_bootoption+0/624] unknown_bootoption+0x0/0x270
Jan 24 01:37:11 cocoduo kernel: [ 1571.788208]  =======================

-- 
Lionel Landwerlin <landwer@free.fr>

