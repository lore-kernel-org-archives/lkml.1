Return-Path: <linux-kernel-owner+w=401wt.eu-S1753272AbZCXV5X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753272AbZCXV5X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 17:57:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750879AbZCXV5O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 17:57:14 -0400
Received: from www.tglx.de ([62.245.132.106]:58824 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750699AbZCXV5N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 17:57:13 -0400
Date: Tue, 24 Mar 2009 22:54:54 +0100 (CET)
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
In-Reply-To: <200903241444.44644.david-b@pacbell.net>
Message-ID: <alpine.LFD.2.00.0903242252080.29264@localhost.localdomain>
References: <20090323172814.548471871@linutronix.de> <200903241444.44644.david-b@pacbell.net>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Mar 2009, David Brownell wrote:
> On Monday 23 March 2009, Thomas Gleixner wrote:
> > I'm still looking into a clean solution for the threaded demultiplex
> > handler case which was brought up by Dave to allow both the handling
> > of the demultiplexed devices in the context of the demultiplexer
> > interrupt thread and the wakeup of separate handler threads. But this
> > is an orthogonal extension of the existing patch set and does not
> > change the general design.
> 
> No comments on the patch I sent?

Looked at it briefly, but I still try to figure out what the best
solution for this will be. As I said I'd like to support both
variants:

1) demux handlers run in the primary interrupt thread context
2) demux handlers kick their own handler threads

> Or is that what you meant by "orthogonal"?  Admittedly that
> patch sort of begs the question about which request_irq()
> variant should be used for such demuxed IRQs; the "current"
> assumption is that request_irq() suffices, but that could
> be improved so the handle_threaded_irq() flow handler could
> use the action->thread_fn not action->handler.

I don't want to special case that. See above.

Thanks,

	tglx
