Return-Path: <linux-kernel-owner+w=401wt.eu-S1756205AbZAYL64@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756205AbZAYL64 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2009 06:58:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752969AbZAYL6r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Jan 2009 06:58:47 -0500
Received: from www.tglx.de ([62.245.132.106]:42089 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752896AbZAYL6q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2009 06:58:46 -0500
Date: Sun, 25 Jan 2009 12:57:47 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Maciej Rutecki <maciej.rutecki@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [Linux 2.6.29-rc2] BUG: using smp_processor_id() in
 preemptible
In-Reply-To: <20090124183746.395f597b.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.2.00.0901251254370.3424@localhost.localdomain>
References: <8db1092f0901170058k325dc6ddtddb42deea1ddd098@mail.gmail.com> <20090124183746.395f597b.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 24 Jan 2009, Andrew Morton wrote:
> 
> Coming out of the hrtimer_hres_active() call, I assume.

Yes.
 
> Is this new behaviour, or were 2.6.28 and earlier doing it?

This code is there since highres was merged, but something seems to
have changed in the suspend/resume code as I'm pretty sure, that this
code was always called with interrupts disabled.
 
> a) remove the wrong "Called with interrupts disabled via
>    on_each_cpu()" comment from retrigger_next_event(), and replace it
>    with something useful and truthful.

Good point.
 
> b) change hres_timers_resume() to do local_irq_save/restore

Right, but I'd like to know what changed below.

Thanks,

	tglx
