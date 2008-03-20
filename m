Return-Path: <linux-kernel-owner+w=401wt.eu-S1758697AbYCTWGm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758697AbYCTWGm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 18:06:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755762AbYCTWGb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 18:06:31 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58905 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757427AbYCTWGa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 18:06:30 -0400
Date: Thu, 20 Mar 2008 23:05:40 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Jon Masters <jcm@jonmasters.org>, Jon Masters <jcm@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Christoph Hellwig <hch@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch 4/4] Markers Support for Proprierary Modules
Message-ID: <20080320220540.GA29012@elte.hu>
References: <20080320002737.918213455@polymtl.ca> <20080320002835.384758480@polymtl.ca> <20080320191205.GA13309@elte.hu> <y0mzlst6tgi.fsf@ton.toronto.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <y0mzlst6tgi.fsf@ton.toronto.redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frank Ch. Eigler <fche@redhat.com> wrote:

> Ingo Molnar <mingo@elte.hu> writes:
> 
> >> There seems to be good arguments for markers to support proprierary 
> >> modules. So I am throwing this one-liner in and let's see how people 
> >> react. [...]
> >
> > ugh, this is unbelievably stupid move technically - so a very strong 
> > NACK. Allowing marker use in unfixable modules (today it's placing 
> > markers into unfixable modules, 
> 
> As the thread suggested, this can benefit us more than it benefits
> them, because it may let us see more into the blobs.
> 
> > tomorrow it's marker use by such modules) has only one clear and 
> > predictable effect: it turns marker calls into essential ABIs [...]
> 
> The marker_probe_*register calls are already EXPORT_SYMBOL_GPL'd, so 
> that covers your "tomorrow" case.  NACK that all you like when/if 
> someone proposes changing that.

i very much know that they are exported that way. It's the concept i'm 
against - dont we have 9 million lines of proper kernel source code to 
worry about? Why are we even arguing about this? Binary modules should 
be as isolated as possible - it's a totally untrusted entity and history 
has shown it again and again that the less infrastructure coupling we 
have to them, the better.

> > [if the proprietary modules attach to kernel markers ...] then all 
> > the pressure is on those who _can_ fix their code - meaning the 
> > kernel subsystem maintainers that use [you mean: define] markers.
> 
> (In a way, it would be a nice problem to have.  At this moment, there 
> are still no markers actually committed within -mm nor -linus.)

... which makes it doubly problematic to expose them to binary-only 
modules in any way, shape or form. Really, once _any_ kernel facility is 
used by such a module, it's pain for us to change it from that point on. 
Once markers are a 10 year concept that nobody in their right mind would 
want to change, sure, we dont _care_ about whether it's export or not, 
and basic courtesy might say that it's OK to do it. But to proactively 
export any aspect of a half-done piece of infrastructure is crazy.

	Ingo
