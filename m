Return-Path: <linux-kernel-owner+w=401wt.eu-S1758472AbYH2ODW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758472AbYH2ODW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 10:03:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756813AbYH2ODM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 10:03:12 -0400
Received: from www.tglx.de ([62.245.132.106]:36113 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754497AbYH2ODL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 10:03:11 -0400
Date: Fri, 29 Aug 2008 16:02:07 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Vegard Nossum <vegard.nossum@gmail.com>, mingo@elte.hu,
       daniel.blueman@gmail.com, clameter@sgi.com,
       torvalds@linux-foundation.org, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, bunk@kernel.org, protasnb@gmail.com,
       kernel-testers@vger.kernel.org
Subject: Re: [PATCH] debugobjects: fix lockdep warning #2
In-Reply-To: <20080828171706.6080accf.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0808291558470.3243@apollo.tec.linutronix.de>
References: <20080828153214.GA27653@localhost.localdomain> <20080828171706.6080accf.akpm@linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Aug 2008, Andrew Morton wrote:
> > 
> > The lock is also promoted to irq-safe (suggested by Dan).
> 
> What was the reason for this other change?  I'm sure Dan is a fine chap,
> but we usually prefer a little more justification for changes ;)

I added the info already, when I applied it to the tip-tree.

> > +		/* Now free them */
> > +		hlist_for_each_entry_safe(obj, node, tmp, &freelist, node) {
> > +			hlist_del(&obj->node);
> > +			free_object(obj);
> 
> I suspect that we can avoid the hlist_del() here, perhaps with a little
> effort.
> 
> > +
> > +		/* Now free them */
> > +		hlist_for_each_entry_safe(obj, node, tmp, &freelist, node) {
> > +			hlist_del(&obj->node);
> > +			free_object(obj);
> > +		}
> > +
> 
> and the other one.
> 
> But I'm not sure that it's worth putting effort into - leaving dead
> objects strung onto a partially-live list is a little bit smelly IMO.

I really feel better, when we delete them instead of throwing them
away with pointers to each other.

Thanks,

	tglx
