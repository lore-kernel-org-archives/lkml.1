Return-Path: <linux-kernel-owner+w=401wt.eu-S1762794AbZCQHyc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762794AbZCQHyc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 03:54:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752742AbZCQHyX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 03:54:23 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:60254 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396AbZCQHyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 03:54:22 -0400
Date: Tue, 17 Mar 2009 03:54:17 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Sven-Thorsten Dietrich <sdietrich@novell.com>
Cc: Christoph Hellwig <hch@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Arjan van de Veen <arjan@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Jon Masters <jonathan@jonmasters.org>
Subject: Re: [patch 3/4] genirq: add a quick check handler
Message-ID: <20090317075417.GD3331@infradead.org>
References: <20090226131336.423054348@linutronix.de> <20090226131719.640887792@linutronix.de> <20090228222408.GB7797@infradead.org> <1236283149.20484.31.camel@sven.thebigcorporation.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1236283149.20484.31.camel@sven.thebigcorporation.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 05, 2009 at 11:59:09AM -0800, Sven-Thorsten Dietrich wrote:
> Most of the IRQ handler, whether run in a thread or IRQ context, will be
> the same code - so what you are proposing would have to eliminate code
> duplication as well as heavy runtime branching overhead.
> 
> Ultimately, no matter how its done, the concept of disabling IRQ assert
> at the device level, rather than the apic level, is the optimal
> "correct" implementation.
> 
> Formulating that into the code, as Thomas proposed with the quickcheck,
> supplies structural demarcation for semi as well as software design.


Umm, the code will be look more or less the same either way.  I just
think overloading the current handler to mean two different things is
a bad idea.  For a driver using a quick disable handler and a long slow
threaded one the only difference is naming the two functions
differently.

I wonder if you're still thinking in the way of a -RT like setup where
threaded interrupts can be enabled and disabled globally?  I don't think
we should ever do that for mainline.

