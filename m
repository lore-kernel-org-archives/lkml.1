Return-Path: <linux-kernel-owner+w=401wt.eu-S1755660AbZC2UJi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755660AbZC2UJi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 16:09:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751668AbZC2UJ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 16:09:26 -0400
Received: from bruhost-2.ispvds.com ([82.146.33.243]:56089 "EHLO
	bruhost-2.ispvds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752256AbZC2UJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 16:09:25 -0400
X-Greylist: delayed 1321 seconds by postgrey-1.27 at vger.kernel.org; Sun, 29 Mar 2009 16:09:24 EDT
Date: Sun, 29 Mar 2009 23:47:02 +0400
From: Roman Mindalev <r000n@r000n.net>
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: Eric Dumazet <dada1@cosmosbay.com>, Patrick McHardy <kaber@trash.net>,
       LKML <linux-kernel@vger.kernel.org>, netfilter@vger.kernel.org
Subject: Regression caused by commit "netfilter: iptables: lock free
 counters"
Message-ID: <20090329234702.4988017f@desktop.r000n.info>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/JLdNf_00lrT=kinwm=Hmuy6"
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.0.1 (bruhost-2.ispvds.com [82.146.33.243]); Sun, 29 Mar 2009 21:47:10 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--MP_/JLdNf_00lrT=kinwm=Hmuy6
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi.
Since 2.6.29-git1 I got many debug messages in kernel log.
One from them:

Mar 29 12:06:11 desktop kernel: [  917.414369] BUG: using
smp_processor_id() in preemptible [00000000] code: hddtemp/2820 Mar 29
12:06:11 desktop kernel: [  917.414378] caller is
ipt_do_table+0xd0/0x3a8 [ip_tables] Mar 29 12:06:11 desktop kernel:
[  917.414382] Pid: 2820, comm: hddtemp Not tainted
2.6.29-05093-gc31f403 #1 Mar 29 12:06:11 desktop kernel: [  917.414386]
Call Trace: Mar 29 12:06:11 desktop kernel: [  917.414393]
[<ffffffff8042d037>] debug_smp_processor_id+0xe7/0xf0 Mar 29 12:06:11
desktop kernel: [  917.414400]  [<ffffffffa0171f10>]
ipt_do_table+0xd0/0x3a8 [ip_tables] Mar 29 12:06:11 desktop kernel:
[  917.414414]  [<ffffffffa0180d0e>] ? nf_conntrack_in+0x23e/0x610
[nf_conntrack] Mar 29 12:06:11 desktop kernel: [  917.414422]
[<ffffffff8026d47d>] ? trace_hardirqs_off+0xd/0x10 Mar 29 12:06:11
desktop kernel: [  917.414429]  [<ffffffffa008e0b3>]
ipt_local_out_hook+0x53/0x60 [iptable_filter] Mar 29 12:06:11 desktop
kernel: [  917.414435]  [<ffffffff80546a07>] nf_iterate+0x67/0xa0 Mar
29 12:06:11 desktop kernel: [  917.414441]  [<ffffffff80551140>] ?
dst_output+0x0/0x10 Mar 29 12:06:11 desktop kernel: [  917.414446]
[<ffffffff80546af5>] nf_hook_slow+0xb5/0x100 Mar 29 12:06:11 desktop
kernel: [  917.414452]  [<ffffffff80551140>] ? dst_output+0x0/0x10 Mar
29 12:06:11 desktop kernel: [  917.414458]  [<ffffffff80552f7f>]
__ip_local_out+0x9f/0xb0 Mar 29 12:06:11 desktop kernel:
[  917.414464]  [<ffffffff8058c4db>] ? bictcp_cong_avoid+0x4b/0x2d0 Mar
29 12:06:11 desktop kernel: [  917.414469]  [<ffffffff80552fa1>]
ip_local_out+0x11/0x30 Mar 29 12:06:11 desktop kernel: [  917.414474]
[<ffffffff8055389c>] ip_queue_xmit+0x21c/0x410 Mar 29 12:06:11 desktop
kernel: [  917.414480]  [<ffffffff80272825>] ?
print_lock_contention_bug+0x25/0x120 Mar 29 12:06:11 desktop kernel:
[  917.414486]  [<ffffffff8056810e>] ?
tcp_established_options+0x3e/0xe0 Mar 29 12:06:11 desktop kernel:
[  917.414492]  [<ffffffff80272825>] ?
print_lock_contention_bug+0x25/0x120 Mar 29 12:06:11 desktop kernel:
[  917.414498]  [<ffffffff80568ef5>] tcp_transmit_skb+0x535/0x820 Mar
29 12:06:11 desktop kernel: [  917.414504]  [<ffffffff8056b5fb>]
tcp_write_xmit+0x20b/0xaa0 Mar 29 12:06:11 desktop kernel:
[  917.414510]  [<ffffffff8055d451>] ? sk_stream_alloc_skb+0x41/0x110
Mar 29 12:06:11 desktop kernel: [  917.414515]  [<ffffffff8052799e>] ?
__alloc_skb+0x6e/0x150 Mar 29 12:06:11 desktop kernel: [  917.414521]
[<ffffffff8056befb>] __tcp_push_pending_frames+0x2b/0x90 Mar 29
12:06:11 desktop kernel: [  917.414527]  [<ffffffff8055ddc3>]
tcp_sendmsg+0x8a3/0xbb0 Mar 29 12:06:11 desktop kernel: [  917.414533]
[<ffffffff8051d2bb>] sock_aio_write+0x12b/0x140 Mar 29 12:06:11 desktop
kernel: [  917.414539]  [<ffffffff802df6f1>] do_sync_write+0xf1/0x140
Mar 29 12:06:11 desktop kernel: [  917.414545]  [<ffffffff8025e470>] ?
autoremove_wake_function+0x0/0x40 Mar 29 12:06:11 desktop kernel:
[  917.414551]  [<ffffffff802e0259>] vfs_write+0x179/0x190 Mar 29
12:06:11 desktop kernel: [  917.414557]  [<ffffffff802e0360>]
sys_write+0x50/0x90 Mar 29 12:06:11 desktop kernel: [  917.414563]
[<ffffffff8020b51b>] system_call_fastpath+0x16/0x1b

Result of the bisection:

784544739a25c30637397ace5489eeb6e15d7d49 is first bad commit
commit 784544739a25c30637397ace5489eeb6e15d7d49             
Author: Stephen Hemminger <shemminger@vyatta.com>           
Date:   Fri Feb 20 10:35:32 2009 +0100                      

    netfilter: iptables: lock free counters
                                           
    The reader/writer lock in ip_tables is acquired in the critical
    path of processing packets and is one of the reasons just loading
    iptables can cause a 20% performance loss. The rwlock serves two
    functions:

    1) it prevents changes to table state (xt_replace) while table is
    in use. This is now handled by doing rcu on the xt_table. When
    table is replaced, the new table(s) are put in and the old one
    table(s) are freed after RCU period.

    2) it provides synchronization when accesing the counter values.
       This is now handled by swapping in new table_info entries for
    each cpu then summing the old values, and putting the result back
    onto one cpu.  On a busy system it may cause sampling to occur at
    different times on each cpu, but no packet/byte counts are lost in
    the process.

    Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>

    Sucessfully tested on my dual quad core machine too, but iptables
    only (no ipv6 here) BTW, my new "tbench 8" result is 2450 MB/s, (it
    was 2150 MB/s not so long ago)

    Acked-by: Eric Dumazet <dada1@cosmosbay.com>
    Signed-off-by: Patrick McHardy <kaber@trash.net>

:040000 040000 67ef5761d009330e8d538dd1a3aff77c86995172
0d8d6398ced2117bb6995b0c414fd8013685324e M      include :040000 040000
0317c745a0722ade9a6c0cbe9d6cb92abbd40efa
0eb195a365164c05e7c764ab1c2a7da891276837 M      net

After reverting commit no more these messages.

This issue in bugzilla: http://bugzilla.kernel.org/show_bug.cgi?id=12960
--MP_/JLdNf_00lrT=kinwm=Hmuy6
Content-Type: application/x-gzip
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename=config.gz

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

--MP_/JLdNf_00lrT=kinwm=Hmuy6--
