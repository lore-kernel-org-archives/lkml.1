Return-Path: <linux-kernel-owner+w=401wt.eu-S1753484AbYIJQxl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753484AbYIJQxl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 12:53:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751876AbYIJQxd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 12:53:33 -0400
Received: from gw.goop.org ([64.81.55.164]:57902 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751838AbYIJQxc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 12:53:32 -0400
Message-ID: <48C7FB83.8080904@goop.org>
Date: Wed, 10 Sep 2008 09:53:23 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Rambaldi <rambaldi@xs4all.nl>
CC: linux-kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.27-rc6 xen soft lockup
References: <48C7BB39.6090700@xs4all.nl>
In-Reply-To: <48C7BB39.6090700@xs4all.nl>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rambaldi wrote:
> Hi,
>
> I got the following bug while running the 2.6.27-rc6 kernel as a 64
> bit domU:
>
>
> BUG: soft lockup - CPU#1 stuck for 4125s! [swapper:0]

Is the domain very idle?  This indicates the vcpu has been idle for over
an hour.

Did anything fail or misbehave?

The soft lockup detector is supposed to deal with very idle cpus, and
with dynticks I guess its possible for a cpu to go for over an hour with
no interrupts (more likely in the virtual case where all the virtual
device interrupts are bound to vcpu 0 and there's nothing much else to
interrupt it).

    J

> Modules linked in: sit ts_bm xt_string ipt_LOG xt_limit iptable_filter
> iptable_nat nf_nat nf_conntrack_ipv4 ip_tables nf_conntrack_ipv6
> xt_state nf_conntrack xt_tcpudp ip6table_filter ip6_tables x_tables
> usbcore nfsd lockd auth_rpcgss sunrpc exportfs reiserfs ipv6
> CPU 1:
> Modules linked in: sit ts_bm xt_string ipt_LOG xt_limit iptable_filter
> iptable_nat nf_nat nf_conntrack_ipv4 ip_tables nf_conntrack_ipv6
> xt_state nf_conntrack xt_tcpudp ip6table_filter ip6_tables x_tables
> usbcore nfsd lockd auth_rpcgss sunrpc exportfs reiserfs ipv6
> Pid: 0, comm: swapper Not tainted 2.6.27-rc6 #2
> RIP: e030:[<ffffffff802093aa>]  [<ffffffff802093aa>] _stext+0x3aa/0x1000
> RSP: e02b:ffff8800f0869f28  EFLAGS: 00000246
> RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffffffff802093aa
> RDX: ffff8800f0868000 RSI: 0000000000000000 RDI: 0000000000000001
> RBP: 0000000000000000 R08: 0000000000000000 R09: ffff880001542478
> R10: ffff8800f0a27e90 R11: 0000000000000246 R12: 0000000000000000
> R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
> FS:  00007fe2c6a8a710(0000) GS:ffff8800f084cec0(0000)
> knlGS:0000000000000000
> CS:  e033 DS: 002b ES: 002b CR0: 000000008005003b
> CR2: 00007fe2c6aab000 CR3: 00000000cc292000 CR4: 0000000000002620
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
>
> Call Trace:
>  [<ffffffff803f9a39>] unix_poll+0x0/0xa4
>  [<ffffffff8020a533>] xen_safe_halt+0xc/0x15
>  [<ffffffff8020b953>] xen_idle+0x33/0x48
>  [<ffffffff8020e883>] cpu_idle+0x45/0x63
>
>

