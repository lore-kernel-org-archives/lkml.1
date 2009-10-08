Return-Path: <linux-kernel-owner+w=401wt.eu-S1754731AbZJHHu2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754731AbZJHHu2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 03:50:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754536AbZJHHu2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 03:50:28 -0400
Received: from casper.infradead.org ([85.118.1.10]:37856 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754335AbZJHHu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 03:50:27 -0400
Subject: Re: [this_cpu_xx V5 19/19] SLUB: Experimental new fastpath w/o
 interrupt disable
From: Peter Zijlstra <peterz@infradead.org>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Pekka Enberg <penberg@cs.helsinki.fi>, Tejun Heo <tj@kernel.org>,
       Mel Gorman <mel@csn.ul.ie>, mingo@elte.hu
In-Reply-To: <alpine.DEB.1.10.0910071119450.9296@gentwo.org>
References: <20091006233654.815079668@gentwo.org>
	 <20091006233733.153341605@gentwo.org> <20091007025440.GB4664@Krystal>
	 <1254906707.26976.225.camel@twins> <20091007124628.GB27363@Krystal>
	 <alpine.DEB.1.10.0910071039520.5671@gentwo.org>
	 <20091007150257.GA8508@Krystal>
	 <alpine.DEB.1.10.0910071102590.9984@gentwo.org>
	 <20091007151940.GA10052@Krystal>
	 <alpine.DEB.1.10.0910071119450.9296@gentwo.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 08 Oct 2009 09:52:30 +0200
Message-Id: <1254988350.26976.256.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-10-07 at 11:21 -0400, Christoph Lameter wrote:
> On Wed, 7 Oct 2009, Mathieu Desnoyers wrote:
> 
> > You are already calling the scheduler when ending the _fast_ path. I
> > don't see the problem with calling it when you end the slow path
> > execution.
> 
> Well yes that gives rise to the thought of using
> 
> 	preempt_enable_no_sched()

NACK, delaying the reschedule is not an option
