Return-Path: <linux-kernel-owner+w=401wt.eu-S1758064AbZA2NnJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758064AbZA2NnJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 08:43:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752981AbZA2Nm4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 08:42:56 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:53150 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752789AbZA2Nm4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 08:42:56 -0500
Date: Thu, 29 Jan 2009 14:42:24 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       rusty@rustcorp.com.au, npiggin@suse.de, torvalds@linux-foundation.org,
       tglx@linutronix.de, arjan@infradead.org
Subject: Re: [PATCH] use per cpu data for single cpu ipi calls
Message-ID: <20090129134224.GH24391@elte.hu>
References: <alpine.DEB.1.10.0901281029150.25359@gandalf.stny.rr.com> <200901290955.38940.rusty@rustcorp.com.au> <alpine.DEB.1.10.0901281916400.9203@gandalf.stny.rr.com> <20090128173039.cbc29e81.akpm@linux-foundation.org> <1233218954.7835.11.camel@twins> <20090129111330.GB30738@elte.hu> <1233229316.4495.39.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1233229316.4495.39.camel@laptop>
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


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Thu, 2009-01-29 at 12:13 +0100, Ingo Molnar wrote:
> > * Peter Zijlstra <peterz@infradead.org> wrote:
> > 
> > > > Can generic_smp_call_function_single_interrupt() ever see 
> > > > CSD_FLAG_ALLOC set now?  If not, that kfree can go away.
> > > 
> > > Like said above, removing that kmalloc will hurt people.
> > 
> > the whole promise of generic-IPI seems to dwindle and we'll get back to 
> > roughly where we started out from.
> 
> I'd not go that far, the per-cpu csd is a nice fallback, but removing 
> that kmalloc is just silly.
> 
> And I see no reason why arch specific could do any better (aside from 
> sparc which has fancy ipis).

well if the hw can embedd at least 64 bit of dataload in the IPI itself, 
we could get rid of a lot of complications. But since we cannot (on x86 
and most other architectures), we've got to demultiplex from generic data 
which brings up serialization issues and adds overhead .

	Ingo
