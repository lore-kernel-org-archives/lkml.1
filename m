Return-Path: <linux-kernel-owner+w=401wt.eu-S1753806AbZC3HdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753806AbZC3HdS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 03:33:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751637AbZC3HdA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 03:33:00 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:37329 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890AbZC3Hc7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 03:32:59 -0400
Message-ID: <49D075A3.1050202@cosmosbay.com>
Date: Mon, 30 Mar 2009 09:32:51 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Roman Mindalev <r000n@r000n.net>
CC: Stephen Hemminger <shemminger@vyatta.com>,
       Patrick McHardy <kaber@trash.net>, LKML <linux-kernel@vger.kernel.org>,
       netfilter@vger.kernel.org
Subject: Re: Regression caused by commit "netfilter: iptables: lock free counters"
References: <20090329234702.4988017f@desktop.r000n.info>
In-Reply-To: <20090329234702.4988017f@desktop.r000n.info>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Mon, 30 Mar 2009 09:32:51 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roman Mindalev a écrit :
> Hi.
> Since 2.6.29-git1 I got many debug messages in kernel log.
> One from them:
> 
> Mar 29 12:06:11 desktop kernel: [  917.414369] BUG: using
> smp_processor_id() in preemptible [00000000] code: hddtemp/2820 Mar 29
> 12:06:11 desktop kernel: [  917.414378] caller is
> ipt_do_table+0xd0/0x3a8 [ip_tables] Mar 29 12:06:11 desktop kernel:
> [  917.414382] Pid: 2820, comm: hddtemp Not tainted
> 2.6.29-05093-gc31f403 #1 Mar 29 12:06:11 desktop kernel: [  917.414386]
> Call Trace: Mar 29 12:06:11 desktop kernel: [  917.414393]
> [<ffffffff8042d037>] debug_smp_processor_id+0xe7/0xf0 Mar 29 12:06:11
> desktop kernel: [  917.414400]  [<ffffffffa0171f10>]
> ipt_do_table+0xd0/0x3a8 [ip_tables] Mar 29 12:06:11 desktop kernel:
> [  917.414414]  [<ffffffffa0180d0e>] ? nf_conntrack_in+0x23e/0x610
> [nf_conntrack] Mar 29 12:06:11 desktop kernel: [  917.414422]
> [<ffffffff8026d47d>] ? trace_hardirqs_off+0xd/0x10 Mar 29 12:06:11
> desktop kernel: [  917.414429]  [<ffffffffa008e0b3>]
> ipt_local_out_hook+0x53/0x60 [iptable_filter] Mar 29 12:06:11 desktop
> kernel: [  917.414435]  [<ffffffff80546a07>] nf_iterate+0x67/0xa0 Mar
> 29 12:06:11 desktop kernel: [  917.414441]  [<ffffffff80551140>] ?
> dst_output+0x0/0x10 Mar 29 12:06:11 desktop kernel: [  917.414446]
> [<ffffffff80546af5>] nf_hook_slow+0xb5/0x100 Mar 29 12:06:11 desktop
> kernel: [  917.414452]  [<ffffffff80551140>] ? dst_output+0x0/0x10 Mar
> 29 12:06:11 desktop kernel: [  917.414458]  [<ffffffff80552f7f>]
> __ip_local_out+0x9f/0xb0 Mar 29 12:06:11 desktop kernel:
> [  917.414464]  [<ffffffff8058c4db>] ? bictcp_cong_avoid+0x4b/0x2d0 Mar
> 29 12:06:11 desktop kernel: [  917.414469]  [<ffffffff80552fa1>]
> ip_local_out+0x11/0x30 Mar 29 12:06:11 desktop kernel: [  917.414474]
> [<ffffffff8055389c>] ip_queue_xmit+0x21c/0x410 Mar 29 12:06:11 desktop
> kernel: [  917.414480]  [<ffffffff80272825>] ?
> print_lock_contention_bug+0x25/0x120 Mar 29 12:06:11 desktop kernel:
> [  917.414486]  [<ffffffff8056810e>] ?
> tcp_established_options+0x3e/0xe0 Mar 29 12:06:11 desktop kernel:
> [  917.414492]  [<ffffffff80272825>] ?
> print_lock_contention_bug+0x25/0x120 Mar 29 12:06:11 desktop kernel:
> [  917.414498]  [<ffffffff80568ef5>] tcp_transmit_skb+0x535/0x820 Mar
> 29 12:06:11 desktop kernel: [  917.414504]  [<ffffffff8056b5fb>]
> tcp_write_xmit+0x20b/0xaa0 Mar 29 12:06:11 desktop kernel:
> [  917.414510]  [<ffffffff8055d451>] ? sk_stream_alloc_skb+0x41/0x110
> Mar 29 12:06:11 desktop kernel: [  917.414515]  [<ffffffff8052799e>] ?
> __alloc_skb+0x6e/0x150 Mar 29 12:06:11 desktop kernel: [  917.414521]
> [<ffffffff8056befb>] __tcp_push_pending_frames+0x2b/0x90 Mar 29
> 12:06:11 desktop kernel: [  917.414527]  [<ffffffff8055ddc3>]
> tcp_sendmsg+0x8a3/0xbb0 Mar 29 12:06:11 desktop kernel: [  917.414533]
> [<ffffffff8051d2bb>] sock_aio_write+0x12b/0x140 Mar 29 12:06:11 desktop
> kernel: [  917.414539]  [<ffffffff802df6f1>] do_sync_write+0xf1/0x140
> Mar 29 12:06:11 desktop kernel: [  917.414545]  [<ffffffff8025e470>] ?
> autoremove_wake_function+0x0/0x40 Mar 29 12:06:11 desktop kernel:
> [  917.414551]  [<ffffffff802e0259>] vfs_write+0x179/0x190 Mar 29
> 12:06:11 desktop kernel: [  917.414557]  [<ffffffff802e0360>]
> sys_write+0x50/0x90 Mar 29 12:06:11 desktop kernel: [  917.414563]
> [<ffffffff8020b51b>] system_call_fastpath+0x16/0x1b
> 
> Result of the bisection:
> 
> 784544739a25c30637397ace5489eeb6e15d7d49 is first bad commit
> commit 784544739a25c30637397ace5489eeb6e15d7d49             
> Author: Stephen Hemminger <shemminger@vyatta.com>           
> Date:   Fri Feb 20 10:35:32 2009 +0100                      
> 
>     netfilter: iptables: lock free counters
>                                            
>     The reader/writer lock in ip_tables is acquired in the critical
>     path of processing packets and is one of the reasons just loading
>     iptables can cause a 20% performance loss. The rwlock serves two
>     functions:
> 
>     1) it prevents changes to table state (xt_replace) while table is
>     in use. This is now handled by doing rcu on the xt_table. When
>     table is replaced, the new table(s) are put in and the old one
>     table(s) are freed after RCU period.
> 
>     2) it provides synchronization when accesing the counter values.
>        This is now handled by swapping in new table_info entries for
>     each cpu then summing the old values, and putting the result back
>     onto one cpu.  On a busy system it may cause sampling to occur at
>     different times on each cpu, but no packet/byte counts are lost in
>     the process.
> 
>     Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
> 
>     Sucessfully tested on my dual quad core machine too, but iptables
>     only (no ipv6 here) BTW, my new "tbench 8" result is 2450 MB/s, (it
>     was 2150 MB/s not so long ago)
> 
>     Acked-by: Eric Dumazet <dada1@cosmosbay.com>
>     Signed-off-by: Patrick McHardy <kaber@trash.net>
> 
> :040000 040000 67ef5761d009330e8d538dd1a3aff77c86995172
> 0d8d6398ced2117bb6995b0c414fd8013685324e M      include :040000 040000
> 0317c745a0722ade9a6c0cbe9d6cb92abbd40efa
> 0eb195a365164c05e7c764ab1c2a7da891276837 M      net
> 
> After reverting commit no more these messages.
> 
> This issue in bugzilla: http://bugzilla.kernel.org/show_bug.cgi?id=12960

Thanks Roman for this excellent report 

Could you try following patch ?

[PATCH] netfilter: use rcu_read_bh() in ipt_do_table()

Commit 784544739a25c30637397ace5489eeb6e15d7d49
(netfilter: iptables: lock free counters) forgot to disable BH
in arpt_do_table(), ipt_do_table() and  ip6t_do_table()

Use rcu_read_lock_bh() instead of rcu_read_lock() cures the problem.

Reported-and-bisected-by: Roman Mindalev <r000n@r000n.net>
Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
---

diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index 35c5f6a..5ba533d 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -253,7 +253,7 @@ unsigned int arpt_do_table(struct sk_buff *skb,
 	indev = in ? in->name : nulldevname;
 	outdev = out ? out->name : nulldevname;
 
-	rcu_read_lock();
+	rcu_read_lock_bh();
 	private = rcu_dereference(table->private);
 	table_base = rcu_dereference(private->entries[smp_processor_id()]);
 
@@ -329,7 +329,7 @@ unsigned int arpt_do_table(struct sk_buff *skb,
 		}
 	} while (!hotdrop);
 
-	rcu_read_unlock();
+	rcu_read_unlock_bh();
 
 	if (hotdrop)
 		return NF_DROP;
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 82ee7c9..810c0b6 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -339,7 +339,7 @@ ipt_do_table(struct sk_buff *skb,
 
 	IP_NF_ASSERT(table->valid_hooks & (1 << hook));
 
-	rcu_read_lock();
+	rcu_read_lock_bh();
 	private = rcu_dereference(table->private);
 	table_base = rcu_dereference(private->entries[smp_processor_id()]);
 
@@ -437,7 +437,7 @@ ipt_do_table(struct sk_buff *skb,
 		}
 	} while (!hotdrop);
 
-	rcu_read_unlock();
+	rcu_read_unlock_bh();
 
 #ifdef DEBUG_ALLOW_ALL
 	return NF_ACCEPT;
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index e89cfa3..dfed176 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -365,7 +365,7 @@ ip6t_do_table(struct sk_buff *skb,
 
 	IP_NF_ASSERT(table->valid_hooks & (1 << hook));
 
-	rcu_read_lock();
+	rcu_read_lock_bh();
 	private = rcu_dereference(table->private);
 	table_base = rcu_dereference(private->entries[smp_processor_id()]);
 
@@ -466,7 +466,7 @@ ip6t_do_table(struct sk_buff *skb,
 #ifdef CONFIG_NETFILTER_DEBUG
 	((struct ip6t_entry *)table_base)->comefrom = NETFILTER_LINK_POISON;
 #endif
-	rcu_read_unlock();
+	rcu_read_unlock_bh();
 
 #ifdef DEBUG_ALLOW_ALL
 	return NF_ACCEPT;

