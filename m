Return-Path: <linux-kernel-owner+w=401wt.eu-S1755767AbYH0Vpc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755767AbYH0Vpc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 17:45:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753164AbYH0VpV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 17:45:21 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:10375 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752635AbYH0VpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 17:45:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=T/h+xt8TBVWElc1c2EPmr+Zs96C1mye83Dk4Lfs6X6Hsfhl4PUMBzf+20q3swNqsAG
         wGzi0Mxss/+FqtE/BAENK19Whc/Mg/lcdwRnGy41GnPRLXiTvfAjJ1N6owXUEC/1fhq7
         mjxk4dMaxePJh05m8AvspqEnvrvf/eVW+MYVU=
Date: Thu, 28 Aug 2008 01:46:52 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Roland McGrath <roland@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] utrace core
Message-ID: <20080827214652.GA32163@x200.localdomain>
References: <20080826220102.89635154233@magilla.localdomain> <20080826220157.397C7154233@magilla.localdomain> <20080826225519.GC27724@x200.localdomain> <20080827213211.GA31861@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080827213211.GA31861@x200.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 28, 2008 at 01:32:11AM +0400, Alexey Dobriyan wrote:
> > And run to confirm that attach/detach/exec program still crashes it.
> > There is PREEMPT_RCU now so it will be even more not funny.
> 
> As promised, quickly reproducible via expt_ptratt.c:

Another one:

kernel BUG at kernel/utrace.c:2275!
invalid opcode: 0000 [1] PREEMPT SMP DEBUG_PAGEALLOC
last sysfs file: /sys/kernel/slab/utrace_attached_engine/objects
CPU 0 
Modules linked in: xt_state iptable_filter ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack ip_tables xt_tcpudp ip6table_filter ip6_tables x_tables ipv6 sr_mod cdrom
Pid: 5118, comm: exe Tainted: G        W 2.6.27-rc4-next-20080827-utrace #5
RIP: 0010:[<ffffffff802608ef>]  [<ffffffff802608ef>] utrace_get_signal+0x6ff/0x710
RSP: 0018:ffff88017ace5c98  EFLAGS: 00010093
RAX: 0000000000000000 RBX: ffff88017aced910 RCX: ffff88017e2b23c0
RDX: ffffffffffffffff RSI: ffff88017ace5cf8 RDI: ffff88017acc5640
RBP: ffff88017ace5d38 R08: 0000000000000002 R09: 0000000000000001
R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000000
R13: ffff88017aced908 R14: ffff88017aced900 R15: ffff88017acc5640
FS:  0000000000000000(0000) GS:ffffffff80551600(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007fff249c8bc9 CR3: 000000017ad2c000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process exe (pid: 5118, threadinfo ffff88017ace4000, task ffff88017acc5640)
Stack:  ffff88017ace5ef8 0000000000000002 0000000000000000 ffff88017ace5ef8
 ffff88017ace5e78 ffff88017ace5f58 ffff88017e206288 0000000000000400
 0000000000000401 ffff88017e206848 0000001000000000 0000000000010000
Call Trace:
 [<ffffffff802412fc>] get_signal_to_deliver+0x24c/0x310
 [<ffffffff8020ab54>] do_notify_resume+0xd4/0x860
 [<ffffffff8028ff08>] ? check_bytes_and_report+0x38/0xd0
 [<ffffffff80209b7b>] ? sys_execve+0x5b/0x80
 [<ffffffff802901c3>] ? check_object+0x223/0x250
 [<ffffffff80290811>] ? init_object+0x51/0x90
 [<ffffffff80256f5d>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffff80209b7b>] ? sys_execve+0x5b/0x80
 [<ffffffff8020b9c7>] int_signal+0x12/0x17
Code: 00 00 48 89 41 10 48 8b 82 20 01 00 00 48 89 41 18 e9 5e fa ff ff 0f 0b eb fe 48 8b 75 80 4c 89 ff e8 e6 e5 ff ff e9 28 fd ff ff <0f> 0b eb fe 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 
RIP  [<ffffffff802608ef>] utrace_get_signal+0x6ff/0x710
 RSP <ffff88017ace5c98>
---[ end trace 4eaa2a86a8e2da22 ]---

