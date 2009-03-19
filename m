Return-Path: <linux-kernel-owner+w=401wt.eu-S1761748AbZCSWmR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761748AbZCSWmR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 18:42:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754092AbZCSWmA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 18:42:00 -0400
Received: from smtp.ultrahosting.com ([74.213.174.254]:56282 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753017AbZCSWl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 18:41:59 -0400
Date: Thu, 19 Mar 2009 18:39:31 -0400 (EDT)
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
In-Reply-To: <20090319220641.GC24586@csn.ul.ie>
Message-ID: <alpine.DEB.1.10.0903191834190.15549@qirst.com>
References: <1237196790-7268-1-git-send-email-mel@csn.ul.ie> <1237196790-7268-21-git-send-email-mel@csn.ul.ie> <alpine.DEB.1.10.0903161207500.32577@qirst.com> <20090316163626.GJ24293@csn.ul.ie> <alpine.DEB.1.10.0903161247170.17730@qirst.com>
 <20090318150833.GC4629@csn.ul.ie> <alpine.DEB.1.10.0903181256440.15570@qirst.com> <20090318180152.GB24462@csn.ul.ie> <alpine.DEB.1.10.0903181508030.10154@qirst.com> <alpine.DEB.1.10.0903191642160.22425@qirst.com> <20090319220641.GC24586@csn.ul.ie>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Mar 2009, Mel Gorman wrote:

> >
> >  extern int nr_node_ids;
> > +extern int nr_online_nodes;
> > +extern int nr_possible_nodes;
>
> Have you tested the nr_possible_nodes aspects  of this patch? I can see
> where it gets initialised but nothing that updates it. It would appear that
> nr_possible_nodes() and num_possible_nodes() can return different values.

Right now we bypass the helper functions.... The only places where the
possible map is modified are:

./arch/x86/mm/numa_64.c:        node_set(0, node_possible_map);
./arch/x86/mm/k8topology_64.c:          node_set(nodeid, node_possible_map);
./arch/x86/mm/srat_64.c:        node_possible_map = nodes_parsed;

