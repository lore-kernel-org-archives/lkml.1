Return-Path: <linux-kernel-owner+w=401wt.eu-S932625AbXGVMmj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932625AbXGVMmj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 08:42:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760801AbXGVMm3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 08:42:29 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34637 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760713AbXGVMm2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 08:42:28 -0400
Date: Sun, 22 Jul 2007 14:42:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: Wim Van Sebroeck <wim@iguana.be>
Subject: [bug] pcwd_init_module(): WARNING: at lib/kref.c:33 kref_get()
Message-ID: <20070722124224.GA20382@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


enabling CONFIG_PCWATCHDOG=y crashes bzImage bootup, see below. Tested 
on latest -git.

	Ingo

------------------->
Calling initcall 0xc1e81f8c: pcwd_init_module+0x0/0x14()
WARNING: at lib/kref.c:33 kref_get()
 [<c0105f6e>] show_trace_log_lvl+0x19/0x2e
 [<c0106067>] show_trace+0x12/0x14
 [<c010607d>] dump_stack+0x14/0x16
 [<c051aa54>] kref_get+0x37/0x40
 [<c0519dfe>] kobject_get+0x12/0x17
 [<c06fd12a>] get_bus+0x11/0x21
 [<c06fd729>] bus_add_driver+0x18/0x16b
 [<c06fe45a>] driver_register+0x66/0x6b
 [<c0702575>] isa_register_driver+0x27/0x126
 [<c1e81f9e>] pcwd_init_module+0x12/0x14
 [<c1e50838>] kernel_init+0x15a/0x2df
 [<c0105d87>] kernel_thread_helper+0x7/0x10
 =======================
WARNING: at lib/kref.c:33 kref_get()
 [<c0105f6e>] show_trace_log_lvl+0x19/0x2e
 [<c0106067>] show_trace+0x12/0x14
 [<c010607d>] dump_stack+0x14/0x16
 [<c051aa54>] kref_get+0x37/0x40
 [<c0519dfe>] kobject_get+0x12/0x17
 [<c051a429>] kobject_init+0x32/0x43
 [<c051a4c3>] kobject_register+0x15/0x31
 [<c06fd76d>] bus_add_driver+0x5c/0x16b
 [<c06fe45a>] driver_register+0x66/0x6b
 [<c0702575>] isa_register_driver+0x27/0x126
 [<c1e81f9e>] pcwd_init_module+0x12/0x14
 [<c1e50838>] kernel_init+0x15a/0x2df
 [<c0105d87>] kernel_thread_helper+0x7/0x10
 =======================
BUG: spinlock bad magic on CPU#0, swapper/1
 lock: c1b6a888, .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
 [<c0105f6e>] show_trace_log_lvl+0x19/0x2e
 [<c0106067>] show_trace+0x12/0x14
 [<c010607d>] dump_stack+0x14/0x16
 [<c052b0be>] spin_bug+0xa1/0xa9
 [<c052b289>] _raw_spin_lock+0x1e/0x104
 [<c1385f7e>] _spin_lock+0x54/0x62
 [<c051a026>] kobject_shadow_add+0x84/0x171
 [<c051a11d>] kobject_add+0xa/0xc
 [<c051a4ca>] kobject_register+0x1c/0x31
 [<c06fd76d>] bus_add_driver+0x5c/0x16b
 [<c06fe45a>] driver_register+0x66/0x6b
 [<c0702575>] isa_register_driver+0x27/0x126
 [<c1e81f9e>] pcwd_init_module+0x12/0x14
 [<c1e50838>] kernel_init+0x15a/0x2df
 [<c0105d87>] kernel_thread_helper+0x7/0x10
 =======================
