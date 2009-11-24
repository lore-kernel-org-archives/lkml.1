Return-Path: <linux-kernel-owner+w=401wt.eu-S933490AbZKXQdk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933490AbZKXQdk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 11:33:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933481AbZKXQdj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 11:33:39 -0500
Received: from casper.infradead.org ([85.118.1.10]:44894 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933331AbZKXQde (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 11:33:34 -0500
Subject: Re: lockdep complaints in slab allocator
From: Peter Zijlstra <peterz@infradead.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Matt Mackall <mpm@selenic.com>, paulmck@linux.vnet.ibm.com,
       linux-mm@kvack.org, cl@linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>, Nick Piggin <npiggin@suse.de>
In-Reply-To: <4B0ADEF5.9040001@cs.helsinki.fi>
References: <20091118181202.GA12180@linux.vnet.ibm.com>
	 <84144f020911192249l6c7fa495t1a05294c8f5b6ac8@mail.gmail.com>
	 <1258709153.11284.429.camel@laptop>
	 <84144f020911200238w3d3ecb38k92ca595beee31de5@mail.gmail.com>
	 <1258714328.11284.522.camel@laptop>  <4B067816.6070304@cs.helsinki.fi>
	 <1258729748.4104.223.camel@laptop> <1259002800.5630.1.camel@penberg-laptop>
	 <1259003425.17871.328.camel@calx> <4B0ADEF5.9040001@cs.helsinki.fi>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 24 Nov 2009 17:33:26 +0100
Message-ID: <1259080406.4531.1645.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-11-23 at 21:13 +0200, Pekka Enberg wrote:
> Matt Mackall wrote:
> > This seems like a lot of work to paper over a lockdep false positive in
> > code that should be firmly in the maintenance end of its lifecycle? I'd
> > rather the fix or papering over happen in lockdep.
> 
> True that. Is __raw_spin_lock() out of question, Peter?-) Passing the 
> state is pretty invasive because of the kmem_cache_free() call in 
> slab_destroy(). We re-enter the slab allocator from the outer edges 
> which makes spin_lock_nested() very inconvenient.

I'm perfectly fine with letting the thing be as it is, its apparently
not something that triggers very often, and since slab will be killed
off soon, who cares.

