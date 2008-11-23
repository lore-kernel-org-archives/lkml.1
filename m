Return-Path: <linux-kernel-owner+w=401wt.eu-S1758856AbYKWMVl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758856AbYKWMVl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 07:21:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758365AbYKWMVA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 07:21:00 -0500
Received: from bu3sch.de ([62.75.166.246]:33953 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756717AbYKWMU6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 07:20:58 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Yuval Hager <yuval@avramzon.net>
Subject: Re: BCM4312 Fails when xdm is started
Date: Sun, 23 Nov 2008 13:20:30 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Larry Finger <Larry.Finger@lwfinger.net>, bcm43xx-dev@lists.berlios.de,
       LKML <linux-kernel@vger.kernel.org>,
       wireless <linux-wireless@vger.kernel.org>, Peter Stuge <peter@stuge.se>
References: <200811151801.02369.yuval@avramzon.net> <200811221654.09399.mb@bu3sch.de> <200811231350.00207.yuval@avramzon.net>
In-Reply-To: <200811231350.00207.yuval@avramzon.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811231320.30289.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 23 November 2008 12:49:55 Yuval Hager wrote:
> [  182.891400] ****** b43: B43_MMIO_MACCTL 0x840A0503
> [  182.891409] ****** b43: SSB_TMSLOW 0x20150000
> [  258.299027] irq 10: nobody cared (try booting with the "irqpoll" option)


Does the kernel disable the PCI device, if it ignores the IRQ?


> [  258.299038] Pid: 0, comm: swapper Not tainted 2.6.28-rc5 #15
> [  258.299043] Call Trace:
> [  258.299062]  [<c0148d9a>] __report_bad_irq+0x24/0x69
> [  258.299071]  [<c0148da1>] __report_bad_irq+0x2b/0x69
> [  258.299080]  [<c0148ec8>] note_interrupt+0xe9/0x12d
> [  258.299090]  [<c014976d>] handle_level_irq+0x87/0xba
> [  258.299101]  [<c010564e>] do_IRQ+0x89/0x9f
> [  258.299109]  [<c0103ea8>] common_interrupt+0x28/0x30
> [  258.299119]  [<c0125406>] do_softirq+0x37/0x4d
> [  258.299127]  [<c0125301>] __do_softirq+0x62/0x130
> [  258.299135]  [<c0125406>] do_softirq+0x37/0x4d
> [  258.299142]  [<c0105653>] do_IRQ+0x8e/0x9f
> [  258.299150]  [<c0103ea8>] common_interrupt+0x28/0x30
> [  258.299161]  [<c0108682>] default_idle+0x2f/0x4c
> [  258.299168]  [<c0101a20>] cpu_idle+0x63/0x77
> [  258.299173] handlers:
> [  258.299176] [<f7906455>] (b43_interrupt_handler+0x0/0x1b7 [b43])
> [  258.299212] Disabling IRQ #10
> [  258.315148] b43-phy0: Radio hardware status changed to DISABLED
> [  258.315160] b43-phy0: ******** B43_B43_MMIO_RADIO_HWENABLED_HI 0xFFFFFFFF
> [  258.342341] kobject: 'rfkill0' (f43b7d78): kobject_uevent_env
> [  258.342367] kobject: 'rfkill0' (f43b7d78): fill_kobj_path: path = '/class/rfkill/rfkill0'
> [  258.342418] kobject: 'ssb0:0' (f40dfcd8): fill_kobj_path: path = '/devices/pci0000:00/0000:00:02.0/0000:02:00.0/ssb0:0'
> [  258.391951] 
> [  258.391956] =================================
> [  258.391964] [ INFO: inconsistent lock state ]
> [  258.391971] 2.6.28-rc5 #15
> [  258.391975] ---------------------------------
> [  258.391980] inconsistent {in-hardirq-W} -> {hardirq-on-W} usage.
> [  258.391987] X/3965 [HC0[0]:SC1[1]:HE1:SE0] takes:
> [  258.391993]  (&irq_desc_lock_class){++..}, at: [<c0148c60>] try_one_irq+0x15/0xe8
> [  258.392016] {in-hardirq-W} state was registered at:
> [  258.392021]   [<c013bc07>] __lock_acquire+0x490/0x6bc
> [  258.392034]   [<c013be8d>] lock_acquire+0x5a/0x74
> [  258.392043]   [<c01496f8>] handle_level_irq+0x12/0xba
> [  258.392053]   [<c03c4842>] _spin_lock+0x1c/0x45
> [  258.392066]   [<c01496f8>] handle_level_irq+0x12/0xba
> [  258.392076]   [<c01496f8>] handle_level_irq+0x12/0xba
> [  258.392085]   [<c010564e>] do_IRQ+0x89/0x9f
> [  258.392096]   [<c0103ea8>] common_interrupt+0x28/0x30
> [  258.392105]   [<c03c4cc2>] _spin_unlock_irqrestore+0x37/0x39
> [  258.392115]   [<c01487e6>] __setup_irq+0x17a/0x1f3
> [  258.392124]   [<c05ce79d>] start_kernel+0x285/0x2f1
> [  258.392140]   [<ffffffff>] 0xffffffff
> [  258.392159] irq event stamp: 1844456
> [  258.392164] hardirqs last  enabled at (1844456): [<c03c4b6f>] _spin_unlock_irq+0x20/0x23
> [  258.392175] hardirqs last disabled at (1844455): [<c03c4ac3>] _spin_lock_irq+0xa/0x4b
> [  258.392186] softirqs last  enabled at (1844310): [<c0125406>] do_softirq+0x37/0x4d
> [  258.392198] softirqs last disabled at (1844447): [<c0125406>] do_softirq+0x37/0x4d


That's a bit weird. Looks like another bug in the IRQ layer.


> [  258.392208] 
> [  258.392209] other info that might help us debug this:
> [  258.392215] no locks held by X/3965.
> [  258.392219] 
> [  258.392220] stack backtrace:
> [  258.392226] Pid: 3965, comm: X Not tainted 2.6.28-rc5 #15
> [  258.392231] Call Trace:
> [  258.392241]  [<c0139175>] print_usage_bug+0x13d/0x146
> [  258.392249]  [<c013a2ff>] mark_lock+0x4b1/0x7c7
> [  258.392257]  [<c013bc7e>] __lock_acquire+0x507/0x6bc
> [  258.392266]  [<c013be8d>] lock_acquire+0x5a/0x74
> [  258.392275]  [<c0148c60>] try_one_irq+0x15/0xe8
> [  258.392283]  [<c03c4842>] _spin_lock+0x1c/0x45
> [  258.392291]  [<c0148c60>] try_one_irq+0x15/0xe8
> [  258.392300]  [<c0148c60>] try_one_irq+0x15/0xe8
> [  258.392308]  [<c03c4b6f>] _spin_unlock_irq+0x20/0x23
> [  258.392317]  [<c0148d33>] poll_spurious_irqs+0x0/0x43
> [  258.392326]  [<c0148d55>] poll_spurious_irqs+0x22/0x43
> [  258.392338]  [<c012874a>] run_timer_softirq+0x101/0x156
> [  258.392346]  [<c0125321>] __do_softirq+0x82/0x130
> [  258.392354]  [<c0125406>] do_softirq+0x37/0x4d
> [  258.392362]  [<c0105653>] do_IRQ+0x8e/0x9f
> [  258.392370]  [<c0103ea8>] common_interrupt+0x28/0x30

-- 
Greetings Michael.
