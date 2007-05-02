Return-Path: <linux-kernel-owner+w=401wt.eu-S1767148AbXEBS22@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767148AbXEBS22 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 14:28:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767151AbXEBS22
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 14:28:28 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:60514 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1767148AbXEBS21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 14:28:27 -0400
Date: Wed, 2 May 2007 11:28:26 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Hugh Dickins <hugh@veritas.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: 2.6.22 -mm merge plans: slub
In-Reply-To: <Pine.LNX.4.64.0705021903320.20615@blonde.wat.veritas.com>
Message-ID: <Pine.LNX.4.64.0705021124040.646@schroedinger.engr.sgi.com>
References: <20070430162007.ad46e153.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0705011846590.10660@blonde.wat.veritas.com>
 <20070501125559.9ab42896.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0705012101410.26170@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0705011403470.26819@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0705021330001.16517@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0705020955550.32271@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0705021903320.20615@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 May 2007, Hugh Dickins wrote:

> On Wed, 2 May 2007, Christoph Lameter wrote:
> > 
> > But these are arch specific problems. We could use 
> > ARCH_USES_SLAB_PAGE_STRUCT to disable SLUB on these platforms.
> 
> As a quick hack, sure.  But every ARCH_USES_SLAB_PAGE_STRUCT
> diminishes the testing SLUB will get.  If the idea is that we're
> going to support both SLAB and SLUB, some arches with one, some
> with another, some with either, for more than a single release,
> then I'm back to saying SLUB is being pushed in too early.
> I can understand people wanting pluggable schedulers,
> but pluggable slab allocators?

This is a sensitive piece of the kernel as you say and we better allow the 
running of two allocator for some time to make sure that it behaves in all 
load situations. The design is fundamentally different so its performance 
characteristics may diverge significantly and perhaps there will be corner 
cases for each where they do the best job.

I have already reworked the slab API to allow for an easy implementation 
of alternate slab allocators (released with 2.6.20) which only covered 
SLAB and SLOB. This is continuing the cleanup work and adding a third one.


