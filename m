Return-Path: <linux-kernel-owner+w=401wt.eu-S1760147AbYEVSbq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760147AbYEVSbq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 14:31:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757229AbYEVSbd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 14:31:33 -0400
Received: from waste.org ([66.93.16.53]:41777 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752124AbYEVSbc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 14:31:32 -0400
Subject: Re: [RFC/PATCH 1/3] SLAB: Add PageSlab checking to ksize()
From: Matt Mackall <mpm@selenic.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Paul Mundt <lethal@linux-sh.org>, Christoph Lameter <clameter@sgi.com>,
       linux-kernel@vger.kernel.org, dhowells@redhat.com
In-Reply-To: <84144f020805220913g344baedaqb0996adecdadae99@mail.gmail.com>
References: <Pine.LNX.4.64.0805212124250.22291@sbz-30.cs.Helsinki.FI>
	 <20080521234555.GB32707@linux-sh.org> <4834F2E2.3070806@cs.helsinki.fi>
	 <Pine.LNX.4.64.0805212116260.19431@schroedinger.engr.sgi.com>
	 <4834F4DC.3040009@cs.helsinki.fi> <20080522043410.GA4050@linux-sh.org>
	 <4834F9D6.7080706@cs.helsinki.fi> <1211468502.18026.350.camel@calx>
	 <84144f020805220913g344baedaqb0996adecdadae99@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 22 May 2008 13:31:56 -0500
Message-Id: <1211481116.18026.360.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-05-22 at 19:13 +0300, Pekka Enberg wrote:
> Hi Matt,
> 
> On Thu, May 22, 2008 at 6:01 PM, Matt Mackall <mpm@selenic.com> wrote:
> > As I've said several times, ksize() on kmem_cache_alloced objects
> > -cannot work- on SLOB. Calling ksize() on something returned by
> > kmem_cache_alloc is a categorical error.
> 
> Well, it's a historical fact that ksize() worked for both kmalloc()
> and kmem_cache_alloc() (see the kernedoc comment in mm/slab.c).

Indeed. It looks like it was in fact introduced for nommu (back in
2.5.47). But much like kfree(kmem_cache_alloc()) is a bogus thing to do,
ksize(kmem_cache_alloc()) is assuming too much about the relationship
between kmalloc and kmem_cache_alloc.

Nommu's accounting code makes two misguided assumptions a) that we can
determine how/whether something was allocated just from a pointer b)
that the size of that object can be determined dynamically in any case
other than kmalloc. But it really shouldn't need to do either of these.

> However, I think we should just look at getting rid of ksize()
> altogether as it's only (ab)used by the nommu code and few call-sites
> that open-code krealloc().

Right.

-- 
Mathematics is the supreme nostalgia of our time.

