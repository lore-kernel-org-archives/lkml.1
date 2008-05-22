Return-Path: <linux-kernel-owner+w=401wt.eu-S1754297AbYEVPXA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754297AbYEVPXA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 11:23:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751896AbYEVPWu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 11:22:50 -0400
Received: from gate.crashing.org ([63.228.1.57]:45944 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752135AbYEVPWt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 11:22:49 -0400
Subject: Re: Badness seen on 2.6.26-rc2 with lockdep enabled
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: balbir@linux.vnet.ibm.com
Cc: linuxppc-dev@ozlabs.org,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Paul Mackerras <pmac@au1.ibm.com>
In-Reply-To: <482ADEE0.7090301@linux.vnet.ibm.com>
References: <482ADEE0.7090301@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Thu, 22 May 2008 11:20:41 -0400
Message-Id: <1211469641.8297.278.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-05-14 at 18:15 +0530, Balbir Singh wrote:
> I see the following error on my power box at boot up.

Could be RTAS playing with interrupt enabling without proper
lockdep notifications. I'll have a look when I'm back.

> RTAS: event: 14, Type: Platform Error, Severity: 2
> ------------[ cut here ]------------
> Badness at kernel/lockdep.c:2680
> NIP: c0000000000ae538 LR: c0000000000ae51c CTR: 0000000000000000
> REGS: c0000000e7b139a0 TRAP: 0700   Not tainted  (2.6.26-rc2-mm1)
> MSR: 8000000000029032 <EE,ME,IR,DR>  CR: 24000042  XER: 20000000
> TASK = c0000000e7644620[411] 'rtasd' THREAD: c0000000e7b10000 CPU: 1
> GPR00: 0000000000000000 c0000000e7b13c20 c000000000a55ef0 0000000000000001
> GPR04: 0000000000000001 c00000000004bfb8 2d37313000000000 2d37313031303438
> GPR08: 3644442000000000 c000000000ea3018 0000000000000020 0000000000000001
> GPR12: 3644442000000000 c000000000a94600 0000000000000000 0000000000000000
> GPR16: 0000000000000000 0000000000000000 4000000001c00000 c00000000086f400
> GPR20: 0000000000000000 0000000000000001 00000000000000e4 000000000246f400
> GPR24: c000000000a9c498 0000000000000008 c00000000004bfb8 c00000000087a5d8
> GPR28: c00000000092cd48 0000000000000001 c0000000009bb738 c0000000e7b13c20
> NIP [c0000000000ae538] .check_flags+0x9c/0x174
> LR [c0000000000ae51c] .check_flags+0x80/0x174
> Call Trace:
> [c0000000e7b13c20] [c00000000004bc70] .pSeries_log_error+0x5c/0x400 (unreliable)
> [c0000000e7b13ca0] [c0000000000b35c0] .lock_release+0x80/0x204
> [c0000000e7b13d50] [c0000000005cfcf8] ._spin_unlock_irqrestore+0x34/0x94
> [c0000000e7b13de0] [c00000000004bfb8] .pSeries_log_error+0x3a4/0x400
> [c0000000e7b13ef0] [c00000000004c218] .rtasd+0x98/0x100
> [c0000000e7b13f90] [c00000000002848c] .kernel_thread+0x4c/0x68
> Instruction dump:
> e92d01b0 8009085c 2f800000 40be002c 481f1b9d 60000000 2fa30000 419e00c4
> e93e80f8 80090000 2f800000 409e00b4 <0fe00000> 480000ac 78290464 80090014
> possible reason: unannotated irqs-on.
> irq event stamp: 30
> hardirqs last  enabled at (29): [<c0000000000b1d98>] .trace_hardirqs_on+0x1c/0x3
> 0
> hardirqs last disabled at (30): [<c0000000000aebac>] .trace_hardirqs_off+0x1c/0x
> 30
> softirqs last  enabled at (28): [<c00000000008bd08>] .__do_softirq+0x180/0x1a8
> softirqs last disabled at (21): [<c000000000028124>] .call_do_softirq+0x14/0x24
> 
> 

