Return-Path: <linux-kernel-owner+w=401wt.eu-S933038AbXHEDex@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933038AbXHEDex (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 23:34:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757631AbXHEDep
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 23:34:45 -0400
Received: from jenny.ondioline.org ([66.220.1.122]:39798 "EHLO
	jenny.ondioline.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758340AbXHEDeo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 23:34:44 -0400
X-Greylist: delayed 637 seconds by postgrey-1.27 at vger.kernel.org; Sat, 04 Aug 2007 23:34:44 EDT
From: Paul Collins <paul@briny.ondioline.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: paulus@samba.org, benh@kernel.crashing.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linuxppc-dev@ozlabs.org
Subject: "Badness at kernel/irq/resend.c:70" on boot - via-pmu?
References: <alpine.LFD.0.999.0708032031480.5037@woody.linux-foundation.org>
Date: Sun, 05 Aug 2007 15:22:01 +1200
In-Reply-To: <alpine.LFD.0.999.0708032031480.5037@woody.linux-foundation.org>
	(Linus Torvalds's message of "Fri, 3 Aug 2007 20:50:43 -0700 (PDT)")
Message-ID: <87sl6ypsx2.fsf@briny.wgtn.ondioline.org>
User-Agent: Gnus/5.110007 (No Gnus v0.7) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

I got the message below on boot with 2.6.23-rc2 on my PowerBook.

I've Cc'd some powerpc folks because via_pmu_interrupt is in the
Macintosh PMU driver.

Hmm, I just looked back in my logs and I also got that message with
commit 7a883eaf62f4b943ebec738ce3b0796c67ef5d32.  Before that I used
6c8dca5d53f95009d4fff00195bf38f277dc4366 and there was no badness
message logged by that one.  There's only about 480 commits between
those two, so I can bisect it if necessary.

The call traces differ, so here are both messages.

v2.6.23-rc2:

    ------------[ cut here ]------------
    Badness at kernel/irq/resend.c:70
    NIP: c0054ca4 LR: c0054c78 CTR: c00162b0
    REGS: c0473d80 TRAP: 0700   Not tainted  (2.6.23-rc2-g036acf4f)
    MSR: 00021032 <ME,IR,DR>  CR: 42000024  XER: 00000000
    TASK = c04451e0[0] 'swapper' THREAD: c0472000
    GPR00: 00000001 c0473e30 c04451e0 00000178 0000002f 00600000 c0480000 0000002f 
    GPR08: 000186a0 c0480000 0048002f 00000400 00000000 00000000 00000000 00000000 
    GPR16: 00000000 00000000 00000000 00000000 00000000 40900000 00d3bbc0 00000000 
    GPR24: c0444000 c0480000 c0480000 c043b81c 00000001 0000002f 00024408 c044b1bc 
    NIP [c0054ca4] check_irq_resend+0x5c/0xc0
    LR [c0054c78] check_irq_resend+0x30/0xc0
    Call Trace:
    [c0473e30] [c0054c78] check_irq_resend+0x30/0xc0 (unreliable)
    [c0473e50] [c00547d0] enable_irq+0x84/0xa8
    [c0473e60] [c0220fec] via_pmu_interrupt+0x3d8/0xac0
    [c0473e90] [c0053dfc] handle_IRQ_event+0x4c/0xa0
    [c0473eb0] [c0055250] handle_fasteoi_irq+0xac/0x100
    [c0473ec0] [c0006528] do_IRQ+0x68/0xa8
    [c0473ed0] [c000ffe8] ret_from_except+0x0/0x14
    --- Exception: 501 at cpu_idle+0x88/0xd0
        LR = cpu_idle+0x88/0xd0
    [c0473f90] [c00090bc] cpu_idle+0xcc/0xd0 (unreliable)
    [c0473fa0] [c0351f9c] rest_init+0x58/0x68
    [c0473fb0] [c04189a0] start_kernel+0x260/0x274
    [c0473ff0] [00003860] 0x3860
    Instruction dump:
    4e800421 801f0000 3d20c005 57cb052a 39295030 2f0b0400 7f804800 419e0030 
    3d20c048 800994e4 7c000034 5400d97e <0f000000> 2f800000 41be0048 38000001 


7a883eaf62f4b943ebec738ce3b0796c67ef5d32:

    ------------[ cut here ]------------
    Badness at kernel/irq/resend.c:70
    NIP: c0054bfc LR: c0054bd0 CTR: c00162b0
    REGS: effc3e60 TRAP: 0700   Not tainted  (2.6.23-rc1-g6cc0258f)
    MSR: 00021032 <ME,IR,DR>  CR: 48000084  XER: 20000000
    TASK = effc17f0[1] 'swapper' THREAD: effc2000
    GPR00: 00000001 effc3f10 effc17f0 00000178 0000002f 00000000 c0470000 0000002f 
    GPR08: 000186a0 c0470000 0048002f 00000000 82000022 00000000 00000000 00000000 
    GPR16: 00000000 00000000 00000000 00000000 00000000 40900000 00d3ad48 00000000 
    GPR24: c0443000 c0470000 effc2000 c043ef4c 00000001 0000002f 00024008 c044a1bc 
    NIP [c0054bfc] check_irq_resend+0x5c/0xc0
    LR [c0054bd0] check_irq_resend+0x30/0xc0
    Call Trace:
    [effc3f10] [c0054bd0] check_irq_resend+0x30/0xc0 (unreliable)
    [effc3f30] [c0054728] enable_irq+0x84/0xa8
    [effc3f40] [c0220e74] via_pmu_interrupt+0x3d8/0xac0
    [effc3f70] [c0430f28] via_pmu_start+0x168/0x190
    [effc3f80] [c04171e4] kernel_init+0xc8/0x284
    [effc3ff0] [c0010800] kernel_thread+0x44/0x60
    Instruction dump:
    4e800421 801f0000 3d20c005 57cb052a 39294f88 2f0b0400 7f804800 419e0030 
    3d20c047 800974e4 7c000034 5400d97e <0f000000> 2f800000 41be0048 38000001 


-- 
Paul Collins
Wellington, New Zealand

Dag vijandelijk luchtschip de huismeester is dood
