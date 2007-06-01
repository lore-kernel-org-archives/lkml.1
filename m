Return-Path: <linux-kernel-owner+w=401wt.eu-S1760904AbXFAMDO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760904AbXFAMDO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 08:03:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756780AbXFAMC7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 08:02:59 -0400
Received: from fork.at ([212.227.165.27]:56810 "EHLO ganesha.fork.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753868AbXFAMC6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 08:02:58 -0400
X-Greylist: delayed 1439 seconds by postgrey-1.27 at vger.kernel.org; Fri, 01 Jun 2007 08:02:57 EDT
Message-ID: <46600547.4080700@fork.at>
Date: Fri, 01 Jun 2007 13:38:47 +0200
From: Harald Lampesberger <harald.lampesberger@fork.at>
User-Agent: Thunderbird 1.5.0.10 (X11/20070403)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PREEMPT_RT] BUG: using smp_processor_id() in preemptible [00000000]
 code: sshd/4126
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

while working with Linux 2.6.21.3-rt9 I got following error in the
kernel-log:

[ 1522.504000] BUG: using smp_processor_id() in preemptible [00000000]
code: sshd/4126
[ 1522.504000] caller is ebt_do_table+0x2e/0x600 [ebtables]
[ 1522.504000]  [<c023977b>] debug_smp_processor_id+0xab/0xb0
[ 1522.504000]  [<f8870e6e>] ebt_do_table+0x2e/0x600 [ebtables]
[ 1522.504000]  [<c03f3284>] rt_read_unlock+0x24/0x50
[ 1522.504000]  [<f88713d5>] ebt_do_table+0x595/0x600 [ebtables]
[ 1522.504000]  [<c038d903>] nf_iterate+0x63/0x90
[ 1522.504000]  [<c038da8e>] nf_hook_slow+0x5e/0xe0
[ 1522.504000]  [<c03e8c60>] br_dev_queue_push_xmit+0x0/0x90
[ 1522.504000]  [<c03e8d3e>] br_forward_finish+0x4e/0x60
[ 1522.504000]  [<c03e8c60>] br_dev_queue_push_xmit+0x0/0x90
[ 1522.504000]  [<c03e8e07>] __br_deliver+0x27/0x70
[ 1522.504000]  [<c03e8cf0>] br_forward_finish+0x0/0x60
[ 1522.504000]  [<c03e7d57>] br_dev_xmit+0x57/0x70
[ 1522.504000]  [<c0378d24>] dev_hard_start_xmit+0x1e4/0x2c0
[ 1522.504000]  [<f8b98726>] nf_nat_out+0x66/0xe0 [iptable_nat]
[ 1522.504000]  [<c037a80f>] dev_queue_xmit+0x27f/0x2d0
[ 1522.504000]  [<c037f3a1>] neigh_resolve_output+0xc1/0x2b0
[ 1522.504000]  [<c03990c0>] ip_finish_output+0x0/0x200
[ 1522.504000]  [<c039a832>] ip_output+0x182/0x2b0
[ 1522.504000]  [<c03990c0>] ip_finish_output+0x0/0x200
[ 1522.504000]  [<c0399c79>] ip_queue_xmit+0x1c9/0x4b0
[ 1522.504000]  [<c0397650>] dst_output+0x0/0x10
[ 1522.504000]  [<c03a9ea0>] tcp_transmit_skb+0x3c0/0x740
[ 1522.504000]  [<c0146e92>] add_preempt_count+0x12/0xe0
[ 1522.504000]  [<c03ab7f8>] __tcp_push_pending_frames+0x118/0x8a0
[ 1522.504000]  [<c0118f8b>] try_to_wake_up+0x5b/0x470
[ 1522.504000]  [<c03a096d>] tcp_sendmsg+0x78d/0xb40
[ 1522.504000]  [<c017e976>] core_sys_select+0x266/0x340
[ 1522.504000]  [<c03bc6e7>] inet_sendmsg+0x37/0x70
[ 1522.504000]  [<c036d230>] sock_aio_write+0x120/0x130
[ 1522.504000]  [<c027d833>] tty_ldisc_deref+0x43/0x70
[ 1522.504000]  [<c0170ec5>] do_sync_write+0xd5/0x120
[ 1522.504000]  [<c0132d40>] autoremove_wake_function+0x0/0x50
[ 1522.504000]  [<c017181f>] vfs_write+0x14f/0x160
[ 1522.504000]  [<c0171ea1>] sys_write+0x41/0x70
[ 1522.504000]  [<c0102cb0>] sysenter_past_esp+0x5d/0x81
[ 1522.504000]  =======================
[ 1522.504000] ---------------------------
[ 1522.504000] | preempt count: 00000001 ]
[ 1522.504000] | 1-level deep critical section nesting:
[ 1522.504000] ----------------------------------------
[ 1522.504000] .. [<c023971f>] .... debug_smp_processor_id+0x4f/0xb0
[ 1522.504000] .....[<00000000>] ..   ( <= 0x0)


Unfortunally I don't have the experience/knowledge to write a proper
patch for this bug. I hope this report contains enough information about
the bug!
I'm no subscriber of the mailing-list -- is it possible to CC responses
to my email address harald.lampesberger [AT] fork.at ?

Thanks,
Harald



