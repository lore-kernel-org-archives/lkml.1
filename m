Return-Path: <linux-kernel-owner+w=401wt.eu-S1755419AbZCFK1r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755419AbZCFK1r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 05:27:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753399AbZCFK1i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 05:27:38 -0500
Received: from smtp-out.google.com ([216.239.45.13]:46915 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240AbZCFK1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 05:27:37 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=lO449pW8Odiy91umdckzqFjwmfbIVdOfr0WYYjnM3HH3SK7PGvwNI9CCbq7AUx/XG
	2EP9HCQ974BlTfzjjY/9w==
Date: Fri, 6 Mar 2009 02:27:25 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Peter Zijlstra <peterz@infradead.org>
cc: Ingo Molnar <mingo@elte.hu>, "David S. Miller" <davem@davemloft.net>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 2/2] lockdep: initialize lockdep debugging statistics
In-Reply-To: <1236334756.6326.106.camel@laptop>
Message-ID: <alpine.DEB.2.00.0903060221500.25972@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0903050222160.30401@chino.kir.corp.google.com>  <alpine.DEB.2.00.0903050223240.30401@chino.kir.corp.google.com>  <1236250159.4228.186.camel@laptop> <20090305110522.GI32407@elte.hu>  <alpine.DEB.2.00.0903051355010.25505@chino.kir.corp.google.com>
  <1236328083.5187.1213.camel@laptop>  <alpine.DEB.2.00.0903060149540.26215@chino.kir.corp.google.com> <1236334756.6326.106.camel@laptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Mar 2009, Peter Zijlstra wrote:

> > Peter, this is purely a matter of good software engineering practices. 
> 
> For complex types I would agree, but atomic_t is assumed to be just
> another int - just with special ops. For such things we can hold that
> memset('0') will properly initialize them to their 0 value.
> 

That's the point about good software engineering practices: atomic_t 
should not be assumed to be another int.  If its implementation were ever 
to change even for a single architecture, so would these variable 
declarations.

> > I assume you wouldn't object to removing all such cases in the kernel.
> > 
> >         $ grep -r "atomic_t.*= ATOMIC_INIT(0)" * | wc -l
> >         104
> 
> Only IFF all those cases are for static/global storage.

They are.

Anyway, I've already deferred to your maintainership of lockdep about not 
wanting to initialize global atomics in this part of the kernel, so while 
I disagree with it from a software engineering perspective, I think I'll 
be able to move on.
