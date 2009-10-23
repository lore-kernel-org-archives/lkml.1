Return-Path: <linux-kernel-owner+w=401wt.eu-S1751893AbZJWKh6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751893AbZJWKh6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 06:37:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751657AbZJWKh5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 06:37:57 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45582 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751402AbZJWKh5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 06:37:57 -0400
Date: Fri, 23 Oct 2009 12:37:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: John Kacur <jkacur@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [performance problem] CONFIG_DYNAMIC_FTRACE: Increased kernel
	build times
Message-ID: <20091023103746.GF19169@elte.hu>
References: <20091023074533.GA10067@elte.hu> <520f0cf10910230307k91d0c80sa3d69bcd74d6e1f1@mail.gmail.com> <alpine.LFD.2.00.0910231211540.3549@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LFD.2.00.0910231211540.3549@localhost.localdomain>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* John Kacur <jkacur@redhat.com> wrote:

> 2009/10/23 Ingo Molnar <mingo@elte.hu> wrote:
> > 
> > Steve,
> > 
> > i did an 64-bit allyesconfig build test (with debug_info disabled), with
> > and without CONFIG_DYNAMIC_FTRACE set.
> > 
> > The build time results are:
> > 
> >  -CONFIG_DYNAMIC_FTRACE:   266.30
> >  +CONFIG_DYNAMIC_FTRACE:   296.07 (+11.2%)
> > 
> > So we get more than 10% build time overhead.
> > 
> > That's quite high - higher than what i remember having measured
> > originally when the first iteration of the mcount code went in.
> > 
> > This extra overhead comes from the mcount post-processing script
> > (scripts/recordmcount.pl) that runs objcopy as well and is written in
> > Perl. I think this whole angle needs to be improved - 10% is way too
> > high of a price to pay.
> 
> Hi Ingo, do you still have the profiling data to share with us? [...]

no finegrained info - i did a perf stat run.

> [...] Was the problem more in objcopy / objdump, rather than in the 
> perl script itself?

in top i saw perl pop up most of the time, that's where i'd suspect a 
good portion of the overhead.

	Ingo
