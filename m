Return-Path: <linux-kernel-owner+w=401wt.eu-S932630AbZJGJJr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932630AbZJGJJr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 05:09:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932511AbZJGJJr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 05:09:47 -0400
Received: from casper.infradead.org ([85.118.1.10]:51414 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932299AbZJGJJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 05:09:46 -0400
Subject: Re: [this_cpu_xx V5 19/19] SLUB: Experimental new fastpath w/o
 interrupt disable
From: Peter Zijlstra <peterz@infradead.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: cl@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       Tejun Heo <tj@kernel.org>, Mel Gorman <mel@csn.ul.ie>
In-Reply-To: <20091007025440.GB4664@Krystal>
References: <20091006233654.815079668@gentwo.org>
	 <20091006233733.153341605@gentwo.org>  <20091007025440.GB4664@Krystal>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 07 Oct 2009 11:11:47 +0200
Message-Id: <1254906707.26976.225.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-10-06 at 22:54 -0400, Mathieu Desnoyers wrote:
> > +     local_irq_save(flags);
> > +     preempt_enable();       /* Get rid of count */
> 
> Ugh ? Is that legit ?

Yeah, it reads rather awkward, and the comment doesn't make it any
better, but what he's doing is:

slab_alloc()
  preempt_disable();
  __slab_alloc()
    local_irq_save(flags);
    preempt_enable();


