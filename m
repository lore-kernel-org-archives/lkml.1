Return-Path: <linux-kernel-owner+w=401wt.eu-S1755971AbZEVJCO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755971AbZEVJCO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 05:02:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751894AbZEVJCA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 05:02:00 -0400
Received: from viefep14-int.chello.at ([62.179.121.34]:44289 "EHLO
	viefep14-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751608AbZEVJCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 05:02:00 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [PATCH 2/2] perf_counter: optimize context switch between
 identical inherited contexts
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20090522085716.GB13482@elte.hu>
References: <18966.10075.781053.231153@cargo.ozlabs.ibm.com>
	 <18966.10666.517218.332164@cargo.ozlabs.ibm.com>
	 <1242981131.26820.620.camel@twins>  <20090522085716.GB13482@elte.hu>
Content-Type: text/plain
Date: Fri, 22 May 2009 11:02:00 +0200
Message-Id: <1242982920.26820.622.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-05-22 at 10:57 +0200, Ingo Molnar wrote:
> * Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> 
> > On Fri, 2009-05-22 at 14:27 +1000, Paul Mackerras wrote:
> > 
> > > The equivalence of contexts is detected by keeping a pointer in
> > > each cloned context pointing to the context it was cloned from.
> > > To cope with the situation where a context is changed by adding
> > > or removing counters after it has been cloned, we also keep a
> > > generation number on each context which is incremented every time
> > > a context is changed.  When a context is cloned we take a copy
> > > of the parent's generation number, and two cloned contexts are
> > > equivalent only if they have the same parent and the same
> > > generation number.  In order that the parent context pointer
> > > remains valid (and is not reused), we increment the parent
> > > context's reference count for each context cloned from it.
> > 
> > > +	u32			generation;
> > 
> > Suppose someone writes a malicious proglet that inherits the 
> > counters, puts the child to sleep, does 2^32 mods on the counter 
> > set, and then wakes up the child.
> > 
> > Would that merely corrupt the results, or make the kernel explode?
> 
> i think it should be an u64.

So at to make the attack infeasible by death of the attacker and burnout
of the solar-system? :-)

