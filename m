Return-Path: <linux-kernel-owner+w=401wt.eu-S1758618AbYDYEu6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758618AbYDYEu6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 00:50:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753355AbYDYEur
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 00:50:47 -0400
Received: from ns.store20.com ([212.7.7.16]:51609 "EHLO store20.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753093AbYDYEuq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 00:50:46 -0400
X-Greylist: delayed 442 seconds by postgrey-1.27 at vger.kernel.org; Fri, 25 Apr 2008 00:50:46 EDT
Subject: [REGRESSION] x86: support for new UV apic
From: Priit Laes <plaes@plaes.org>
To: linux-kernel <linux-kernel@vger.kernel.org>,
       Jack Steiner <steiner@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 25 Apr 2008 07:43:20 +0300
Message-Id: <1209098600.3707.13.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

I am getting two following warnings (probable one per each CPU core)
using the latest Linus's git:

WARNING: at arch/x86/kernel/genapic_64.c:86 read_apic_id+0x30/0x62()
Modules linked in:
Pid: 1, comm: swapper Not tainted 2.6.25-03563-gf7288b1 #20

Call Trace:
 [<ffffffff8022f1e1>] warn_on_slowpath+0x51/0x63
 [<ffffffff80282e48>] sys_ioctl+0x2d/0x5d
 [<ffffffff805185ff>] _spin_lock+0xe/0x24
 [<ffffffff80227459>] task_rq_lock+0x3d/0x73
 [<ffffffff805133c3>] set_cpu_sibling_map+0x336/0x350
 [<ffffffff8021c1b8>] read_apic_id+0x30/0x62
 [<ffffffff806d921d>] verify_local_APIC+0x90/0x138
 [<ffffffff806d84b5>] native_smp_prepare_cpus+0x1f9/0x305
 [<ffffffff806ce7b1>] kernel_init+0x59/0x2d9
 [<ffffffff80518a26>] _spin_unlock_irq+0x11/0x2b
 [<ffffffff8020bf48>] child_rip+0xa/0x12
 [<ffffffff806ce758>] kernel_init+0x0/0x2d9
 [<ffffffff8020bf3e>] child_rip+0x0/0x12

---[ end trace ca143223eefdc828 ]---

Few hours of bisecting gave me following commit as a suspect


ac23d4ee3f84de33c16ed7e68f9adee2386e74fb is first bad commit
commit ac23d4ee3f84de33c16ed7e68f9adee2386e74fb
Author: Jack Steiner <steiner@sgi.com>
Date:   Fri Mar 28 14:12:16 2008 -0500

    x86: support for new UV apic

