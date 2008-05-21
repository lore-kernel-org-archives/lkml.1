Return-Path: <linux-kernel-owner+w=401wt.eu-S937469AbYEUVRK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937469AbYEUVRK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 17:17:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937009AbYEUVQm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 17:16:42 -0400
Received: from relay1.sgi.com ([192.48.171.29]:51851 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S937789AbYEUVQl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 17:16:41 -0400
Date: Wed, 21 May 2008 14:16:40 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org,
       lethal@linux-sh.org, dhowells@redhat.com
Subject: Re: [RFC/PATCH 3/3] SLOB: make ksize() more strict for page allocator
 pass-through
In-Reply-To: <4834905E.9010802@cs.helsinki.fi>
Message-ID: <Pine.LNX.4.64.0805211415420.17915@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0805212125570.22291@sbz-30.cs.Helsinki.FI>
 <1211396840.18026.276.camel@calx> <483473EA.40901@cs.helsinki.fi>
 <Pine.LNX.4.64.0805211411050.17853@schroedinger.engr.sgi.com>
 <4834905E.9010802@cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 May 2008, Pekka Enberg wrote:

> Christoph Lameter wrote:
> > I also would prefer to keep this out of SLUB. Set/Clear PageSlab dirties the
> > cacheline and it forces the unlining of kmalloc_large.
> 
> Hmm, well, that leaves ksize() open for more abuse. I guess we'll just have to
> live with that then.

SLUB could add a BUG_ON(!PageCompound ) since we added buffering for order 
0 allocs. So only order 1 and higher go through kmalloc large. That should 
catch the general case.


