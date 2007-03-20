Return-Path: <linux-kernel-owner+w=401wt.eu-S934078AbXCTVcZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934078AbXCTVcZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 17:32:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934080AbXCTVcZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 17:32:25 -0400
Received: from one.firstfloor.org ([213.235.205.2]:50834 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934078AbXCTVcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 17:32:24 -0400
Date: Tue, 20 Mar 2007 22:32:18 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Christoph Lameter <christoph@lameter.com>
Cc: Eric Dumazet <dada1@cosmosbay.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] SLAB : NUMA cache_free_alien() very expensive because of virt_to_slab(objp); nodeid = slabp->nodeid;
Message-ID: <20070320213218.GA13952@one.firstfloor.org>
References: <20070320181235.77d28864.dada1@cosmosbay.com> <Pine.LNX.4.64.0703201248530.12664@graphe.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0703201248530.12664@graphe.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > Is it possible virt_to_slab(objp)->nodeid being different from pfn_to_nid(objp) ?
> 
> It is possible the page allocator falls back to another node than 
> requested. We would need to check that this never occurs.

The only way to ensure that would be to set a strict mempolicy.
But I'm not sure that's a good idea -- after all you don't want
to fail an allocation in this case.

But pfn_to_nid on the object like proposed by Eric should work anyways.
But I'm not sure the tables used for that will be more often cache hot
than the slab.

-Andi
