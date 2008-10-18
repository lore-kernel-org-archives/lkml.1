Return-Path: <linux-kernel-owner+w=401wt.eu-S1755941AbYJRA6b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755941AbYJRA6b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 20:58:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754052AbYJRA6V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 20:58:21 -0400
Received: from casper.infradead.org ([85.118.1.10]:56989 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753224AbYJRA6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 20:58:21 -0400
Subject: Re: 2.6.26.6-rt11 boot failure on PREEMPT_DESKTOP
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org
In-Reply-To: <48F932B1.6020405@ct.jp.nec.com>
References: <48F932B1.6020405@ct.jp.nec.com>
Content-Type: text/plain
Date: Sat, 18 Oct 2008 02:58:02 +0200
Message-Id: <1224291482.10548.29.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-10-17 at 17:49 -0700, Hiroshi Shimamoto wrote:
> Hi,
> 
> I got an issue, 2.6.26.6-rt11 PREEMPT_DESKTOP doesn't boot on my box.
> Attached my .config.
> 
> The boot stopped the following point.
> [    1.285988] Real Time Clock Driver v1.12ac
> [    1.290816] intel_rng: FWH not detected
> [    1.295992] Linux agpgart interface v0.103
> [    1.300385] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
> [    1.308734] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
> [    1.316818] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
> [    1.325397] 00:0a: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
> [    1.329632] 00:0b: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
> [    1.336132] Floppy drive(s): fd0 is 1.44M
> [    4.356923] floppy0: no floppy controllers found
> 
> I've bisected, the patch
> sched-properly-account-irq-and-rt-load.patch
> causes this issue.
> 
> I was looking for what's wrong, but couldn't find the root cause.
> But tried to change load.weight to 1 instead of 0 for RT process,
> the kernel booted fine.
> This zero load weight causes rq load weight zero, I guess it might
> make some badness. But I'm not sure about this.
> I don't think this is correct fix.

you're right, its not. but that patch is very likely busted anyway.
totally forgot -rt was carrying it.

