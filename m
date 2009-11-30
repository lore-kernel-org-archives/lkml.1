Return-Path: <linux-kernel-owner+w=401wt.eu-S1753872AbZK3XOa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753872AbZK3XOa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 18:14:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753836AbZK3XOZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 18:14:25 -0500
Received: from smtp-out.google.com ([216.239.45.13]:3667 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753395AbZK3XOZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 18:14:25 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=ICg0adGDCp5fK4I2Ref5GgIHRuSiqTKS1T45R0kcxzNON73a8xMRYdNLMVCT18ti8
	L342nhVi6eL4LpMMJQ9TQ==
Date: Mon, 30 Nov 2009 15:14:22 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Christoph Lameter <cl@linux-foundation.org>
cc: Matt Mackall <mpm@selenic.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Peter Zijlstra <peterz@infradead.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Nick Piggin <npiggin@suse.de>
Subject: Re: lockdep complaints in slab allocator
In-Reply-To: <alpine.DEB.2.00.0911271127130.20368@router.home>
Message-ID: <alpine.DEB.2.00.0911301512250.12038@chino.kir.corp.google.com>
References: <84144f020911192249l6c7fa495t1a05294c8f5b6ac8@mail.gmail.com> <1258729748.4104.223.camel@laptop> <1259002800.5630.1.camel@penberg-laptop> <1259003425.17871.328.camel@calx> <4B0ADEF5.9040001@cs.helsinki.fi> <1259080406.4531.1645.camel@laptop>
 <20091124170032.GC6831@linux.vnet.ibm.com> <1259082756.17871.607.camel@calx> <1259086459.4531.1752.camel@laptop> <1259090615.17871.696.camel@calx> <84144f020911241307u14cd2cf0h614827137e42378e@mail.gmail.com> <1259103315.17871.895.camel@calx>
 <alpine.DEB.2.00.0911251356130.11347@chino.kir.corp.google.com> <alpine.DEB.2.00.0911271127130.20368@router.home>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Nov 2009, Christoph Lameter wrote:

> > > I'm afraid I have only anecdotal reports from SLOB users, and embedded
> > > folks are notorious for lack of feedback, but I only need a few people
> > > to tell me they're shipping 100k units/mo to be confident that SLOB is
> > > in use in millions of devices.
> > >
> >
> > It's much more popular than I had expected; do you think it would be
> > possible to merge slob's core into another allocator or will it require
> > seperation forever?
> 
> It would be possible to create a slab-common.c and isolate common handling
> of all allocators. SLUB and SLQB share quite a lot of code and SLAB could
> be cleaned up and made to fit into such a framework.
> 

Right, but the user is still left with a decision of which slab allocator 
to compile into their kernel, each with distinct advantages and 
disadvantages that get exploited for the wide range of workloads that it 
runs.  If slob could be merged into another allocator, it would be simple 
to remove the distinction of it being seperate altogether, the differences 
would depend on CONFIG_EMBEDDED instead.
