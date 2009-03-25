Return-Path: <linux-kernel-owner+w=401wt.eu-S1757108AbZCYUSo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757108AbZCYUSo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 16:18:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753900AbZCYUSg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 16:18:36 -0400
Received: from n27.bullet.mail.mud.yahoo.com ([68.142.206.222]:43799 "HELO
	n27.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753649AbZCYUSf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 16:18:35 -0400
X-Yahoo-Newman-Id: 780084.62564.bm@omp408.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=FKqj+MtPtclGf07DXs3Kb/lvJPrmiq4zhATnZTTPrtcn9cOJaXA0s49Ztzh3pnqYD8WzheXNUeJsZBqlFqrwb7CHbtIWHecC0SPPLSmeYyogoINtIeIJbPNFO/GlzCEM5JWGCNAxsseJBfxsmthO6eXU9LOe3rna0PeM2XYe6aY=  ;
X-YMail-OSG: qRvZ2U8VM1kTK9relOU1.IFhrdlJuVyqWpbh5uSR694i3oQutWaqUAPb7pRN9SMIyCMdT250b9OxiID9Q4OxmUTknqIxD0E5jfBLx63jClaqO72Ee8VO_B_MKGwbjoxiint9E2QYyAeHocD946FhtFVL.QroqNvOlGVsrfde0sUIH6zzBaMpKdvSuEcx
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 0/2] Add support for threaded interrupt handlers - V3
Date: Wed, 25 Mar 2009 13:18:31 -0700
User-Agent: KMail/1.9.10
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Christoph Hellwig <hch@infradead.org>,
       Arjan van de Veen <arjan@infradead.org>,
       Jon Masters <jonathan@jonmasters.org>,
       Sven Dietrich <sdietrich@suse.de>
References: <20090323172814.548471871@linutronix.de> <200903241638.11724.david-b@pacbell.net> <alpine.LFD.2.00.0903250833260.29264@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0903250833260.29264@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903251318.31301.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 25 March 2009, Thomas Gleixner wrote:
> > I have no need for the latter, at least in current systems.
> 
> Groan, the fact that you do not need it is definitely _not_ a good
> reason to just add a irq_is_sufficient_for_dave_handler.

Groan ... don't *you* be puttin' words in *my* mouth.

When I've been in the position you're now in, I've
found it useful to know the actual requirements of
interface users.  Without knowing that, it's kind of
hard to deliver a usable solution, n'est-ce pas?

I'm fairly certain you've seen systems that needlessly
pulled in complicating requirements, and thereby caused
trouble.  If you can provide something to efficiently
address both modes, fine.  But "the latter" seems like
one of those needless complicating additions, which
could easily slow progress.


> > > I don't want to special case that. See above.
> > 
> > What's a special case though?  If you're serious about
> > wanting to support more than one case, it's always going
> > to be possible to call some of them "special".  As in,
> > "threaded IRQs are a special case in genirq".  That should
> > not mean they don't get handled.
> 
> I don't like the idea of another action dispatcher in a special case
> handler. The goal is to reuse the code i.e. simple_handler and
> handle_IRQ_event. It just needs some thoughts to implement it in a
> sane way.

You were the one to suggest a flow handler specifically
for cases like this, though ... you seem to have changed
your mind on this topic.  ISTR the rationale was to get
past the current IRQF_DISABLED special casing found in
handle_IRQ_event(), by using a flow handler which didn't
call that routine.

- Dave


