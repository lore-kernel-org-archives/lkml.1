Return-Path: <linux-kernel-owner+w=401wt.eu-S932240AbXA2Vyv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932240AbXA2Vyv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 16:54:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932662AbXA2Vyv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 16:54:51 -0500
Received: from omx2-ext.sgi.com ([192.48.171.19]:48087 "EHLO omx2.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932472AbXA2Vyt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 16:54:49 -0500
Date: Mon, 29 Jan 2007 13:54:38 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
To: Andrew Morton <akpm@osdl.org>
cc: Mel Gorman <mel@csn.ul.ie>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Christoph Lameter <clameter@engr.sgi.com>
Subject: Re: [PATCH 0/8] Create ZONE_MOVABLE to partition memory between
 movable and non-movable pages
In-Reply-To: <20070126122747.dde74c97.akpm@osdl.org>
Message-ID: <Pine.LNX.4.64.0701291349450.548@schroedinger.engr.sgi.com>
References: <20070125234458.28809.5412.sendpatchset@skynet.skynet.ie>
 <20070126030753.03529e7a.akpm@osdl.org> <Pine.LNX.4.64.0701260751230.6141@schroedinger.engr.sgi.com>
 <20070126114615.5aa9e213.akpm@osdl.org> <Pine.LNX.4.64.0701261147300.15394@schroedinger.engr.sgi.com>
 <20070126122747.dde74c97.akpm@osdl.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Jan 2007, Andrew Morton wrote:

> > The main benefit is a significant simplification of the VM, leading to 
> > robust and reliable operations and a reduction of the maintenance 
> > headaches coming with the additional zones.
> > 
> > If we would introduce the ability of allocating from a range of 
> > physical addresses then the need for DMA zones would go away allowing 
> > flexibility for device driver DMA allocations and at the same time we get 
> > rid of special casing in the VM.
> 
> None of this is valid.  The great majority of machines out there will
> continue to have the same number of zones.  Nothing changes.

All 64 bit machine will only have a single zone if we have such a range 
alloc mechanism. The 32bit ones with HIGHMEM wont be able to avoid it, 
true. But all arches that do not need gymnastics to access their memory 
will be able run with a single zone.
 
> That's all a real cost, so we need to see *good* benefits to outweigh that
> cost.  Thus far I don't think we've seen that.

The real savings is the simplicity of VM design, robustness and 
efficiency. We loose on all these fronts if we keep or add useless zones. 

The main reason for the recent problems with dirty handling seem to be due 
to exactly such a multizone balancing issues involving ZONE_NORMAL and 
HIGHMEM. Those problems cannot occur on single ZONE arches (this means 
right now on a series of embedded arches, UML and IA64). 

Multiple ZONES are a recipie for VM fragility and result in complexity 
that is difficult to manage.
