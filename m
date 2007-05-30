Return-Path: <linux-kernel-owner+w=401wt.eu-S1754718AbXE3R2L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754718AbXE3R2L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 13:28:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753128AbXE3R16
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 13:27:58 -0400
Received: from homer.mvista.com ([63.81.120.158]:27160 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753063AbXE3R15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 13:27:57 -0400
Subject: Re: [PATCH 3/5] lockstat: core infrastructure
From: Daniel Walker <dwalker@mvista.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Bill Huey <billh@gnuppy.monkey.org>, Jason Baron <jbaron@redhat.com>,
       Christoph Hellwig <hch@infradead.org>
In-Reply-To: <1180545380.2958.1.camel@lappy>
References: <20070529125248.877196281@chello.nl>
	 <20070529130107.112347096@chello.nl>
	 <1180470525.32594.71.camel@imap.mvista.com>
	 <20070530132431.GA23947@elte.hu>
	 <Pine.LNX.4.58.0705300936390.15841@gandalf.stny.rr.com>
	 <20070530134907.GA27085@elte.hu>
	 <1180544796.32594.184.camel@imap.mvista.com>
	 <1180545380.2958.1.camel@lappy>
Content-Type: text/plain
Date: Wed, 30 May 2007 10:25:13 -0700
Message-Id: <1180545913.32594.194.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-05-30 at 19:16 +0200, Peter Zijlstra wrote:

> > >From the architecture perspective there are two low level clock hooks to
> > implement one is sched_clock() , and at least one clocksource structure.
> > Both do essentially the same thing. With timekeepings clocksource
> > structure actually being easier to implement cause the math is built in.
> 
> I think you are mistaken here; the two are similar but not identical.
> 
> I see sched_clock() as fast first, accurate second. Whereas the
> clocksource thing is accurate first, fast second.

This is true .. However, if there is a speed different it's small.
In the past I've replace sched_clock() with a clocksource, and there was
no noticeable speed different .. Just recently I replaced x86's
sched_clock() math with the clocksource math with no noticable
difference .. At least not from my benchmarks ..

> There is room for both of them.

There is room, but we don't need sched_clock() .. Certainly we shouldn't
force architectures to implement sched_clock() by calling it a "bug" if
it's lowres.

Daniel

