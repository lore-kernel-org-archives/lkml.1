Return-Path: <linux-kernel-owner+w=401wt.eu-S1759364AbZHRQmP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759364AbZHRQmP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 12:42:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759209AbZHRQmO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 12:42:14 -0400
Received: from gir.skynet.ie ([193.1.99.77]:53262 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759201AbZHRQmO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 12:42:14 -0400
Date: Tue, 18 Aug 2009 17:42:17 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
       Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] page-allocator: Move pcp static fields for high
	and batch off-pcp and onto the zone
Message-ID: <20090818164216.GA13435@csn.ul.ie>
References: <1250594162-17322-1-git-send-email-mel@csn.ul.ie> <1250594162-17322-4-git-send-email-mel@csn.ul.ie> <alpine.DEB.1.10.0908181015420.32284@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0908181015420.32284@gentwo.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 18, 2009 at 10:18:48AM -0400, Christoph Lameter wrote:
> 
> This will increase the cache footprint for the hot code path. Could these
> new variable be moved next to zone fields that are already in use there?
> The pageset array is used f.e.
> 

pageset is ____cacheline_aligned_in_smp so putting pcp->high/batch near
it won't help in terms of cache footprint. This is why I located it near
watermarks because it's known they'll be needed at roughly the same time
pcp->high/batch would be normally accessed.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
