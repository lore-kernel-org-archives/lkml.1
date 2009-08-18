Return-Path: <linux-kernel-owner+w=401wt.eu-S1759392AbZHRR43@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759392AbZHRR43 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 13:56:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758833AbZHRR43
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 13:56:29 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:49197 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758794AbZHRR42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 13:56:28 -0400
Date: Tue, 18 Aug 2009 13:56:22 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Mel Gorman <mel@csn.ul.ie>
cc: Linux Memory Management List <linux-mm@kvack.org>,
       Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] page-allocator: Move pcp static fields for high and
 batch off-pcp and onto the zone
In-Reply-To: <20090818164216.GA13435@csn.ul.ie>
Message-ID: <alpine.DEB.1.10.0908181355490.3840@gentwo.org>
References: <1250594162-17322-1-git-send-email-mel@csn.ul.ie> <1250594162-17322-4-git-send-email-mel@csn.ul.ie> <alpine.DEB.1.10.0908181015420.32284@gentwo.org> <20090818164216.GA13435@csn.ul.ie>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Aug 2009, Mel Gorman wrote:

> On Tue, Aug 18, 2009 at 10:18:48AM -0400, Christoph Lameter wrote:
> >
> > This will increase the cache footprint for the hot code path. Could these
> > new variable be moved next to zone fields that are already in use there?
> > The pageset array is used f.e.
> >
>
> pageset is ____cacheline_aligned_in_smp so putting pcp->high/batch near
> it won't help in terms of cache footprint. This is why I located it near
> watermarks because it's known they'll be needed at roughly the same time
> pcp->high/batch would be normally accessed.

watermarks are not accessed from the hot code path in free_hot_cold page.
