Return-Path: <linux-kernel-owner+w=401wt.eu-S1758611AbZASVb0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758611AbZASVb0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 16:31:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753394AbZASVbR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 16:31:17 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:55136 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753339AbZASVbQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 16:31:16 -0500
Date: Mon, 19 Jan 2009 22:31:06 +0100
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: WARNING: at drivers/dma/dmaengine.c:352
	dma_issue_pending_all+0x77/0x15d()
Message-ID: <20090119213106.GA9648@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.5 required=5.9 tests=BAYES_40 autolearn=no SpamAssassin version=3.2.3
	0.5 BAYES_40               BODY: Bayesian spam probability is 20 to 40%
	[score: 0.3897]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


FYI, i'm getting this on a testbox, on v2.6.29-rc2:

[   78.930438] ------------[ cut here ]------------
[   78.932162] ADDRCONF(NETDEV_UP): eth2: link is not ready
[   78.940748] WARNING: at drivers/dma/dmaengine.c:352 dma_issue_pending_all+0x77/0x15d()
[   78.948876] Hardware name: P4DC6
[   78.952232] client called dma_issue_pending_all without a referencePid: 0, comm: swapper Not tainted 2.6.29-rc2-tip #1
[   78.963176] Call Trace:
[   78.965747]  [<c0177cc9>] warn_slowpath+0x90/0xa6
[   78.970578]  [<c01a7266>] ? __lock_acquire+0x6f2/0x748
[   78.975835]  [<c01a56a9>] ? mark_held_locks+0x45/0x5c
[   78.981012]  [<c0d35100>] ? napi_complete+0x7a/0x97
[   78.986016]  [<c01a587b>] ? trace_hardirqs_on_caller+0x112/0x167
[   78.992139]  [<c01a58db>] ? trace_hardirqs_on+0xb/0xd
[   78.997311]  [<c075e8d4>] ? e1000_clean+0x5a6/0x5f2
[   79.002306]  [<c0d06b34>] dma_issue_pending_all+0x77/0x15d
[   79.007912]  [<c0d358ea>] net_rx_action+0x2cc/0x2e6
[   79.012911]  [<c017f69a>] __do_softirq+0xbb/0x1cf
[   79.017738]  [<c017f5df>] ? __do_softirq+0x0/0x1cf
[   79.022644]  <IRQ>  [<c01cadc5>] ? handle_fasteoi_irq+0x0/0x124
[   79.028778]  [<c017f585>] ? irq_exit+0x50/0xaa
[   79.033340]  [<c012aade>] ? do_IRQ+0x119/0x12f
[   79.037901]  [<c0127d8c>] ? common_interrupt+0x2c/0x34
[   79.043163]  [<c01a00d8>] ? tick_broadcast_oneshot_control+0x10c/0x42e
[   79.049807]  [<c0152398>] ? native_safe_halt+0xa/0xc
[   79.054896]  [<c012f7c1>] ? default_idle+0xbf/0xd2
[   79.059806]  [<c0125765>] ? cpu_idle+0x16a/0x1a4
[   79.064564]  [<c0f4f41f>] ? rest_init+0x53/0x55
[   79.069210] ---[ end trace 230444e9b1c5e1e1 ]---
[   79.074319] e1000: eth2 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
[   79.083245] ADDRCONF(NETDEV_CHANGE): eth2: link becomes ready

the driver that just ran was e1000.

Btw., this format string:

        WARN_ONCE(dmaengine_ref_count == 0,
                  "client called %s without a reference", __func__);

is missing a \n.

	Ingo
