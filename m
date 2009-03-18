Return-Path: <linux-kernel-owner+w=401wt.eu-S1759504AbZCRTMn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759504AbZCRTMn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 15:12:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754705AbZCRTMc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 15:12:32 -0400
Received: from smtp.ultrahosting.com ([74.213.174.254]:39692 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754572AbZCRTMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 15:12:31 -0400
Date: Wed, 18 Mar 2009 15:10:19 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@qirst.com
To: Mel Gorman <mel@csn.ul.ie>
cc: Linux Memory Management List <linux-mm@kvack.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Johannes Weiner <hannes@cmpxchg.org>, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 20/35] Use a pre-calculated value for
 num_online_nodes()
In-Reply-To: <20090318180152.GB24462@csn.ul.ie>
Message-ID: <alpine.DEB.1.10.0903181508030.10154@qirst.com>
References: <1237196790-7268-1-git-send-email-mel@csn.ul.ie> <1237196790-7268-21-git-send-email-mel@csn.ul.ie> <alpine.DEB.1.10.0903161207500.32577@qirst.com> <20090316163626.GJ24293@csn.ul.ie> <alpine.DEB.1.10.0903161247170.17730@qirst.com>
 <20090318150833.GC4629@csn.ul.ie> <alpine.DEB.1.10.0903181256440.15570@qirst.com> <20090318180152.GB24462@csn.ul.ie>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Mar 2009, Mel Gorman wrote:

> On Wed, Mar 18, 2009 at 12:58:02PM -0400, Christoph Lameter wrote:
> > On Wed, 18 Mar 2009, Mel Gorman wrote:
> >
> > > Naming has never been great, but in this case the static value is a
> > > direct replacement of num_online_nodes(). I think having a
> > > similarly-named-but-still-different name obscures more than it helps.
> >
> > Creates a weird new name. Please use nr_online_nodes. Its useful elsewhere
> > too.
> >
>
> Ok, I'm dropping this patch for the first pass altogether and will deal
> with it later.

This is important infrastructure stuff. num_online_nodes is used in a
couple of other places where it could be replaced by nr_online_nodes.

7 grufile.c     gru_get_config_info          181 if (num_online_nodes() > 1 &&
8 grufile.c     gru_get_config_info          187 info.nodes = num_online_nodes();
9 hugetlb.c     return_unused_surplus_pages  878 unsigned long remaining_iterations = num_online_nodes();
a hugetlb.c     return_unused_surplus_pages  907 remaining_iterations = num_online_nodes();
b page_alloc.c  MAX_NODE_LOAD               2115 #define MAX_NODE_LOAD (num_online_nodes())
c page_alloc.c  build_zonelists             2324 load = num_online_nodes();
d page_alloc.c  build_all_zonelists         2475 num_online_nodes(),
e slub.c        list_locations              3651 if (num_online_nodes() > 1 && !nodes_empty(l->nodes) &&
f svc.c         svc_pool_map_choose_mode     127 if (num_online_nodes() > 1) {

In other places its avoided because deemed to be too expensive.

