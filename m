Return-Path: <linux-kernel-owner+w=401wt.eu-S1754540AbYJCI3m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754540AbYJCI3m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 04:29:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752173AbYJCI3c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 04:29:32 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:50842 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684AbYJCI3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 04:29:31 -0400
Date: Fri, 3 Oct 2008 04:29:27 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Veen <arjan@infradead.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Jon Masters <jonathan@jonmasters.org>,
       Sven Dietrich <sdietrich@suse.de>
Subject: Re: [RFC patch 2/5] genirq: add a quick check handler
Message-ID: <20081003082927.GA25683@infradead.org>
References: <20081001223213.078984344@linutronix.de> <20081001223301.900862899@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081001223301.900862899@linutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 01, 2008 at 11:02:18PM -0000, Thomas Gleixner wrote:
> Preparatory patch for threaded interrupt handlers.
> 
> Adds a quick check handler which is called before the real handler.
> The quick check handler can decide whether the interrupt was originated
> from the device or not. It can also declare the interrupt as handled
> and subsequently avoid that the real handler is called.

I'd rather leave the handler as a handle which could return
IRQ_NEEDS_HANDLING to get a separate thread_fn called.  This seems more
intuitive and means less mess in the fastpath.

Maybe IRQ_NEEDS_HANDLING might better be named IRQ_THREADED os similar,
but that's really getting into nitpicking..

