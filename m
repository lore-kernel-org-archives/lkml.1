Return-Path: <linux-kernel-owner+w=401wt.eu-S1756257AbYISH3m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756257AbYISH3m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 03:29:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750970AbYISH3d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 03:29:33 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:27585 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840AbYISH3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 03:29:32 -0400
Message-ID: <f488382f0809190029n13b87ad1s153e5b983f301f31@mail.gmail.com>
Date: Fri, 19 Sep 2008 00:29:29 -0700
From: "Steven Noonan" <steven@uplinklabs.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [ath9k-devel] ath9k: massive unexplained latency in 2.6.27 (rc5, rc6, probably others)
Cc: "Luis Rodriguez" <Luis.Rodriguez@atheros.com>,
       "Ingo Molnar" <mingo@elte.hu>,
       "ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080919030125.GG7408@tesla>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <43e72e890809181134ybbec8fdxcb2a466aa17fe390@mail.gmail.com>
	 <f488382f0809181200u9aa03fcv4fc70bd1be7acc71@mail.gmail.com>
	 <43e72e890809181344q416b5944w3332ee5a33db048c@mail.gmail.com>
	 <f488382f0809181449x7343aa7endff066cb5836a73c@mail.gmail.com>
	 <20080918220102.GE7408@tesla>
	 <43e72e890809181508w5232a14ewbf2bf18fe90a92d5@mail.gmail.com>
	 <f488382f0809181604l105535bkceecd44c590bc88b@mail.gmail.com>
	 <43e72e890809181610h3a7729d8s4c8484d97b21932e@mail.gmail.com>
	 <f488382f0809181952g628ab5a4nd86f396a08f4d6c8@mail.gmail.com>
	 <20080919030125.GG7408@tesla>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 18, 2008 at 8:01 PM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> Thanks for testing, and glad to see this is resolved.
>

Damn. It's back. I was using wireless normally this evening. Browsing
the web, that kind of thing, and then the wireless inexplicably
dropped (even with the group rekeying patch), so I unloaded/reloaded
the module. This popped up in dmesg:

[ 3834.375658] vendor=8086 device=27d2
[ 3834.375666] ath9k 0000:03:00.0: PCI INT A disabled
[ 3834.375716] ath9k: driver unloaded
[ 3838.552419] ath9k: 0.1
[ 3838.552502] vendor=8086 device=27d2
[ 3838.552511] ath9k 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[ 3838.552532] ath9k 0000:03:00.0: setting latency timer to 64
[ 3838.688924] phy1: Selected rate control algorithm 'ath9k_rate_control'
[ 3838.693652] phy1: Atheros 5416: mem=0xffffc20000060000, irq=17
[ 3839.427125] irq 17: nobody cared (try booting with the "irqpoll" option)
[ 3839.427136] Pid: 0, comm: swapper Tainted: P
2.6.27-rc6-tip-00478-g74f1a36 #1
[ 3839.427141] Call Trace:
[ 3839.427145]  <IRQ>  [<ffffffff802219c5>] ? read_hpet+0x9/0x1c
[ 3839.427165]  [<ffffffff8026af71>] __report_bad_irq+0x3d/0x8c
[ 3839.427172]  [<ffffffff8026b0c6>] note_interrupt+0x106/0x160
[ 3839.427180]  [<ffffffff8026b801>] handle_fasteoi_irq+0xad/0xda
[ 3839.427188]  [<ffffffff8020f7b0>] do_IRQ+0x10c/0x190
[ 3839.427194]  [<ffffffff8020c551>] ret_from_intr+0x0/0xa
[ 3839.427198]  <EOI>  [<ffffffff8026c6f0>] rcu_pending+0x62/0x6e
[ 3839.427211]  [<ffffffff8025bc11>] ? tick_nohz_stop_sched_tick+0x2e4/0x2f3
[ 3839.427218]  [<ffffffff8020ad94>] cpu_idle+0x7b/0xdb
[ 3839.427226]  [<ffffffff8060c921>] rest_init+0x75/0x77
[ 3839.427231] handlers:
[ 3839.427234] [<ffffffffa0240238>] (ath_isr+0x0/0x170 [ath9k])
[ 3839.427263] Disabling IRQ #17
[ 3842.263699] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[ 3848.035003] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[ 3848.432701] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[ 3850.216947] wlan0: authenticate with AP 00:1e:52:79:4d:01
[ 3850.217027] wlan0: authenticate with AP 00:1e:52:79:4d:01
[ 3850.228326] wlan0: authenticated
[ 3850.228336] wlan0: associate with AP 00:1e:52:79:4d:01
[ 3850.428140] wlan0: associate with AP 00:1e:52:79:4d:01
[ 3850.628151] wlan0: associate with AP 00:1e:52:79:4d:01
[ 3850.728305] wlan0: RX AssocResp from 00:1e:52:79:4d:01 (capab=0x431
status=0 aid=1)
[ 3850.728314] wlan0: associated
[ 3850.728655] wlan0 (WE) : Wireless Event too big (320)
[ 3850.743377] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[ 3860.855104] wlan0: no IPv6 routers present

I rebuilt the module with DBG_ATH_INTERRUPT, but it somehow stumbled
itself back into working order while I was compiling. I can't keep the
interrupt debugging on all the time because it's just -too verbose-,
and when I pop a debug version of the module in, then it's too late to
track the issue....

- Steven
