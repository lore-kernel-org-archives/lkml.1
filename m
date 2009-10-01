Return-Path: <linux-kernel-owner+w=401wt.eu-S1755621AbZJAHZc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755621AbZJAHZc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 03:25:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755597AbZJAHZc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 03:25:32 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50720 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755543AbZJAHZb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 03:25:31 -0400
Date: Thu, 1 Oct 2009 09:25:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arjan van de Ven <arjan@infradead.org>
Cc: prasad@linux.vnet.ibm.com, "Frank Ch. Eigler" <fche@redhat.com>,
       peterz@infradead.org, linux-kernel@vger.kernel.org,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [RFC PATCH] perf_core: provide a kernel-internal interface to
	get to performance counters
Message-ID: <20091001072518.GA1502@elte.hu>
References: <20090925122556.2f8bd939@infradead.org> <y0mhbuplmlr.fsf@fche.csb> <20090926183246.GA4141@in.ibm.com> <20090926204848.0b2b48d2@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090926204848.0b2b48d2@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0028]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arjan van de Ven <arjan@infradead.org> wrote:

> On Sun, 27 Sep 2009 00:02:46 +0530
> "K.Prasad" <prasad@linux.vnet.ibm.com> wrote:
> 
> > On Sat, Sep 26, 2009 at 12:03:28PM -0400, Frank Ch. Eigler wrote:
> 
> > > For what it's worth, this sort of thing also looks useful from 
> > > systemtap's point of view.
> > 
> > Wouldn't SystemTap be another user that desires support for 
> > multiple/all CPU perf-counters (apart from hw-breakpoints as a 
> > potential user)? As Arjan pointed out, perf's present design would 
> > support only a per-CPU or per-task counter; not both.
> 
> I'm sorry but I think I am missing your point. "all cpu counters" 
> would be one small helper wrapper away, a helper I'm sure the 
> SystemTap people are happy to submit as part of their patch series 
> when they submit SystemTap to the kernel.

Yes, and Frederic wrote that wrapper already for the hw-breakpoints 
patches. It's a non-issue and does not affect the design - we can always 
gang up an array of per cpu perf events, it's a straightforward use of 
the existing design.

User-space tools have been doing this for ages already, 'perf top' will 
open an array of per cpu events to monitor all events in the system.

	Ingo
