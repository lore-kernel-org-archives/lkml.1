Return-Path: <linux-kernel-owner+w=401wt.eu-S1753573AbYEVPBt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753573AbYEVPBt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 11:01:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752349AbYEVPBj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 11:01:39 -0400
Received: from waste.org ([66.93.16.53]:47177 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752259AbYEVPBi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 11:01:38 -0400
Subject: Re: [RFC/PATCH 1/3] SLAB: Add PageSlab checking to ksize()
From: Matt Mackall <mpm@selenic.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Paul Mundt <lethal@linux-sh.org>, Christoph Lameter <clameter@sgi.com>,
       linux-kernel@vger.kernel.org, dhowells@redhat.com
In-Reply-To: <4834F9D6.7080706@cs.helsinki.fi>
References: <Pine.LNX.4.64.0805212124250.22291@sbz-30.cs.Helsinki.FI>
	 <20080521234555.GB32707@linux-sh.org> <4834F2E2.3070806@cs.helsinki.fi>
	 <Pine.LNX.4.64.0805212116260.19431@schroedinger.engr.sgi.com>
	 <4834F4DC.3040009@cs.helsinki.fi> <20080522043410.GA4050@linux-sh.org>
	 <4834F9D6.7080706@cs.helsinki.fi>
Content-Type: text/plain
Date: Thu, 22 May 2008 10:01:42 -0500
Message-Id: <1211468502.18026.350.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-05-22 at 07:43 +0300, Pekka Enberg wrote:
> Hi Paul,
> 
> Paul Mundt wrote:
> > Shouldn't SLOB's PageSlab usage should mimic that of SLUB in this case
> > instead? PG_slab doesn't buy us much if we can already sort out the size
> > through compound_order(), it's the kmem_cache_alloc() and <= PAGE_SIZE
> > kmalloc()'s where __GFP_COMP isn't true and where PG_slab should be set.
> 
> Well, we should really be calling ksize() in the nommu case and although 
> Matt and Christoph don't seem to agree with me here, I'd much rather 
> have *all* allocators set PageSlab for all the pages they return (yes, 
> including pass-through ones) to get us back where we were with SLAB. We 
> currently don't have any means to see whether an arbitrary page is part 
> of the slab or not and I'd argue that's PageSlab is an established API 
> (that makes sense).
> 
> Furthermore, if ksize() in SLOB doesn't work for kmem_cache_alloc() 
> pages, I think it should be fixed as well.

As I've said several times, ksize() on kmem_cache_alloced objects
-cannot work- on SLOB. Calling ksize() on something returned by
kmem_cache_alloc is a categorical error.

-- 
Mathematics is the supreme nostalgia of our time.

