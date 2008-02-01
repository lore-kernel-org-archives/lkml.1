Return-Path: <linux-kernel-owner+w=401wt.eu-S1759939AbYBARMJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759939AbYBARMJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 12:12:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756660AbYBARL6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 12:11:58 -0500
Received: from hera.kernel.org ([140.211.167.34]:54665 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756069AbYBARL5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 12:11:57 -0500
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: "Denys Fedoryshchenko" <denys@visp.net.lb>
Subject: Re: kernel panic on 2.6.24/iTCO_wdt not rebooting machine
Date: Fri, 1 Feb 2008 12:11:41 -0500
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, wim@iguana.be
References: <20080201151243.M2879@visp.net.lb>
In-Reply-To: <20080201151243.M2879@visp.net.lb>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="koi8-r"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802011211.42089.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 01 February 2008 10:12, Denys Fedoryshchenko wrote:
> Hi
> 
> I sent already report to netdev, but most interesting question i have, that 
> machine is not rebooted (it was set over sysctl value to kernel.panic)  and 
> watchdog didnt reboot it too.
> 
> I set:
> 
> kernel.panic = 10
> kernel.panic_on_oops = 10
> 
> watchdog iTCO_wdt + watchdog from busybox, and still machine didn't came back 
> online from panic! But after pressing reset button by guy on location (it is 
> very far in mountains, roads is blocked by snow now, there is no keyboard/
> screen even to check what's happening).
> 
> After testing i notice that iTCO_wdt not working on this motherboard.
> 
> in dmesg
> Feb  1 19:34:17 10.184.184.1 kernel: [   58.112496] iTCO_wdt: Intel TCO 
> WatchDog Timer Driver v1.02 (26-Jul-2007)
> Feb  1 19:34:17 10.184.184.1 kernel: [   58.113114] iTCO_wdt: Found a ICH9R 
> TCO device (Version=2, TCOBASE=0x0460)
> Feb  1 19:34:17 10.184.184.1 kernel: [   58.113654] iTCO_wdt: initialized. 
> heartbeat=30 sec (nowayout=0)
> 
> 1)i launch busybox watchdog:
> watchdog -t 5 /dev/watchdog
> i can see it in processes
> 
> 2)then i do
> killall -9 watchdog
> i can see in dmesg
> Feb  2 00:55:23 10.184.184.1 kernel: [ 6400.419418] iTCO_wdt: Unexpected 
> close, not stopping watchdog!
> 
> Machine is not rebooting. It is not rebooting also on panic (over sysctl 
> value). Motherboard: Intel DP35DP
> 
> Here is panic message, just for information.
> 
...
> Feb  1 09:08:50 SERVER [12380.067806] Call Trace:
> Feb  1 09:08:50 SERVER [12380.067839]  [<c0134663>]
> Feb  1 09:08:50 SERVER __remove_hrtimer+0x5d/0x64
> Feb  1 09:08:50 SERVER [12380.067861]  [<c013515b>]
> Feb  1 09:08:50 SERVER hrtimer_interrupt+0x10c/0x19a
> Feb  1 09:08:50 SERVER [12380.067883]  [<c0113963>]
> Feb  1 09:08:50 SERVER smp_apic_timer_interrupt+0x6f/0x80
> Feb  1 09:08:50 SERVER [12380.067905]  [<c0105838>]
> Feb  1 09:08:50 SERVER apic_timer_interrupt+0x28/0x30
> Feb  1 09:08:50 SERVER [12380.067928]  [<c02be6d7>]
> Feb  1 09:08:50 SERVER _spin_lock_irqsave+0x13/0x27
> Feb  1 09:08:50 SERVER [12380.067949]  [<c0134bc7>]
> Feb  1 09:08:50 SERVER lock_hrtimer_base+0x15/0x2f
> Feb  1 09:08:50 SERVER [12380.067970]  [<c0134ca0>]
> Feb  1 09:08:50 SERVER hrtimer_start+0x16/0xf4
> Feb  1 09:08:50 SERVER [12380.067991]  [<c027ec43>]
> Feb  1 09:08:50 SERVER qdisc_watchdog_schedule+0x1e/0x21
> Feb  1 09:08:50 SERVER [12380.068013]  [<f89f8fe6>]
> Feb  1 09:08:50 SERVER htb_dequeue+0x6ef/0x6fb [sch_htb]
> Feb  1 09:08:50 SERVER [12380.068036]  [<c028ac4d>]
> Feb  1 09:08:50 SERVER ip_rcv+0x1fc/0x237
> Feb  1 09:08:50 SERVER [12380.068057]  [<c0135297>]
> Feb  1 09:08:50 SERVER hrtimer_get_next_event+0xae/0xbb
> Feb  1 09:08:50 SERVER [12380.068078]  [<c0135297>]
> Feb  1 09:08:50 SERVER hrtimer_get_next_event+0xae/0xbb
> Feb  1 09:08:50 SERVER [12380.068099]  [<c0136e26>]
> Feb  1 09:08:50 SERVER getnstimeofday+0x2b/0xb5
> Feb  1 09:08:50 SERVER [12380.068118]  [<c0138d70>]
> Feb  1 09:08:50 SERVER clockevents_program_event+0xe0/0xee
> Feb  1 09:08:50 SERVER [12380.068140]  [<c027da0e>]
> Feb  1 09:08:50 SERVER __qdisc_run+0x2a/0x163
> Feb  1 09:08:50 SERVER [12380.068161]  [<c02722d8>]
> Feb  1 09:08:50 SERVER net_tx_action+0xa8/0xcc
> Feb  1 09:08:50 SERVER [12380.068180]  [<c027ec65>]
> Feb  1 09:08:50 SERVER qdisc_watchdog+0x0/0x1b
> Feb  1 09:08:50 SERVER [12380.068199]  [<c027ec7d>]
> Feb  1 09:08:50 SERVER qdisc_watchdog+0x18/0x1b
> Feb  1 09:08:50 SERVER [12380.068218]  [<c0135007>]
> Feb  1 09:08:50 SERVER run_hrtimer_softirq+0x4e/0x96
> Feb  1 09:08:50 SERVER [12380.068241]  [<c0126a82>]
> Feb  1 09:08:50 SERVER __do_softirq+0x5d/0xc1
> Feb  1 09:08:50 SERVER [12380.068260]  [<c0126b18>]
> Feb  1 09:08:50 SERVER do_softirq+0x32/0x36
> Feb  1 09:08:50 SERVER [12380.068279]  [<c0126d6a>]
> Feb  1 09:08:50 SERVER irq_exit+0x38/0x6b
> Feb  1 09:08:50 SERVER [12380.068298]  [<c0113968>]
> Feb  1 09:08:50 SERVER smp_apic_timer_interrupt+0x74/0x80
> Feb  1 09:08:50 SERVER [12380.068319]  [<c0105838>]
> Feb  1 09:08:50 SERVER apic_timer_interrupt+0x28/0x30
> Feb  1 09:08:50 SERVER [12380.068343]  [<c0103243>]
> Feb  1 09:08:50 SERVER mwait_idle_with_hints+0x3c/0x40
> Feb  1 09:08:50 SERVER [12380.068365]  [<c0103247>]
> Feb  1 09:08:50 SERVER mwait_idle+0x0/0xa
> Feb  1 09:08:50 SERVER [12380.068384]  [<c010357e>]
> Feb  1 09:08:50 SERVER cpu_idle+0x98/0xb9
> Feb  1 09:08:50 SERVER [12380.068403]  [<c03848c2>]
> Feb  1 09:08:50 SERVER start_kernel+0x2d7/0x2df
> Feb  1 09:08:50 SERVER [12380.068422]  [<c03840e0>]
> Feb  1 09:08:50 SERVER unknown_bootoption+0x0/0x195
> Feb  1 09:08:50 SERVER [12380.068444]  =======================

What do you see if you build with CONFIG_HIGH_RES_TIMERS=n

Does it work better if you boot with "acpi=off"?
if yes, how about with just pnpacpi=off?

thanks,
-Len
