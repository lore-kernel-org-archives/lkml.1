Return-Path: <linux-kernel-owner+w=401wt.eu-S1752786AbZCUSta@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752786AbZCUSta (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 14:49:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752167AbZCUStU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 14:49:20 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33640 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752144AbZCUStU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 14:49:20 -0400
Date: Sat, 21 Mar 2009 19:49:04 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Announce] 2.6.29-rc8-rt2
Message-ID: <20090321184904.GA19352@elte.hu>
References: <1235437021.4462.25.camel@localhost.localdomain> <alpine.LFD.2.00.0902241120320.3523@localhost.localdomain> <alpine.LFD.2.00.0902241729590.3523@localhost.localdomain> <1235513895.3816.11.camel@localhost.localdomain> <1235595160.9252.49.camel@localhost.localdomain> <1235619922.31774.17.camel@localhost.localdomain> <1236984825.10748.17.camel@localhost.localdomain> <alpine.LFD.2.00.0903140845430.29264@localhost.localdomain> <1237661053.3196.10.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1237661053.3196.10.camel@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU> wrote:

> Mar 21 10:47:43 localhost kernel: kernel tried to execute NX-protected
> page - exploit attempt? (uid: 0)
> Mar 21 10:47:43 localhost kernel: BUG: unable to handle kernel paging
> request at f6400800

kernel tried to execute some really weird address, probably via a 
function pointer.

> ehci_hcd [last unloaded: microcode]

perhaps try excluding the microcode module for now - maybe it messed 
up something?

> Mar 21 10:47:43 localhost kernel: EIP: 0060:[<f6400800>] EFLAGS:

> Mar 21 10:47:43 localhost kernel: Call Trace:
> Mar 21 10:47:43 localhost kernel: [<f82adb93>] ? iwl3945_irq_tasklet
> Mar 21 10:47:43 localhost kernel: [<c043d0e2>] ? __tasklet_action
> Mar 21 10:47:43 localhost kernel: [<c043d1c5>] ? tasklet_action
> Mar 21 10:47:43 localhost kernel: [<c043ceb7>] ? ksoftirqd+0x131/0x221
> Mar 21 10:47:43 localhost kernel: [<c043cd86>] ? ksoftirqd+0x0/0x221
> Mar 21 10:47:43 localhost kernel: [<c0449949>] ? kthread+0x3b/0x61
> Mar 21 10:47:43 localhost kernel: [<c044990e>] ? kthread+0x0/0x61
> Mar 21 10:47:43 localhost kernel: [<c0409207>] ? kernel_thread_helper

does any of the Fedora patches you have applied involve wireless 
changes? I'd suggest undoing those first.

	Ingo
