Return-Path: <linux-kernel-owner+w=401wt.eu-S937424AbXHMXZi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937424AbXHMXZi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 19:25:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756404AbXHMXZZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 19:25:25 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:51430 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751323AbXHMXZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 19:25:24 -0400
Date: Mon, 13 Aug 2007 16:25:23 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andi Kleen <ak@suse.de>
cc: Mel Gorman <mel@skynet.ie>, Lee.Schermerhorn@hp.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 3/4] Embed zone_id information within the zonelist->zones
 pointer
In-Reply-To: <20070814001624.GO3406@bingen.suse.de>
Message-ID: <Pine.LNX.4.64.0708131622380.19910@schroedinger.engr.sgi.com>
References: <20070813225020.GE3406@bingen.suse.de>
 <Pine.LNX.4.64.0708131457190.28445@schroedinger.engr.sgi.com>
 <20070813225841.GG3406@bingen.suse.de> <Pine.LNX.4.64.0708131506030.28502@schroedinger.engr.sgi.com>
 <20070813230801.GH3406@bingen.suse.de> <Pine.LNX.4.64.0708131518320.28626@schroedinger.engr.sgi.com>
 <20070813234217.GI3406@bingen.suse.de> <Pine.LNX.4.64.0708131550100.30626@schroedinger.engr.sgi.com>
 <20070813235518.GK3406@bingen.suse.de> <Pine.LNX.4.64.0708131611001.19910@schroedinger.engr.sgi.com>
 <20070814001624.GO3406@bingen.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Aug 2007, Andi Kleen wrote:

> > But they use GFP_DMA right now and drivers cannot use DMA32 if they want 
> 
> The way it was originally designed was that they use GFP_DMA32,
> which would map to itself on x86-64, to GFP_DMA on ia64 and to
> GFP_KERNEL on i386. Unfortunately that seems to have bitrotted
> (perhaps I should have better documented it) 

The DMA boundaries are hardware depending. A 4GB boundary 
may not make sense on certain platforms. 

> > to be cross platforms compatible? Doesnt the dma API completely do away 
> > with these things?
> 
> No GFP_DMA32 in my current plan is still there.

AFAIK GFP_DMA32 is a x86_64 special that would be easy to remove. Dealing 
with physical boundaries is current done via the dma interface right? Lets 
keep it there?

