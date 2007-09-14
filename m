Return-Path: <linux-kernel-owner+w=401wt.eu-S1756640AbXINKhr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756640AbXINKhr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 06:37:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752385AbXINKhj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 06:37:39 -0400
Received: from nz-out-0506.google.com ([64.233.162.230]:63707 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754864AbXINKhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 06:37:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=tOuPcmHUZYkrYak9Jhl/MdFPcoEVmHppmdehQ+cINPfwt5aaLYvN6Spv97OowzDExs1GfJoAPeZZlU3gtHBGAJSXZFUWrOSOHxGbAfLkfkpaQBZ12lWwxunHXpFyDgp5rcf+eN8aNLVUbWeIpq6CsDAA63KqeXenaabyPUj7rzM=
Message-ID: <a781481a0709140337u2c26f770h2af6d457bc39f280@mail.gmail.com>
Date: Fri, 14 Sep 2007 16:07:37 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Kamalesh Babulal" <kamalesh@linux.vnet.ibm.com>
Subject: Re: [BUG][2.6.23-rc6] Badness at arch/powerpc/kernel/smp.c:202
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org, paulus@samba.org,
       "Balbir Singh" <balbir@linux.vnet.ibm.com>
In-Reply-To: <46EA5CEB.7020104@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46EA5CEB.7020104@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kamalesh,

There's two things at work here ...


On 9/14/07, Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:
> Hi,
>
> With 2.6.23-rc6 running on the ppc64 box, following oops is hit
>
> Oops: Machine check, sig: 7 [#1]
>
> SMP NR_CPUS=128 pSeries
>
> Modules linked in: binfmt_misc ipv6 dm_mod ehci_hcd ohci_hcd usbcore
>
> NIP: c0000000000ed560 LR: c0000000000efc7c CTR: c0000000000ed504
>
> REGS: c00000000ffef680 TRAP: 0200   Not tainted  (2.6.23-rc6-autokern1)
>
> MSR: 8000000000109032 <EE,ME,IR,DR>  CR: 28002042  XER: 00000010
>
> TASK = c0000000ecf9f000[0] 'swapper' THREAD: c00000000ff8c000 CPU: 2
>
> GPR00: 0000000000000000 c00000000ffef900 c0000000006fe598 c0000000d7a8f200
>
> GPR04: 0000000000001000 0000000000000000 0000000000001000 8000000000c26393
>
> GPR08: c0000000006b43d0 0000000000000001 0000000000001000 0000000000000000
>
> GPR12: 0000000048000048 c0000000005f1700 0000000000000000 0000000007a8dcd0
>
> GPR16: 0000000000000002 0000000000000000 0000000000000000 0000000000000000
>
> GPR20: 0000000000000000 0000000000001000 0000000000001000 0000000000000000
>
> GPR24: 0000000000000000 0000000000000000 0000000000001000 c0000000063234e8
>
> GPR28: 0000000000001000 0000000000000000 c000000000689c08 c00000000ff3a480
>
> NIP [c0000000000ed560] .end_bio_bh_io_sync+0x5c/0xac
>
> LR [c0000000000efc7c] .bio_endio+0xb4/0xd4
>
> Call Trace:
>
> [c00000000ffef900] [c00000000ffef990] 0xc00000000ffef990 (unreliable)
>
> [c00000000ffef980] [c0000000000efc7c] .bio_endio+0xb4/0xd4
>
> [c00000000ffefa10] [c000000000290060] .__end_that_request_first+0x154/0x548
>
> [c00000000ffefae0] [c00000000035af10] .scsi_end_request+0x40/0x138
>
> [c00000000ffefb80] [c00000000035b234] .scsi_io_completion+0x188/0x454
>
> [c00000000ffefc60] [c000000000372a24] .sd_rw_intr+0x2e4/0x338
>
> [c00000000ffefd30] [c000000000354548] .scsi_finish_command+0xbc/0xe0
>
> [c00000000ffefdc0] [c00000000035bdf0] .scsi_softirq_done+0x140/0x188
>
> [c00000000ffefe60] [c000000000293184] .blk_done_softirq+0xa0/0xd0
>
> [c00000000ffefef0] [c000000000055e1c] .__do_softirq+0xa8/0x164
>
> [c00000000ffeff90] [c000000000023f14] .call_do_softirq+0x14/0x24
>
> [c00000000ff8f960] [c00000000000bd30] .do_softirq+0x68/0xac
>
> [c00000000ff8f9f0] [c000000000055f70] .irq_exit+0x54/0x6c
>
> [c00000000ff8fa70] [c00000000000c358] .do_IRQ+0x170/0x1ac
>
> [c00000000ff8fb00] [c000000000004780] hardware_interrupt_entry+0x18/0x98
>
> --- Exception: 501 at .pseries_dedicated_idle_sleep+0xe0/0x194
>
>     LR = .pseries_dedicated_idle_sleep+0xd0/0x194
>
> [c00000000ff8fdf0] [0000000000000000] .__start+0x4000000000000000/0x8 (unreliable)
>
> [c00000000ff8fe80] [c000000000010bd4] .cpu_idle+0x104/0x1d8
>
> [c00000000ff8ff00] [c00000000002672c] .start_secondary+0x160/0x184
>
> [c00000000ff8ff90] [c000000000008364] .start_secondary_prolog+0xc/0x10
>
> Instruction dump:
>
> 409a0030 393f0018 38000080 7d6048a8 7d6b0378 7d6049ad 40a2fff4 38002000
>
> 7d2018a8 7d290378 7d2019ad 40a2fff4 <e9230038> e89f0018 e9690000 f8410028
>
> Kernel panic - not syncing: Fatal exception in interrupt

This oops is the real bug here, but is that a machine check exception?
If so, it could be a hardware failure what you saw there instead, and not
really a kernel bug ...


> ------------[ cut here ]------------
>
> Badness at arch/powerpc/kernel/smp.c:202

This one is not the real issue at all -- it's just a sad problem in the powerpc
panic() -> smp_send_stop() -> smp_call_function() -> smp_call_function_map()
call chain. The thing is, smp_call_function() cannot be allowed from interrupt
disabled contexts, hence the WARN_ON() there. But panic() is a special case,
and so we must *not* complain when called from panic -- doing so will only
scroll away the real call trace / oops log from the screen (thankfully you had
a serial cable there?) and distract from the real bug, like what
happened here ...

The fix is to define an alternative __smp_call_function(), that calls into
smp_call_function_map(), and is itself called from
smp_call_function(), and then:

1. Use the inner __smp_call_function() in smp_send_stop(), and,
2. Move the WARN_ON() to the smp_call_function() wrapper instead.


I'd be back at my desk only by Tuesday, so don't expect a patch before then,
unless Paul fixes this up by himself before that.


Cheers,

Satyam
