Return-Path: <linux-kernel-owner+w=401wt.eu-S1754519AbZLYK2H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754519AbZLYK2H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Dec 2009 05:28:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752518AbZLYK2G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Dec 2009 05:28:06 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:50201 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752024AbZLYK2E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Dec 2009 05:28:04 -0500
Date: Fri, 25 Dec 2009 11:27:31 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Len Brown <lenb@kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Matthew Garrett <mjg@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: -tip: origin tree boot crash
Message-ID: <20091225102731.GA25513@elte.hu>
References: <alpine.LFD.2.00.0912241350510.11961@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0912241350510.11961@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Today's -tip crashed during bootup on one of my testsystems:

[   28.616777] initcall eeepc_laptop_init+0x0/0x4d returned -19 after 29853 usecs
[   28.624002] calling  dell_wmi_init+0x0/0x126 @ 1
[   28.629128] device: 'input1': device_add
[   28.633113] PM: Adding info for No Bus:input1
[   28.637678] input: Dell WMI hotkeys as /class/input/input1
[   28.643216] evbug.c: Connected device: input1 (Dell WMI hotkeys at wmi/input0)
[   28.650449] BUG: unable to handle kernel NULL pointer dereference at 00000014
[   28.654439] IP: [<c17f7f21>] wmi_install_notify_handler+0x31/0x70
[   28.654439] *pde = 00000000 
[   28.654439] Oops: 0000 [#1] DEBUG_PAGEALLOC
[   28.654439] last sysfs file: 
[   28.654439] Modules linked in:
[   28.654439] 
[   28.654439] Pid: 1, comm: swapper Not tainted 2.6.33-rc2-tip-00158-g2bd999a-dirty #2238 A8N-E/System Product Name
[   28.654439] EIP: 0060:[<c17f7f21>] EFLAGS: 00010282 CPU: 0
[   28.654439] EIP is at wmi_install_notify_handler+0x31/0x70
[   28.654439] EAX: 00000006 EBX: c17f55d0 ECX: 0000009d EDX: fffffff4
[   28.654439] ESI: 00000000 EDI: 00000000 EBP: f7052f90 ESP: f7052f84
[   28.654439]  DS: 007b ES: 007b FS: 0000 GS: 00e0 SS: 0068
[   28.654439] Process swapper (pid: 1, ti=f7052000 task=f7070000 task.ti=f7052000)
[   28.654439] Stack:
[   28.654439]  fffffff4 00000000 00000006 f7052fa4 c2165992 aa66398a 00000006 aa66398a
[   28.654439] <0> f7052fd0 c1001122 c1d58799 c2165874 00000001 0000749d 00000000 c2165874
[   28.654439] <0> c219a214 c21271d6 00000000 f7052fe4 c2127262 00000000 000000e0 00000000
[   28.654439] Call Trace:
[   28.654439]  [<c2165992>] ? dell_wmi_init+0x11e/0x126
[   28.654439]  [<c1001122>] ? do_one_initcall+0x32/0x1d0
[   28.654439]  [<c2165874>] ? dell_wmi_init+0x0/0x126
[   28.654439]  [<c2165874>] ? dell_wmi_init+0x0/0x126
[   28.654439]  [<c21271d6>] ? kernel_init+0x0/0xe0
[   28.654439]  [<c2127262>] ? kernel_init+0x8c/0xe0
[   28.654439]  [<c10033c6>] ? kernel_thread_helper+0x6/0x10
[   28.654439] Code: 89 5d f8 89 75 fc e8 cf b4 80 ff 85 d2 89 d3 89 ce 74 2f 85 c0 74 2b 8d 55 f4 e8 0b fd ff ff 8b 55 f4 b8 06 00 00 00 85 d2 74 09 <8b> 4a 20 b0 15 85 c9 74 1e 8b 5d f8 8b 75 fc 89 ec 5d c3 8d 74 
[   28.654439] EIP: [<c17f7f21>] wmi_install_notify_handler+0x31/0x70 SS:ESP 0068:f7052f84
[   28.654439] CR2: 0000000000000014
[   28.819532] ---[ end trace 6cbbad4ca20c038d ]---
[   28.824158] Kernel panic - not syncing: Fatal exception
[   28.829394] Pid: 1, comm: swapper Tainted: G      D    2.6.33-rc2-tip-00158-g2bd999a-dirty #2238
[   28.838180] Call Trace:
[   28.840626]  [<c1aa71dc>] ? printk+0x1d/0x1f
[   28.844909]  [<c1aa7110>] panic+0x48/0xf7
[   28.848930]  [<c1aab609>] oops_end+0xb9/0xd0
[   28.853210]  [<c1020086>] no_context+0xc6/0x160
[   28.857752]  [<c10201b0>] __bad_area_nosemaphore+0x90/0x140
[   28.863334]  [<c1020277>] bad_area_nosemaphore+0x17/0x20
[   28.868656]  [<c1aacf5d>] do_page_fault+0x2dd/0x380
[   28.873545]  [<c17f55d0>] ? dell_wmi_notify+0x0/0x170
[   28.878604]  [<c1aacc80>] ? do_page_fault+0x0/0x380
[   28.883494]  [<c1aaaa90>] error_code+0x70/0x80
[   28.887947]  [<c17f55d0>] ? dell_wmi_notify+0x0/0x170
[   28.893007]  [<c17f7f21>] ? wmi_install_notify_handler+0x31/0x70
[   28.899024]  [<c2165992>] dell_wmi_init+0x11e/0x126
[   28.903910]  [<c1001122>] do_one_initcall+0x32/0x1d0
[   28.908885]  [<c2165874>] ? dell_wmi_init+0x0/0x126
[   28.913774]  [<c2165874>] ? dell_wmi_init+0x0/0x126
[   28.918662]  [<c21271d6>] ? kernel_init+0x0/0xe0
[   28.923289]  [<c2127262>] kernel_init+0x8c/0xe0
[   28.927831]  [<c10033c6>] kernel_thread_helper+0x6/0x10

The crash is due to this commit from yesterday's (v2.6.33-rc2) upstream tree:

| commit 1fdd407f4e3f2ecb453954cbebb6c22491c61853
| Author: Dmitry Torokhov <dmitry.torokhov@gmail.com>
| Date:   Thu Dec 17 22:19:42 2009 -0800
|
|    dell-wmi: do not keep driver loaded on unsupported boxes
|    
|    There is no point in having the driver loaded in memory if we fail
|    to locate particular WMI GUID.
|    
|    Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
|    Acked-by: Matthew Garrett <mjg@redhat.com>
|    Signed-off-by: Len Brown <len.brown@intel.com>

I've reverted the commit from -tip for now.

Thanks,

	Ingo
