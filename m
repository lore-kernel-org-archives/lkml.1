Return-Path: <linux-kernel-owner+w=401wt.eu-S935102AbXHNVtM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935102AbXHNVtM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 17:49:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759128AbXHNV0p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 17:26:45 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:47806 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759043AbXHNV0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 17:26:44 -0400
Date: Tue, 14 Aug 2007 14:26:43 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andi Kleen <andi@firstfloor.org>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC 4/9] Atomic reclaim: Save irq flags in vmscan.c
In-Reply-To: <20070814212355.GA23308@one.firstfloor.org>
Message-ID: <Pine.LNX.4.64.0708141425000.31693@schroedinger.engr.sgi.com>
References: <20070814153021.446917377@sgi.com> <20070814153501.766137366@sgi.com>
 <p73vebhnauo.fsf@bingen.suse.de> <Pine.LNX.4.64.0708141209270.29498@schroedinger.engr.sgi.com>
 <20070814203329.GA22202@one.firstfloor.org>
 <Pine.LNX.4.64.0708141341120.31513@schroedinger.engr.sgi.com>
 <20070814204454.GC22202@one.firstfloor.org>
 <Pine.LNX.4.64.0708141414260.31693@schroedinger.engr.sgi.com>
 <20070814212355.GA23308@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Aug 2007, Andi Kleen wrote:

> > So every spinlock would have an array of chars sized to NR_CPUS and set 
> > the flag when the lock is taken?
> 
> I was more thinking of a single per cpu flag for all of page reclaim
> That keeps it also cache local.

We already have such a flag in the zone structure

        /* A count of how many reclaimers are scanning this zone */
        atomic_t                reclaim_in_progress;


The problem is that the LRU lock etc is also taken outside of reclaim. In 
order for the flag to work we would have to set it everywhere the lru lock 
etcis taken.

