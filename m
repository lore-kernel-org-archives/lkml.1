Return-Path: <linux-kernel-owner+w=401wt.eu-S1753119AbXCTTlr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753119AbXCTTlr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 15:41:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752864AbXCTTlr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 15:41:47 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:44184 "EHLO
	netops-testserver-3.corp.sgi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753119AbXCTTlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 15:41:45 -0400
Date: Tue, 20 Mar 2007 12:41:44 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-mm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [QUICKLIST 1/5] Quicklists for page table pages V3
In-Reply-To: <20070319173218.24219a4a.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0703201236110.8729@schroedinger.engr.sgi.com>
References: <20070319233716.13775.45569.sendpatchset@schroedinger.engr.sgi.com>
 <20070319165329.b5830789.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0703191655190.13879@schroedinger.engr.sgi.com>
 <20070319170741.5a24af4c.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0703191718220.13927@schroedinger.engr.sgi.com>
 <20070319175524.812b2f5d.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0703191756060.389@schroedinger.engr.sgi.com>
 <20070319173218.24219a4a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Mar 2007, Andrew Morton wrote:

> Yes, a common quicklist implementation is good.  But no quicklist
> implementation at all is better.  You say that will be slower, and you may
> well be right, but I say let's demonstrate that (please) rather than
> speculating.

There are at least 3 arches already using this scheme there is no 
speculation here. The slab use in i386 is for exactly the same purpose. 
There is nothing new here. It consolidates code and fixes the page struct 
use conflict between slab and arch code. The conflict is the main reason 
why I want this. That way I will not have the special casing in SLUB and 
we can make SLAB support debugging for all slab caches.
 
> > Its obvious that this is right. And there has been significant work 
> > invested into retaining page table pages on i386, sparc64 and ia64 for 
> > exactly the specified.
> 
> I believe that work predated per-cpu-pages.

Lots of arch code depends on page table pages being in a known state for 
reuse this is nothing new. 

> > Ok great idea but what does this have to do with this patch? This patch 
> > simply generalizes something that has been there for ages.
> 
> It has a lot to do with this patch.
> 
> If we decide that it is useful to optimise the full-mm teardown case then
> we will need to zero these pages when we start to use them so we might as
> well get them straight from the page allocator.  Hence this patch goes into
> the bitbucket.

If you decide to optimise the full-mm teardown then you will have to 
rework more than half of the arch handling of page table pages since they 
all rely on pages being zero on return.

> It is not pie-in-the-sky to ask "is this code still useful?".

Yes it is if its a funky idea without code or any data to support a major 
change in the way we handle page table pages. And this falls into that 
category.


