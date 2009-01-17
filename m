Return-Path: <linux-kernel-owner+w=401wt.eu-S1766011AbZAQStj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766011AbZAQStj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 13:49:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763315AbZAQSta
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 13:49:30 -0500
Received: from main.gmane.org ([80.91.229.2]:59256 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763220AbZAQSt3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 13:49:29 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Sitsofe Wheeler <sitsofe@yahoo.com>
Subject: warn_slowpath in dev_watchdog
Date: Sat, 17 Jan 2009 18:49:18 +0000 (UTC)
Message-ID: <gkt97e$ti0$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: pc212s.cs.york.ac.uk
User-Agent: Pan/0.133 (House of Butterflies)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On an ever so slightly modified 2.6.28. I think this only happens when 
the upstream router/switch goes out to lunch and packets are being sent. 
It is reproducible but only appears on a home network...

[  204.704065] ------------[ cut here ]------------
[  204.704074] WARNING: at net/sched/sch_generic.c:226 dev_watchdog
+0x22b/0x240()
[  204.704080] NETDEV WATCHDOG: eth0 (atl2): transmit timed out
[  204.704087] Pid: 0, comm: swapper Not tainted 2.6.28skw-00025-gaee9cf6 
#7
[  204.704092] Call Trace:
[  204.704103]  [<c0126373>] warn_slowpath+0x63/0x80
[  204.704114]  [<c0140030>] ? timekeeping_resume+0xc0/0xf0
[  204.704125]  [<c022366e>] ? strlcpy+0x1e/0x60
[  204.704132]  [<c037bf5b>] dev_watchdog+0x22b/0x240
[  204.704141]  [<c03e5fb7>] ? _spin_unlock_irq+0x27/0x30
[  204.704149]  [<c014a04f>] ? trace_hardirqs_on_caller+0x7f/0x150
[  204.704157]  [<c014a12b>] ? trace_hardirqs_on+0xb/0x10
[  204.704166]  [<c012eafd>] run_timer_softirq+0x14d/0x1b0
[  204.704173]  [<c037bd30>] ? dev_watchdog+0x0/0x240
[  204.704181]  [<c012aadd>] ? __do_softirq+0x3d/0x110
[  204.704188]  [<c037bd30>] ? dev_watchdog+0x0/0x240
[  204.704196]  [<c012ab06>] __do_softirq+0x66/0x110
[  204.704203]  [<c012abd8>] ? do_softirq+0x28/0x60
[  204.704211]  [<c012ac05>] do_softirq+0x55/0x60
[  204.704218]  [<c012af67>] irq_exit+0x67/0x80
[  204.704226]  [<c0105745>] do_IRQ+0x65/0xc0
[  204.704233]  [<c0103ea8>] common_interrupt+0x28/0x30
[  204.704241]  [<c014007b>] ? sync_cmos_clock+0x1b/0xb0
[  204.704251]  [<c0277f13>] ? acpi_idle_enter_bm+0x1f2/0x223
[  204.704259]  [<c0337928>] cpuidle_idle_call+0x68/0xc0
[  204.704265]  [<c0101f2b>] cpu_idle+0x3b/0x80
[  204.704273]  [<c03da22d>] rest_init+0x4d/0x60
[  204.704278] ---[ end trace 2f4b380121b45313 ]---

-- 
Sitsofe

