Return-Path: <linux-kernel-owner+w=401wt.eu-S1763468AbYDONSe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763468AbYDONSe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 09:18:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753637AbYDONS0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 09:18:26 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52528 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753210AbYDONS0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 09:18:26 -0400
Date: Tue, 15 Apr 2008 15:17:44 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       prasad@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>
Subject: Re: [RFC PATCH 1/2] Marker probes in futex.c
Message-ID: <20080415131744.GA5248@elte.hu>
References: <20080415115058.GA6788@in.ibm.com> <20080415115314.GA6975@in.ibm.com> <1208260942.6395.6.camel@twins> <20080415123233.GA19797@Krystal> <1208264190.6395.21.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1208264190.6395.21.camel@twins>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> > Because we extract the field names and types, we can create tracer 
> > plugins that would hook on field names rather than expect a specific 
> > number of fields and fixed field types. It makes it possible to 
> > tolerate missing fields pretty easily. But yes, tracer tools might 
> > have to be adapted to internal kernel changes, since they must 
> > follow kernel structure changes. However, staying as close as 
> > possible to a canonical representation of event fields, staying far 
> > from the specific implemetation, would help to lessen the 
> > inter-dependency. On the other hand, it would probably hurt trace 
> > compactness and efficiency.
> 
> See, these tracer tools are my nightmare as member of an enterprise 
> linux team. They'll make an already hard job even harder, no thanks!

i'm clearly NAK-ing all futex trace hooks until the true impact of the 
whole marker facility is better understood. I've tried them for the 
scheduler and they were a clear failure: too bloated and too persistent.

but more importantly, as things stand today i've yet to see a _any_ 
bugreport where these 'tracer' tools that are being referred to were 
actually used in the field to fix something. The latency tracers (and 
the other tracer variants in -rt) on the other hand have a documented 
track record of being useful in fixing bugs and instrumenting the 
kernel.

	Ingo
