Return-Path: <linux-kernel-owner+w=401wt.eu-S1755718AbZCYVYX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755718AbZCYVYX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 17:24:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752767AbZCYVYK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 17:24:10 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:40410 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133AbZCYVYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 17:24:09 -0400
Date: Wed, 25 Mar 2009 17:24:06 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Matt Mackall <mpm@selenic.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, Hua Zhong <hzhong@gmail.com>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Roland McGrath <roland@redhat.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Steven Rostedt <srostedt@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 2/5] mm: remove unlikly NULL from kfree
In-Reply-To: <1238014906.2132.373.camel@calx>
Message-ID: <alpine.DEB.2.00.0903251721100.5675@gandalf.stny.rr.com>
References: <20090325051920.406564281@goodmis.org>  <20090325052023.071564146@goodmis.org>  <84144f020903250034j24e1782bt5f73809b9349346c@mail.gmail.com>  <009101c9ad20$1ae231c0$50a69540$@com>  <1237968394.30175.12.camel@penberg-laptop> 
 <84144f020903250651o13c723cgf64643091459a5ac@mail.gmail.com>  <alpine.DEB.2.00.0903251039590.5675@gandalf.stny.rr.com>  <1237993145.30175.34.camel@penberg-laptop>  <alpine.DEB.2.00.0903251103070.5675@gandalf.stny.rr.com>  <alpine.DEB.2.00.0903251105030.5675@gandalf.stny.rr.com>
  <1237997658.2132.193.camel@calx>  <alpine.DEB.2.00.0903251227360.5675@gandalf.stny.rr.com> <1238014906.2132.373.camel@calx>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 25 Mar 2009, Matt Mackall wrote:
> 
> The cost is an unconditional branch; the ret already exists. There's a
> slightly larger cache footprint for the small branch and a slightly
> smaller footprint for the large branch. If p is close to .5 and
> calls/sec is high, the cache footprint is the sum of the footprint of
> both branches. But if calls/sec is close to low, cache footprint is also
> low.
> 
> So, yeah, I think this is a good additional argument to err on the side
> of not adding these things at all. And I certainly wasn't intending to
> defend the ones in kfree. 
> 
> But I'm also skeptical of whether it's worth spending much time actively
> routing out the moderately incorrect instances. It's going to be nearly
> immune to performance benchmarking. We should instead just actively
> discourage using unlikely in new code.
> 

Sure. OK, actually I'd say they are valid for 100% hits. These are for 
error conditions and trace point like data. Where, we want the least 
amount of overhead when the condition is false.

But I can see, we've been brought up (well some of us) that branches are 
horrible for pipelines, and any help in deciding the choice is always 
tempting.

-- Steve

