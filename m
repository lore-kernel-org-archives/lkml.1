Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751352Ab0CIRMh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 12:12:37 -0500
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:58846 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078Ab0CIRMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 12:12:35 -0500
Date: Tue, 9 Mar 2010 11:11:55 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Mel Gorman <mel@csn.ul.ie>
cc: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>, linux-mm@kvack.org,
       Nick Piggin <npiggin@suse.de>, Chris Mason <chris.mason@oracle.com>,
       Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] page-allocator: Under memory pressure, wait on
 pressure to relieve instead of congestion
In-Reply-To: <20100309170123.GG4883@csn.ul.ie>
Message-ID: <alpine.DEB.2.00.1003091109040.28897@router.home>
References: <1268048904-19397-1-git-send-email-mel@csn.ul.ie> <1268048904-19397-2-git-send-email-mel@csn.ul.ie> <alpine.DEB.2.00.1003090946180.28897@router.home> <4B966F93.9060207@linux.vnet.ibm.com> <alpine.DEB.2.00.1003091005310.28897@router.home>
 <20100309170123.GG4883@csn.ul.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Mar 2010, Mel Gorman wrote:

> Until it's timeout at least. It's still better than the current
> situation of sleeping on congestion.

Congestion may clear if memory becomes available in other zones.

> The ideal would be waiting on a per-node basis. I'm just not liking having
> to look up the node structure when freeing a patch of pages and making a
> cache line in there unnecessarily hot.

The node structure (pgdat) contains the zone structures. If you know the
type of zone then you can calculate the pgdat address.

> > But then an overallocated node may stall processes. If that node is full
> > of unreclaimable memory then the process may never wake up?
> Processes wake after a timeout.

Ok that limits it but still we may be waiting for no reason.

