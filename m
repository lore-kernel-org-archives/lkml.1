Return-Path: <linux-kernel-owner+w=401wt.eu-S1756701AbZCYHlM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756701AbZCYHlM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 03:41:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753604AbZCYHlC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 03:41:02 -0400
Received: from www.tglx.de ([62.245.132.106]:54396 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751283AbZCYHlA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 03:41:00 -0400
Date: Wed, 25 Mar 2009 08:39:11 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: David Brownell <david-b@pacbell.net>
cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Christoph Hellwig <hch@infradead.org>,
       Arjan van de Veen <arjan@infradead.org>,
       Jon Masters <jonathan@jonmasters.org>,
       Sven Dietrich <sdietrich@suse.de>
Subject: Re: [patch 0/2] Add support for threaded interrupt handlers - V3
In-Reply-To: <200903241638.11724.david-b@pacbell.net>
Message-ID: <alpine.LFD.2.00.0903250833260.29264@localhost.localdomain>
References: <20090323172814.548471871@linutronix.de> <200903241444.44644.david-b@pacbell.net> <alpine.LFD.2.00.0903242252080.29264@localhost.localdomain> <200903241638.11724.david-b@pacbell.net>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Mar 2009, David Brownell wrote:

> On Tuesday 24 March 2009, Thomas Gleixner wrote:
> > On Tue, 24 Mar 2009, David Brownell wrote:
> > > On Monday 23 March 2009, Thomas Gleixner wrote:
> > > > I'm still looking into a clean solution for the threaded demultiplex
> > > > handler case which was brought up by Dave to allow both the handling
> > > > of the demultiplexed devices in the context of the demultiplexer
> > > > interrupt thread and the wakeup of separate handler threads. But this
> > > > is an orthogonal extension of the existing patch set and does not
> > > > change the general design.
> > > 
> > > No comments on the patch I sent?
> > 
> > Looked at it briefly, but I still try to figure out what the best
> > solution for this will be. As I said I'd like to support both
> > variants:
> > 
> > 1) demux handlers run in the primary interrupt thread context
> > 2) demux handlers kick their own handler threads
> 
> I have no need for the latter, at least in current systems.

Groan, the fact that you do not need it is definitely _not_ a good
reason to just add a irq_is_sufficient_for_dave_handler.

> > I don't want to special case that. See above.
> 
> What's a special case though?  If you're serious about
> wanting to support more than one case, it's always going
> to be possible to call some of them "special".  As in,
> "threaded IRQs are a special case in genirq".  That should
> not mean they don't get handled.

I don't like the idea of another action dispatcher in a special case
handler. The goal is to reuse the code i.e. simple_handler and
handle_IRQ_event. It just needs some thoughts to implement it in a
sane way.

Thanks,

	tglx
