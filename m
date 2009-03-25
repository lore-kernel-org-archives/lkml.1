Return-Path: <linux-kernel-owner+w=401wt.eu-S1756742AbZCYU0V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756742AbZCYU0V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 16:26:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752260AbZCYU0N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 16:26:13 -0400
Received: from gw.goop.org ([64.81.55.164]:38572 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751909AbZCYU0M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 16:26:12 -0400
Message-ID: <49CA935F.8000908@goop.org>
Date: Wed, 25 Mar 2009 13:26:07 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Matt Mackall <mpm@selenic.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Hua Zhong <hzhong@gmail.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Roland McGrath <roland@redhat.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Steven Rostedt <srostedt@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 2/5] mm: remove unlikly NULL from kfree
References: <20090325051920.406564281@goodmis.org>  <20090325052023.071564146@goodmis.org>  <84144f020903250034j24e1782bt5f73809b9349346c@mail.gmail.com>  <009101c9ad20$1ae231c0$50a69540$@com>  <1237968394.30175.12.camel@penberg-laptop>  <84144f020903250651o13c723cgf64643091459a5ac@mail.gmail.com>  <alpine.DEB.2.00.0903251039590.5675@gandalf.stny.rr.com>  <1237993145.30175.34.camel@penberg-laptop>  <alpine.DEB.2.00.0903251103070.5675@gandalf.stny.rr.com>  <alpine.DEB.2.00.0903251105030.5675@gandalf.stny.rr.com> <1237997658.2132.193.camel@calx> <alpine.DEB.2.00.0903251227360.5675@gandalf.stny.rr.com>
In-Reply-To: <alpine.DEB.2.00.0903251227360.5675@gandalf.stny.rr.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> Thanks for this info!
>
> Although gcc plays a role too. That is, if we have
>
> 	if (x)
> 		do something small;
>
> 	do something large;
>
>
> this can be broken into:
>
> 	cmp x
> 	beq 1f
> 	do something small
> 1:
> 	do something large
>
> Which plays nice with the cache. But, by adding a unlikely(x), gcc will 
> probably choose to do:
>
> 	cmp x
> 	bne 2f
>
> 1:
> 	do something large
>
> 	ret;
>
> 2:
> 	do something small
> 	b 1b
>
> which hurts in a number of ways.
>   

I think that's probably the dominant effect on x86 systems, because 
Intel doesn't recommend using the branch hint prefixes as far as I can 
tell (their consumption of icache space outweighs any benefit of priming 
the predictor).

    J
