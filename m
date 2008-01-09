Return-Path: <linux-kernel-owner+w=401wt.eu-S1755226AbYAIDzb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755226AbYAIDzb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 22:55:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752363AbYAIDzX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 22:55:23 -0500
Received: from gir.skynet.ie ([193.1.99.77]:54269 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752162AbYAIDzW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 22:55:22 -0500
Date: Wed, 9 Jan 2008 03:55:20 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: Andrew Morton <akpm@linux-foundation.org>
cc: torvalds@linux-foundation.org, hch@lst.de, ak@suse.de, pq@iki.fi,
       jbeulich@novell.com, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Revert "x86: optimize page faults like all other
 achitectures and kill notifier cruft"
In-Reply-To: <20080108192951.a4dc394f.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.0.82.0801090346370.9570@skynet.skynet.ie>
References: <alpine.DEB.0.82.0801090226240.9570@skynet.skynet.ie>
 <20080108190611.3b9c0760.akpm@linux-foundation.org>
 <alpine.DEB.0.82.0801090308230.9570@skynet.skynet.ie>
 <20080108192951.a4dc394f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> An alternative might be to come up with something decent and target 2.6.24.x

I don't see mmiotrace getting merged into a stable kernel... how do 
however see it getting cleaned up for 2.6.25 now that people know how 
fragile the kernel hooks for it are..

> We put the crappy code back in for 2.6.24 then take it out immediately
> after 2.6.24 and put something else in to support mmiotrace and perhaps the
> other new mystery features to which you refer below.  hm.

(I think the other mystery feature is actually a Novell kernel debugger 
but I'm not sure, madwifi use it for similiar reasons to mmiotrace I 
think..)

> > > 		all that crap
> > > 	}
> > > 
> > > 
> > > But that's all speculation.  Has anyone actually measured the pagefault
> > > latency impact of this change?

Message-Id: <20070427140516.523272684@de.ibm.com>
Subject: [patch 20/38] Minor fault path optimization.
Date:	Fri, 27 Apr 2007 16:05:23 +0200

was a patch to do exactly that.. hch decided the feature wasn't useful and 
posted a patch to remove it..

> 
> That change has been in the mainline tree for nearly three months.  All
> these affected parties have left it until the eve of 2.6.24 to actually
> tell us about it.  This is causing me sympathy problems :(
> 

Jan first complained on the 4th Decemeber last year, I'm just posting this 
now because Linus said send him a patch to revert regressions rather than 
just complain, I've prepared the patch to put back the old behaviour from 
2.6.23. This was only brought to my notice this morning but I'm not going 
to let that stop me from trying to find a correct fix rather than just 
ripping the feature out..

I think we could apply the page fault cleanup patch I mentioned earlier on 
top of this patch and get back the 300 cycles and that would make people 
happy, it makes sense for mmiotrace to use kprobes hooks and not have to 
do this stuff directly but if that is what is wanted the mmiotrace guys 
can do it directly in the future.

Dave.
