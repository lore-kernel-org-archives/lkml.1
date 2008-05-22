Return-Path: <linux-kernel-owner+w=401wt.eu-S1763690AbYEVE5R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763690AbYEVE5R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 00:57:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752159AbYEVE5A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 00:57:00 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:25515 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751976AbYEVE47 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 00:56:59 -0400
Date: Thu, 22 May 2008 13:55:16 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       mpm@selenic.com, dhowells@redhat.com
Subject: Re: [RFC/PATCH 1/3] SLAB: Add PageSlab checking to ksize()
Message-ID: <20080522045516.GA4248@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Pekka Enberg <penberg@cs.helsinki.fi>,
	Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
	mpm@selenic.com, dhowells@redhat.com
References: <Pine.LNX.4.64.0805212124250.22291@sbz-30.cs.Helsinki.FI> <20080521234555.GB32707@linux-sh.org> <4834F2E2.3070806@cs.helsinki.fi> <Pine.LNX.4.64.0805212116260.19431@schroedinger.engr.sgi.com> <4834F4DC.3040009@cs.helsinki.fi> <20080522043410.GA4050@linux-sh.org> <4834F9D6.7080706@cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4834F9D6.7080706@cs.helsinki.fi>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22, 2008 at 07:43:02AM +0300, Pekka Enberg wrote:
> Paul Mundt wrote:
> >Shouldn't SLOB's PageSlab usage should mimic that of SLUB in this case
> >instead? PG_slab doesn't buy us much if we can already sort out the size
> >through compound_order(), it's the kmem_cache_alloc() and <= PAGE_SIZE
> >kmalloc()'s where __GFP_COMP isn't true and where PG_slab should be set.
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
> 
SLOB's kmem_cache_alloc() pages won't have PageSlab set, so ksize()
will never be called, and we will simply always return PAGE_SIZE from
kobjsize() for those objects, as they don't set __GFP_COMP either.
