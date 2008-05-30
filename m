Return-Path: <linux-kernel-owner+w=401wt.eu-S1759399AbYE3Fbh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759399AbYE3Fbh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 01:31:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753047AbYE3Fb3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 01:31:29 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33846 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753003AbYE3Fb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 01:31:28 -0400
Date: Thu, 29 May 2008 22:31:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       David Miller <davem@davemloft.net>, Eric Dumazet <dada1@cosmosbay.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Mike Travis <travis@sgi.com>
Subject: Re: [patch 02/41] cpu alloc: The allocator
Message-Id: <20080529223109.bbb7b0e0.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0805292203240.12107@schroedinger.engr.sgi.com>
References: <20080530035620.587204923@sgi.com>
	<20080530040011.084909898@sgi.com>
	<20080529215833.469c3cbe.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0805292203240.12107@schroedinger.engr.sgi.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 May 2008 22:10:25 -0700 (PDT) Christoph Lameter <clameter@sgi.com> wrote:

> > > +		start++;
> > > +		first = 0;
> > > +	}
> > 
> > This is kinda bitmap_find_free_region(), only bitmap_find_free_region()
> > isn't quite strong enough.
> > 
> > Generally I think it would have been better if you had added new
> > primitives to the bitmap library (or enhanced existing ones) and used
> > them here, rather than implementing private functionality.
> 
> The scope of the patchset is already fairly large.

It would be a relatively small incremental effort ;)

> The search here is 
> different and not performance critical. Not sure if this is useful for 
> other purposes.

I think that strengthening bitmap_find_free_region() would end up
giving us a better kernel than open-coding something similar here.

> > > + */
> > > +
> > > +/* Return a pointer to the instance of a object for a particular processor */
> > > +#define CPU_PTR(__p, __cpu)	SHIFT_PERCPU_PTR((__p), per_cpu_offset(__cpu))
> > 
> > eek, a major interface function which is ALL IN CAPS!
> > 
> > can we do this in lower-case?  In a C function?
> 
> No. This is a macro and therefore uppercase (there is macro magic going on 
> that ppl need to be aware of). AFAICR you wanted it this way last year. C 
> function not possible because of the type checking.

urgh.  This is a C-convention versus kernel-convention thing.  The C
convention exists for very good reasons.  But it sure does suck.

What do others think?
