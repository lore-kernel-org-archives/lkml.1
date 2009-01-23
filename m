Return-Path: <linux-kernel-owner+w=401wt.eu-S1758273AbZAWM5W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758273AbZAWM5W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 07:57:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754837AbZAWM5N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 07:57:13 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:42349 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754717AbZAWM5M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 07:57:12 -0500
Date: Fri, 23 Jan 2009 13:56:49 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Nick Piggin <npiggin@suse.de>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Lin Ming <ming.m.lin@intel.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Christoph Lameter <clameter@engr.sgi.com>
Subject: Re: [patch] SLQB slab allocator
Message-ID: <20090123125649.GA20883@elte.hu>
References: <20090121143008.GV24891@wotan.suse.de> <20090121145918.GA11311@elte.hu> <20090121165600.GA16695@wotan.suse.de> <20090121174010.GA2998@elte.hu> <20090123061405.GK20098@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090123061405.GK20098@wotan.suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Nick Piggin <npiggin@suse.de> wrote:

> On Wed, Jan 21, 2009 at 06:40:10PM +0100, Ingo Molnar wrote:
> > -static inline void slqb_stat_inc(struct kmem_cache_list *list,
> > -				enum stat_item si)
> > +static inline void
> > +slqb_stat_inc(struct kmem_cache_list *list, enum stat_item si)
> >  {
> 
> Hmm, I'm not entirely fond of this style. [...]

well, it's a borderline situation and a nuance, and i think we agree on 
the two (much more common) boundary conditions:

 1) line fits into 80 cols - in that case we keep it all on a single line
    (this is the ideal case)

 2) line does not fit on two lines either - in that case we do the style
    that you used above.

On the boundary there's a special case though, and i tend to prefer:

 +static inline void
 +slqb_stat_inc(struct kmem_cache_list *list, enum stat_item si)

over:

 -static inline void slqb_stat_inc(struct kmem_cache_list *list,
 -				enum stat_item si)

for two reasons:

 1) the line break is not just arbitrarily in the middle of the 
    enumeration of arguments - it is right after function return type.

 2) the arguments fit on a single line - and often one wants to know that 
    signature. (return values are usually a separate thought)

 3) the return type stands out much better.

But again ... this is a nuance.

> [...] The former scales to longer lines with just a single style change 
> (putting args into new lines), wheras the latter first moves its 
> prefixes to a newline, then moves args as the line grows even longer.

the moment this 'boundary style' "overflows", it falls back to the 'lots 
of lines' case, where we generally put the function return type and the 
function name on the first line.

> I guess it is a matter of taste, not wrong either way... but I think 
> most of the mm code I'm used to looking at uses the former. Do you feel 
> strongly?

there are a handful of cases where the return type (and the function 
attributes) are _really_ long - in this case it really helps to have them 
decoupled from the arguments.

	Ingo
