Return-Path: <linux-kernel-owner+w=401wt.eu-S1760061AbXGOWwN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760061AbXGOWwN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 18:52:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755607AbXGOWv6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 18:51:58 -0400
Received: from no-way.org ([212.55.212.131]:43274 "EHLO no-way.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755545AbXGOWv5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 18:51:57 -0400
Date: Mon, 16 Jul 2007 00:51:55 +0200
From: Flavio Curti <lists.fcu@no-way.org>
To: linux-kernel@vger.kernel.org
Subject: Re: panics with 16port Promise Supertrack EX Controller
Message-ID: <20070715225155.GD21260@no-way.org>
References: <20070708225246.GD16285@no-way.org> <6bffcb0e0707081620pf4afd46re9e74e18518b352a@mail.gmail.com> <46919688.1050005@yahoo.com.au>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="hQiwHBbRI9kgIhsi"
Content-Disposition: inline
In-Reply-To: <46919688.1050005@yahoo.com.au>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--hQiwHBbRI9kgIhsi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello

On Mon, Jul 09, 2007 at 11:59:36AM +1000, Nick Piggin wrote:
> >Jul  8 00:19:13 dorade.cyberlink.ch EFLAGS: 00210046   
> >(2.6.22-rc7-dorade #1)
> >>The machine panics
> >>after some days of running fine, the machine inst heavy loaded.
> >>The Controller detects as stex device:
> >kernel BUG at block/as-iosched.c:1084!
> >
> >BUG_ON(RB_EMPTY_ROOT(&ad->sort_list[REQ_ASYNC]));
> Could be a bug in the driver that just happens to be caught by AS checks.
> If you could test another scheduler (boot with elevator=deadline or 
> elevator=cfq),
> it might help give us an idea.

Ok, I now switched to cfg, and the machine panicd again. Panic attached.
Any help is appreciated.

Flavio Curti
--
http://no-way.org/~fcu/

--hQiwHBbRI9kgIhsi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=dorade-kdump

blk_queue_end_tag: attempt to clear non-busy tag (1) 
------------[ cut here ]------------ 
kernel BUG at block/ll_rw_blk.c:2758! 
invalid opcode: 0000 [#1] 
SMP 
 
Modules linked in:
 i2c_i801
 i2c_core
 
CPU:    0 
EIP:    0060:[<c02a3164>]    Not tainted VLI 
EFLAGS: 00010002   (2.6.22.1-dorade #1) 
EIP is at __blk_put_request+0x74/0x80 
eax: 00000000   ebx: dae3e578   ecx: c02ac600   edx: 00000000 
esi: 00030784   edi: f7f28b24   ebp: f7f28b24   esp: c0621e50 
ds: 007b   es: 007b   fs: 00d8  gs: 0000  ss: 0068 
Process swapper (pid: 0, ti=c0620000 task=c05d8340 task.ti=c0620000)
 
Stack: 
dae3e578 
e2b5aac0 
00000001 
scsi_end_request+0x94/0xe0 
 [<c03743c6>] 
scsi_io_completion+0x86/0x3e0 
 [<c012b08a>] 
del_timer+0x5a/0x70 
 [<c038fc7b>] 
sd_rw_intr+0x2b/0x200 
 [<c038bf8e>] 
stex_mu_intr+0x12e/0x540 
 [<c036fe85>] 
scsi_finish_command+0x45/0x60 
 [<c02a4c88>] 
blk_done_softirq+0x58/0x70 
 [<c0126e92>] 
__do_softirq+0x82/0x100 
 [<c0126f47>] 
do_softirq+0x37/0x40 
 [<c0127185>] 
irq_exit+0x75/0x80 
 [<c0106410>] 
do_IRQ+0x40/0x80 
 [<c0139796>] 
getnstimeofday+0x36/0xd0 
 [<c0104503>] 
common_interrupt+0x23/0x28 
 [<c0101d26>] 
mwait_idle_with_hints+0x46/0x60 
 [<c0101e85>] 
cpu_idle+0x65/0x90 
 [<c0628d1f>] 
start_kernel+0x2ef/0x370 
 [<c06284e0>] 
unknown_bootoption+0x0/0x250 
 ======================= 
Code: 
8b 
57 
24 
89 
d8 
83 
e6 
01 
e8 
ca 
1b 
eb 
ff 
89 
f2 
89 
f8 
89 
e9 
5b 
5e 
5f 
5d 
e9 
3b 
ff 
last message repeated 2 times
89 
da 
89 

--hQiwHBbRI9kgIhsi--
