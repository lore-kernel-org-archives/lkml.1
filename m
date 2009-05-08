Return-Path: <linux-kernel-owner+w=401wt.eu-S1760494AbZEHOab@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760494AbZEHOab (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 10:30:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759276AbZEHOaA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 10:30:00 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:48075 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760198AbZEHO37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 10:29:59 -0400
Date: Fri, 8 May 2009 10:29:32 -0400 (EDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@qirst.com
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Cyrill Gorcunov <gorcunov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu, mel@csn.ul.ie,
       linux-kernel@vger.kernel.org, riel@redhat.com, rientjes@google.com,
       xemul@openvz.org
Subject: Re: [RFC/PATCH v2] mm: Introduce GFP_PANIC for non-failing
 allocations
In-Reply-To: <1241792580.28600.41.camel@penberg-laptop>
Message-ID: <alpine.DEB.1.10.0905081026210.21690@qirst.com>
References: <20090504122740.GH4173@lenovo> <20090504131311.GA23330@elte.hu>  <20090504131638.GJ4173@lenovo>  <alpine.DEB.1.10.0905040940490.9553@qirst.com>  <20090504115335.9bc08587.akpm@linux-foundation.org>  <20090504192117.GB31176@lenovo> 
 <20090504123453.d130a6cf.akpm@linux-foundation.org>  <20090504200925.GD31176@lenovo> <1241787448.28600.26.camel@penberg-laptop>  <alpine.DEB.1.10.0905081018130.23875@qirst.com> <1241792580.28600.41.camel@penberg-laptop>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 May 2009, Pekka Enberg wrote:

> On Fri, 8 May 2009, Pekka Enberg wrote:
> > > +#define GFP_PANIC	(__GFP_NOFAIL | __GFP_NORETRY | __GFP_NOMEMALLOC)
>
> On Fri, 2009-05-08 at 10:20 -0400, Christoph Lameter wrote:
> > So this means not retrying the allocation a couple of times? Not delving
> > into reserve pools? Such behavior is good for a allocation that causes a
> > panic if it fails?
>
> If you do GFP_KERNEL|GFP_PANIC, we will cond_resched() and retry if we
> made some progress. So yes, I think the behavior is good for early-boot
> call-sites that can't really fail anyway.

Better make sure that GFP_PANIC is only used during early boot then.

If memory is low on boot (due to node hotplug or some such thing, powerpc
may do evil tricks here) then the panic may trigger after the patch.
We would have just delved into the reserves a bit before.

