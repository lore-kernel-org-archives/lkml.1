Return-Path: <linux-kernel-owner+w=401wt.eu-S1759076AbYEVQwf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759076AbYEVQwf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 12:52:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758192AbYEVQvY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 12:51:24 -0400
Received: from relay1.sgi.com ([192.48.171.29]:33385 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757874AbYEVQvW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 12:51:22 -0400
Date: Thu, 22 May 2008 09:51:21 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Matt Mackall <mpm@selenic.com>, Paul Mundt <lethal@linux-sh.org>,
       linux-kernel@vger.kernel.org, dhowells@redhat.com
Subject: Re: [RFC/PATCH 1/3] SLAB: Add PageSlab checking to ksize()
In-Reply-To: <84144f020805220913g344baedaqb0996adecdadae99@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0805220950390.27587@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0805212124250.22291@sbz-30.cs.Helsinki.FI> 
 <20080521234555.GB32707@linux-sh.org>  <4834F2E2.3070806@cs.helsinki.fi> 
 <Pine.LNX.4.64.0805212116260.19431@schroedinger.engr.sgi.com> 
 <4834F4DC.3040009@cs.helsinki.fi> <20080522043410.GA4050@linux-sh.org> 
 <4834F9D6.7080706@cs.helsinki.fi> <1211468502.18026.350.camel@calx>
 <84144f020805220913g344baedaqb0996adecdadae99@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 May 2008, Pekka Enberg wrote:

> Hi Matt,
> 
> On Thu, May 22, 2008 at 6:01 PM, Matt Mackall <mpm@selenic.com> wrote:
> > As I've said several times, ksize() on kmem_cache_alloced objects
> > -cannot work- on SLOB. Calling ksize() on something returned by
> > kmem_cache_alloc is a categorical error.
> 
> Well, it's a historical fact that ksize() worked for both kmalloc()
> and kmem_cache_alloc() (see the kernedoc comment in mm/slab.c).
> However, I think we should just look at getting rid of ksize()
> altogether as it's only (ab)used by the nommu code and few call-sites
> that open-code krealloc().

Good idea. if krealloc is an allocator internal function then it can 
establish the size as needed and we do not have ksize available.


