Return-Path: <linux-kernel-owner+w=401wt.eu-S1754654AbYIHRSv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754654AbYIHRSv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 13:18:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752439AbYIHRSm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 13:18:42 -0400
Received: from mga11.intel.com ([192.55.52.93]:9141 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752080AbYIHRSl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 13:18:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,359,1217833200"; 
   d="scan'208";a="377971253"
Date: Mon, 8 Sep 2008 10:18:40 -0700
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Li, Shaohua" <shaohua.li@intel.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [RFC 0/4] Using HPET in MSI mode and setting up per CPU HPET timers
Message-ID: <20080908171840.GA31009@linux-os.sc.intel.com>
References: <20080906010214.229910000@intel.com> <20080906124234.GG30964@elte.hu> <20080906130353.GA30340@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080906130353.GA30340@elte.hu>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 06, 2008 at 06:03:53AM -0700, Ingo Molnar wrote:
> 
> it crashes two testsystems, the fault on a NULL pointer in hpet init,
> with:
> 
> initcall print_all_ICs+0x0/0x520 returned 0 after 26 msecs
> calling  hpet_late_init+0x0/0x1c0
> BUG: unable to handle kernel NULL pointer dereference at 000000000000008c
> IP: [<ffffffff80d228be>] hpet_late_init+0xfe/0x1c0
> PGD 0
> Oops: 0000 [1] SMP
> CPU 0
> Modules linked in:
> Pid: 1, comm: swapper Not tainted 2.6.27-rc5 #29725
> RIP: 0010:[<ffffffff80d228be>]  [<ffffffff80d228be>] hpet_late_init+0xfe/0x1c0
> RSP: 0018:ffff88003fa07dd0  EFLAGS: 00010246
> RAX: 0000000000000000 RBX: 0000000000000003 RCX: 0000000000000000
> RDX: ffffc20000000160 RSI: 0000000000000000 RDI: 0000000000000003
> RBP: ffff88003fa07e90 R08: 0000000000000000 R09: ffff88003fa07dd0
> R10: 0000000000000001 R11: 0000000000000000 R12: ffff88003fa07dd0
> R13: 0000000000000002 R14: ffffc20000000000 R15: 000000006f57e511
> FS:  0000000000000000(0000) GS:ffffffff80cf6a80(0000) knlGS:0000000000000000
> CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> CR2: 000000000000008c CR3: 0000000000201000 CR4: 00000000000006e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process swapper (pid: 1, threadinfo ffff88003fa06000, task ffff88003fa08000)
> Stack:  00000000fed00000 ffffc20000000000 0000000100000003 0000000800000002
>  0000000000000000 0000000000000000 0000000000000000 0000000000000000
>  0000000000000000 0000000000000000 0000000000000000 0000000000000000
> Call Trace:
>  [<ffffffff80d227c0>] ? hpet_late_init+0x0/0x1c0
>  [<ffffffff80209045>] do_one_initcall+0x45/0x190
>  [<ffffffff80296f39>] ? register_irq_proc+0x19/0xe0
>  [<ffffffff80d0d140>] ? early_idt_handler+0x0/0x73
>  [<ffffffff80d0dabc>] kernel_init+0x14c/0x1b0
>  [<ffffffff80942ac1>] ? trace_hardirqs_on_thunk+0x3a/0x3f
>  [<ffffffff8020dbd9>] child_rip+0xa/0x11
>  [<ffffffff8020ceee>] ? restore_args+0x0/0x30
>  [<ffffffff80d0d970>] ? kernel_init+0x0/0x1b0
>  [<ffffffff8020dbcf>] ? child_rip+0x0/0x11
> Code: 20 48 83 c1 01 48 39 f1 75 e3 44 89 e8 4c 8b 05 29 29 22 00 31 f6 48 8d 78 01 66 66 90 89 f0 48 8d 04 80 48 c1 e0 05 4a 8d 0c 00 <f6> 81 8c 00 00 00 08 74 26 8b 81 80 00 00 00 8b 91 88 00 00 00
> RIP  [<ffffffff80d228be>] hpet_late_init+0xfe/0x1c0
>  RSP <ffff88003fa07dd0>
> CR2: 000000000000008c
> Kernel panic - not syncing: Fatal exception


There was one code path, with CONFIG_PCI_MSI disabled, where we were accessing
hpet_devs without initialization. That resulted in the above crash. The change
below adds a check for hpet_devs.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Shaohua Li <shaohua.li@intel.com>

---
 arch/x86/kernel/hpet.c |   28 +++++++++++++++++++---------
 1 file changed, 19 insertions(+), 9 deletions(-)

Index: tip/arch/x86/kernel/hpet.c
===================================================================
--- tip.orig/arch/x86/kernel/hpet.c	2008-09-08 09:20:00.000000000 -0700
+++ tip/arch/x86/kernel/hpet.c	2008-09-08 09:44:23.000000000 -0700
@@ -124,6 +124,24 @@ EXPORT_SYMBOL_GPL(is_hpet_enabled);
  * timer 0 and timer 1 in case of RTC emulation.
  */
 #ifdef CONFIG_HPET
+static void hpet_reserve_msi_timers(struct hpet_data *hd)
+{
+	int i;
+
+	if (!hpet_devs)
+		return;
+
+	for (i = 0; i < hpet_num_timers; i++) {
+		struct hpet_dev *hdev = &hpet_devs[i];
+
+		if (!(hdev->flags & HPET_DEV_VALID))
+			continue;
+
+		hd->hd_irq[hdev->num] = hdev->irq;
+		hpet_reserve_timer(hd, hdev->num);
+	}
+}
+
 static void hpet_reserve_platform_timers(unsigned long id)
 {
 	struct hpet __iomem *hpet = hpet_virt_address;
@@ -156,15 +174,7 @@ static void hpet_reserve_platform_timers
 			Tn_INT_ROUTE_CNF_SHIFT;
 	}
 
-	for (i = 0; i < nrtimers; i++) {
-		struct hpet_dev *hdev = &hpet_devs[i];
-
-		if (!(hdev->flags & HPET_DEV_VALID))
-			continue;
-
-		hd.hd_irq[hdev->num] = hdev->irq;
-		hpet_reserve_timer(&hd, hdev->num);
-	}
+	hpet_reserve_msi_timers(&hd);
 
 	hpet_alloc(&hd);
 
