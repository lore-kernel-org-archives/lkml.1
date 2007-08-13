Return-Path: <linux-kernel-owner+w=401wt.eu-S934772AbXHMVZ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934772AbXHMVZ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 17:25:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754258AbXHMVZj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 17:25:39 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:49099 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752713AbXHMVZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 17:25:37 -0400
Date: Mon, 13 Aug 2007 14:25:36 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andi Kleen <ak@suse.de>
cc: Mel Gorman <mel@skynet.ie>, Lee.Schermerhorn@hp.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 3/4] Embed zone_id information within the zonelist->zones
 pointer
In-Reply-To: <200708110304.55433.ak@suse.de>
Message-ID: <Pine.LNX.4.64.0708131423050.28026@schroedinger.engr.sgi.com>
References: <20070809210616.14702.73376.sendpatchset@skynet.skynet.ie>
 <200708102013.49170.ak@suse.de> <Pine.LNX.4.64.0708101201240.17549@schroedinger.engr.sgi.com>
 <200708110304.55433.ak@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 11 Aug 2007, Andi Kleen wrote:

> > Hallelujah. You are my hero! x86_64 will switch off CONFIG_ZONE_DMA?
> 
> Yes. i386 too actually.
> 
> The DMA zone will be still there, but only reachable with special functions.

Not too happy with that one but this is going the right direcrtion.

On NUMA this would still mean allocating space for the DMA zone on all 
nodes although we only need this on node 0.

> Also all callers are going to pass masks around so it's always clear
> what address range they really need. Actually a lot of them
> pass still 16MB simply because it is hard to find out what masks
> old undocumented hardware really needs. But this could change.

Good.

> This also means the DMA support in sl[a-z]b is not needed anymore.

Tell me when. SLUB has an #ifdef CONFIG_ZONE_DMA. We can just drop that 
code in the #ifdef's if you are ready.

> I went through near all GFP_DMA users and found they're usually
> happy enough with pages. If someone comes up who really needs
> lots of subobjects the right way for them would be likely extending
> the pci pool allocator for this case. But I haven't found a need for this yet.

Great.
