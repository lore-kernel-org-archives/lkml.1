Return-Path: <linux-kernel-owner+w=401wt.eu-S1755351AbZF2IQe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351AbZF2IQe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 04:16:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751763AbZF2IQT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 04:16:19 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47526 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751019AbZF2IQS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 04:16:18 -0400
Date: Mon, 29 Jun 2009 10:16:15 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Luming Yu <luming.yu@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, suresh.b.siddha@intel.com,
       venkatesh.pallipadi@intel.com, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [RFC patch] Use IPI_shortcut for lapic timer broadcast
Message-ID: <20090629081615.GB571@elte.hu>
References: <3877989d0906282347i311eb14bp80a7c80878219c31@mail.gmail.com> <20090629072047.GB20225@elte.hu> <3877989d0906290104q11a767b6qcc1acc4c2d1feba6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3877989d0906290104q11a767b6qcc1acc4c2d1feba6@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Luming Yu <luming.yu@gmail.com> wrote:

> On Mon, Jun 29, 2009 at 3:20 PM, Ingo Molnar<mingo@elte.hu> wrote:
> >
> > * Luming Yu <luming.yu@gmail.com> wrote:
> >
> >> Hello,
> >>
> >> We need to use IPI shortcut to send lapic timer broadcast
> >> to avoid the latency of sending IPI one bye one on systems with many
> >> logical processors when NO_HZ is disabled.
> >> Without this patch,I have seen upstream kernel with RHEL 5 kernel
> >> config boot hang .
> >
> > hm, that might be a valid optimization - but why does the lack of
> > this optimization result in a hang?
> 
> It is hang caused by kernel code for work around lapic-timer-stop 
> issue. With HZ=1000, and a lot of cpus (eg. 64 logical cpus), cpu 
> 0 will be busy working on send TIMER IPI instead of making 
> progress in boot (right after deep-C-state has been used).

that's a bit weird. With HZ=1000 we have 1000 usecs between each 
timer tick. Assuming a CPU sends to a lot of CPUs (64 logical CPUs) 
that means that each IPI takes more than ~15 microseconds to 
process. On what hardware/platform can this happen realistically?

	Ingo
