Return-Path: <linux-kernel-owner+w=401wt.eu-S1756923Ab0A2KPx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756923Ab0A2KPx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 05:15:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756907Ab0A2KPw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 05:15:52 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55980 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756881Ab0A2KPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 05:15:51 -0500
Date: Fri, 29 Jan 2010 02:13:57 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       torvalds@linux-foundation.org, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] bitops: Provide compile time
 HWEIGHT{8,16,32,64}
Message-Id: <20100129021357.4db5823e.akpm@linux-foundation.org>
In-Reply-To: <20100129100431.GA6513@elte.hu>
References: <20100122155535.797688466@chello.nl>
	<tip-9f41699ed067fa695faff8e2e9981b2550abec62@git.kernel.org>
	<20100129020128.716af8fb.akpm@linux-foundation.org>
	<20100129100431.GA6513@elte.hu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Jan 2010 11:04:31 +0100 Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > On Fri, 29 Jan 2010 09:28:04 GMT tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > 
> > > +#define HWEIGHT8(w)			\
> > > +      (	(!!((w) & (1ULL << 0))) +	\
> > > +	(!!((w) & (1ULL << 1))) +	\
> > > +	(!!((w) & (1ULL << 2))) +	\
> > > +	(!!((w) & (1ULL << 3))) +	\
> > > +	(!!((w) & (1ULL << 4))) +	\
> > > +	(!!((w) & (1ULL << 5))) +	\
> > > +	(!!((w) & (1ULL << 6))) +	\
> > > +	(!!((w) & (1ULL << 7)))	)
> > > +
> > > +#define HWEIGHT16(w) (HWEIGHT8(w)  + HWEIGHT8(w >> 8))
> > > +#define HWEIGHT32(w) (HWEIGHT16(w) + HWEIGHT16(w >> 16))
> > > +#define HWEIGHT64(w) (HWEIGHT32(w) + HWEIGHT32(w >> 32))
> > 
> > Would be nice if it had a comment explaining why it exists.  If people
> > accidentally use this with non-constant arguments, the generated code
> > will be pretty ghastly.
> > 
> > Or add some barf-if-not-__constant_p() thing, perhaps.
> 
> Yeah, agreed.
> 

Also...

Should we just do

#define HWEIGHT(x) HWEIGHT64(x)

and make HWEIGHT() the sole officially-exported interface?  I mean, all
it does is emit an obfuscated constant - perhaps we can save users from
having to pick which one of the above to use by giving them a "this one
always works" interface.

That might require some casting to suppress "shift out of range"
warnings though.

<wonders if we'd otherwise end up needing an HWEIGHT_LONG()>
