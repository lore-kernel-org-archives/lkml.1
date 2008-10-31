Return-Path: <linux-kernel-owner+w=401wt.eu-S1752768AbYJaOA1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752768AbYJaOA1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 10:00:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751200AbYJaOAM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 10:00:12 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:51147 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868AbYJaOAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 10:00:11 -0400
Date: Fri, 31 Oct 2008 10:00:09 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH -v2] ring-buffer: add paranoid checks for loops
In-Reply-To: <20081031093804.GF30317@elte.hu>
Message-ID: <alpine.DEB.1.10.0810310958400.13290@gandalf.stny.rr.com>
References: <alpine.DEB.1.10.0810291439460.13214@gandalf.stny.rr.com> <20081030184552.GC17822@elte.hu> <alpine.DEB.1.10.0810302314460.26352@gandalf.stny.rr.com> <20081031093804.GF30317@elte.hu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 31 Oct 2008, Ingo Molnar wrote:
> 
> > +	/*
> > +	 * This should normally only loop twice. But because the
> > +	 * start of the reader inserts an empty page, it causes
> > +	 * a case where we will loop three times. There should be no
> > +	 * reason to loop four times (that I know of).
> > +	 */
> > +	if (unlikely(paranoid > 2)) {
> > +		RB_WARN_ON(cpu_buffer, 1);
> > +		reader = NULL;
> > +		goto out;
> > +	}
> > +	paranoid++;
> 
> ok, the explanations look nice now.
> 
> A small nit - the above comment suggests that looping 4 times is the 
> anomaly - still the test is for paranoid > 2 ?

Yes, that's because the variable started at 0. So > 2 really means the 
loop iterated more than 3.

My last patch changed it to be a bit easier to understand...

   if (unlikely(++nr_loops > 3)) {

-- Steve

