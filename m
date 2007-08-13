Return-Path: <linux-kernel-owner+w=401wt.eu-S1762729AbXHMWxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762729AbXHMWxS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 18:53:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753578AbXHMWw4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 18:52:56 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:53655 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751117AbXHMWwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 18:52:55 -0400
Date: Mon, 13 Aug 2007 15:52:54 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andi Kleen <ak@suse.de>
cc: Mel Gorman <mel@skynet.ie>, Lee.Schermerhorn@hp.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 3/4] Embed zone_id information within the zonelist->zones
 pointer
In-Reply-To: <20070813234217.GI3406@bingen.suse.de>
Message-ID: <Pine.LNX.4.64.0708131550100.30626@schroedinger.engr.sgi.com>
References: <200708102013.49170.ak@suse.de> <Pine.LNX.4.64.0708101201240.17549@schroedinger.engr.sgi.com>
 <200708110304.55433.ak@suse.de> <Pine.LNX.4.64.0708131423050.28026@schroedinger.engr.sgi.com>
 <20070813225020.GE3406@bingen.suse.de> <Pine.LNX.4.64.0708131457190.28445@schroedinger.engr.sgi.com>
 <20070813225841.GG3406@bingen.suse.de> <Pine.LNX.4.64.0708131506030.28502@schroedinger.engr.sgi.com>
 <20070813230801.GH3406@bingen.suse.de> <Pine.LNX.4.64.0708131518320.28626@schroedinger.engr.sgi.com>
 <20070813234217.GI3406@bingen.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Aug 2007, Andi Kleen wrote:

> > I am not sure what you mean by that. Ia64 ZONE_DMA == x86_84 ZONE_DMA32?
> 
> Hmm, when I wrote GFP_DMA32 it was a #define GFP_DMA32 GFP_DMA 
> on ia64 so that drivers not need to ifdef.  Someone nasty
> seems to have removed that too. I guess it would be best
> to readd.

What would be the point?

> But then it wouldn't make sense to have GFP_DMA on ia64 and GFP_DMA32
> on x86. Since driver writers are more likely to test on x86
> I would recommend ia64 having compatible semantics. It'll
> save everybody trouble long term. This means it wouldn't 
> help on IA64 machines that don't have a DMA zone -- they
> would still need to validate drivers especially -- but at least
> the others.

There are no compatible semantics. ZONE_DMA may mean something different 
for each arch depending on its need. An arch may not have a need for a 4GB 
boundary (such as s390).

> Also from my driver review driver authors often seem to have
> trouble understanding what GFP_DMA really does. With GFP_DMA32 it 
> is clearer that it applies to a address range and is not
> some synonym for pci_map_*

GFP_DMA32 is clear because there are no other arches to muddy up the 
waters.

