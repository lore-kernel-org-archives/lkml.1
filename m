Return-Path: <linux-kernel-owner+w=401wt.eu-S1755578AbYGXNY0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755578AbYGXNY0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 09:24:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755322AbYGXNYM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 09:24:12 -0400
Received: from rv-out-0506.google.com ([209.85.198.236]:59400 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752885AbYGXNYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 09:24:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=MW9XklThny2KZXm8lMAiB3iOl+MpGfMAXM0eLrk4CpVBy5js9Ugy0mld96J2zdOYiy
         l8cpEbtwrGGI95boFIpQsbA1HFuOvcnple22CWjxkhC6fURM85xqBEm5RxP+U1qs0yxW
         ehUd4hfMKWlzfkXogn2asfBsrOf02TnukFMD0=
Message-ID: <38b2ab8a0807240624v7ec90c50n8105f830d10dddd@mail.gmail.com>
Date: Thu, 24 Jul 2008 15:24:07 +0200
From: "Francis Moreau" <francis.moro@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: KGDB fails to pass selft tests on x86-64 (v2.6.26)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id m6ODOjfq021769

Hello.
I wanted to give kgdb a try on a v2.6.26 kernel. My cpu is anx86-64.
So the first thing I did is to enable kgdb support and also thekgdb self tests:
CONFIG_HAVE_ARCH_KGDB=yCONFIG_KGDB=yCONFIG_KGDB_SERIAL_CONSOLE=yCONFIG_KGDB_TESTS=y# CONFIG_KGDB_TESTS_ON_BOOT is not set
Once compiled I booted this kernel through qemu and got the following:
...kgdb: Registered I/O driver kgdbts.kgdb: Waiting for connection from remote gdb...kgdbts:RUN plant and detach testkgdbts:RUN sw breakpoint testkgdbts:RUN bad memory access testkgdbts:RUN singlestep test 1000 iterationskgdbts:RUN singlestep [0/1000]kgdbts:RUN singlestep [100/1000]kgdbts:RUN singlestep [200/1000]kgdbts:RUN singlestep [300/1000]kgdbts:RUN singlestep [400/1000]kgdbts:RUN singlestep [500/1000]kgdbts:RUN singlestep [600/1000]kgdbts:RUN singlestep [700/1000]kgdbts:RUN singlestep [800/1000]kgdbts:RUN singlestep [900/1000]kgdbts:RUN hw breakpoint testkgdbts: BP mismatch ffffffff810677e3 expected ffffffff811b4e1f------------[ cut here ]------------WARNING: at drivers/misc/kgdbts.c:302 check_and_rewind_pc+0xbf/0xde()Modules linked in:Pid: 1, comm: swapper Tainted: G        W 2.6.26 #9
Call Trace: <#DB>  [<ffffffff8102f607>] warn_on_slowpath+0x58/0x94 [<ffffffff810677e3>] ? kgdb_breakpoint+0x12/0x21 [<ffffffff811b4e1f>] ? kgdbts_break_test+0x0/0x22 [<ffffffff811b4ce8>] ? fill_get_buf+0xc9/0xd1 [<ffffffff811b4e1f>] ? kgdbts_break_test+0x0/0x22 [<ffffffff81073608>] ? probe_kernel_write+0x38/0x68 [<ffffffff810677e3>] ? kgdb_breakpoint+0x12/0x21 [<ffffffff811b4e1f>] ? kgdbts_break_test+0x0/0x22 [<ffffffff811b554e>] check_and_rewind_pc+0xbf/0xde [<ffffffff811b4a69>] validate_simple_test+0x25/0x75 [<ffffffff811b50df>] run_simple_test+0x1e1/0x255 [<ffffffff811b4aee>] kgdbts_put_char+0x18/0x1a [<ffffffff81067616>] put_packet+0x79/0xd9 [<ffffffff81068c39>] kgdb_handle_exception+0xdd3/0xf02 [<ffffffff81018e48>] ? touch_nmi_watchdog+0x5e/0x62 [<ffffffff811b4e1f>] ? kgdbts_break_test+0x0/0x22 [<ffffffff8101c34a>] kgdb_notify+0x14c/0x166 [<ffffffff812aa477>] notifier_call_chain+0x33/0x5b [<ffffffff812aa4c1>] atomic_notifier_call_chain+0x13/0x15 [<ffffffff81045900>] notify_die+0x2e/0x30 [<ffffffff812a8aa5>] do_int3+0x32/0x8f [<ffffffff812a82a3>] int3+0x93/0xb0 [<ffffffff810677e3>] ? kgdb_breakpoint+0x12/0x21 <<EOE>>  [<ffffffff811b5267>] ? run_breakpoint_test+0x5b/0x9c [<ffffffff811b5a20>] ? configure_kgdbts+0x254/0x45d [<ffffffff81138399>] ? blk_register_region+0x2a/0x2c [<ffffffff8147ffb6>] ? init_kgdbts+0x0/0x16 [<ffffffff8147ffca>] ? init_kgdbts+0x14/0x16 [<ffffffff814606d3>] ? kernel_init+0x15f/0x2b3 [<ffffffff8100ccf8>] ? child_rip+0xa/0x12 [<ffffffff81460574>] ? kernel_init+0x0/0x2b3 [<ffffffff8100ccee>] ? child_rip+0x0/0x12
---[ end trace 4eaa2a86a8e2da22 ]---kgdbts: ERROR PUT: end of test buffer on 'hw_breakpoint_test' line 3expected kgdbts_break_test got$d8fa4a81ffffffff0090b57f0081ffff000000000000000001000000000000001000000000000000286a5481ffffffff201e8a0f0081ffff201e8a0f0081ffffc01c8a0f0081ffffÔøΩÔøΩJÔøΩÔøΩÔøΩÔøΩÔøΩ------------[ cut here ]------------WARNING: at drivers/misc/kgdbts.c:721 run_simple_test+0x22b/0x255()Modules linked in:Pid: 1, comm: swapper Tainted: G        W 2.6.26 #9
Call Trace: <#DB>  [<ffffffff8102f607>] warn_on_slowpath+0x58/0x94 [<ffffffff811b4ce8>] ? fill_get_buf+0xc9/0xd1 [<ffffffff81073608>] ? probe_kernel_write+0x38/0x68 [<ffffffff810677e3>] ? kgdb_breakpoint+0x12/0x21 [<ffffffff811b4e1f>] ? kgdbts_break_test+0x0/0x22 [<ffffffff811b554e>] ? check_and_rewind_pc+0xbf/0xde [<ffffffff811b5129>] run_simple_test+0x22b/0x255 [<ffffffff811b4aee>] kgdbts_put_char+0x18/0x1a [<ffffffff81067616>] put_packet+0x79/0xd9 [<ffffffff81068c39>] kgdb_handle_exception+0xdd3/0xf02 [<ffffffff81018e48>] ? touch_nmi_watchdog+0x5e/0x62 [<ffffffff811b4e1f>] ? kgdbts_break_test+0x0/0x22 [<ffffffff8101c34a>] kgdb_notify+0x14c/0x166 [<ffffffff812aa477>] notifier_call_chain+0x33/0x5b [<ffffffff812aa4c1>] atomic_notifier_call_chain+0x13/0x15 [<ffffffff81045900>] notify_die+0x2e/0x30 [<ffffffff812a8aa5>] do_int3+0x32/0x8f [<ffffffff812a82a3>] int3+0x93/0xb0 [<ffffffff810677e3>] ? kgdb_breakpoint+0x12/0x21 <<EOE>>  [<ffffffff811b5267>] ? run_breakpoint_test+0x5b/0x9c [<ffffffff811b5a20>] ? configure_kgdbts+0x254/0x45d [<ffffffff81138399>] ? blk_register_region+0x2a/0x2c [<ffffffff8147ffb6>] ? init_kgdbts+0x0/0x16 [<ffffffff8147ffca>] ? init_kgdbts+0x14/0x16 [<ffffffff814606d3>] ? kernel_init+0x15f/0x2b3 [<ffffffff8100ccf8>] ? child_rip+0xa/0x12 [<ffffffff81460574>] ? kernel_init+0x0/0x2b3 [<ffffffff8100ccee>] ? child_rip+0x0/0x12
---[ end trace 4eaa2a86a8e2da22 ]---kgdbts: ERROR hw_breakpoint_test test failed------------[ cut here ]------------WARNING: at drivers/misc/kgdbts.c:783 run_breakpoint_test+0x8a/0x9c()Modules linked in:Pid: 1, comm: swapper Tainted: G        W 2.6.26 #9
Call Trace: [<ffffffff8102f607>] warn_on_slowpath+0x58/0x94 [<ffffffff810677e3>] ? kgdb_breakpoint+0x12/0x21 [<ffffffff811b5296>] run_breakpoint_test+0x8a/0x9c [<ffffffff811b5a20>] configure_kgdbts+0x254/0x45d [<ffffffff81138399>] ? blk_register_region+0x2a/0x2c [<ffffffff8147ffb6>] ? init_kgdbts+0x0/0x16 [<ffffffff8147ffca>] init_kgdbts+0x14/0x16 [<ffffffff814606d3>] kernel_init+0x15f/0x2b3 [<ffffffff8100ccf8>] child_rip+0xa/0x12 [<ffffffff81460574>] ? kernel_init+0x0/0x2b3 [<ffffffff8100ccee>] ? child_rip+0x0/0x12
---[ end trace 4eaa2a86a8e2da22 ]---kgdbts:RUN hw write breakpoint testkgdbts: ERROR hw_write_break_test test failed------------[ cut here ]------------WARNING: at drivers/misc/kgdbts.c:815 run_hw_break_test+0xd4/0xe3()Modules linked in:Pid: 1, comm: swapper Tainted: G        W 2.6.26 #9
Call Trace: [<ffffffff8102f607>] warn_on_slowpath+0x58/0x94 [<ffffffff810677e3>] ? kgdb_breakpoint+0x12/0x21 [<ffffffff811b537c>] run_hw_break_test+0xd4/0xe3 [<ffffffff811b5a41>] configure_kgdbts+0x275/0x45d [<ffffffff81138399>] ? blk_register_region+0x2a/0x2c [<ffffffff8147ffb6>] ? init_kgdbts+0x0/0x16 [<ffffffff8147ffca>] init_kgdbts+0x14/0x16 [<ffffffff814606d3>] kernel_init+0x15f/0x2b3 [<ffffffff8100ccf8>] child_rip+0xa/0x12 [<ffffffff81460574>] ? kernel_init+0x0/0x2b3 [<ffffffff8100ccee>] ? child_rip+0x0/0x12
---[ end trace 4eaa2a86a8e2da22 ]---kgdbts:RUN access write breakpoint testkgdbts: ERROR hw_access_break_test test failed------------[ cut here ]------------WARNING: at drivers/misc/kgdbts.c:815 run_hw_break_test+0xd4/0xe3()Modules linked in:Pid: 1, comm: swapper Tainted: G        W 2.6.26 #9
Call Trace: [<ffffffff8102f607>] warn_on_slowpath+0x58/0x94 [<ffffffff811b537c>] run_hw_break_test+0xd4/0xe3 [<ffffffff811b5a5f>] configure_kgdbts+0x293/0x45d [<ffffffff81138399>] ? blk_register_region+0x2a/0x2c [<ffffffff8147ffb6>] ? init_kgdbts+0x0/0x16 [<ffffffff8147ffca>] init_kgdbts+0x14/0x16 [<ffffffff814606d3>] kernel_init+0x15f/0x2b3 [<ffffffff8100ccf8>] child_rip+0xa/0x12 [<ffffffff81460574>] ? kernel_init+0x0/0x2b3 [<ffffffff8100ccee>] ? child_rip+0x0/0x12
---[ end trace 4eaa2a86a8e2da22 ]---kgdb: Unregistered I/O driver kgdbts, debugger disabled.
I assumed that the tests failed, so I thought that the best thing todo was to postthis on LKML.
So the question is "what's wrong ?"
Thanks-- FrancisˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
