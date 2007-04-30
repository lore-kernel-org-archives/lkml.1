Return-Path: <linux-kernel-owner+w=401wt.eu-S1755288AbXD3OKh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755288AbXD3OKh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 10:10:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755293AbXD3OKh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 10:10:37 -0400
Received: from atlrel6.hp.com ([156.153.255.205]:59705 "EHLO atlrel6.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755288AbXD3OKD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 10:10:03 -0400
Subject: Re: [PATCH] change global zonelist order on NUMA v2
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Christoph Lameter <clameter@sgi.com>, ak@suse.de,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       akpm@linux-foundation.org, mike.stroyan@hp.com
In-Reply-To: <20070427092736.d0626a30.kamezawa.hiroyu@jp.fujitsu.com>
References: <20070426183417.058f6f9e.kamezawa.hiroyu@jp.fujitsu.com>
	 <200704261147.44413.ak@suse.de>
	 <20070426191043.df96c114.kamezawa.hiroyu@jp.fujitsu.com>
	 <Pine.LNX.4.64.0704260846590.1382@schroedinger.engr.sgi.com>
	 <20070427092736.d0626a30.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain
Organization: HP/OSLO
Date: Mon, 30 Apr 2007 10:09:48 -0400
Message-Id: <1177942188.5623.8.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-04-27 at 09:27 +0900, KAMEZAWA Hiroyuki wrote:
> On Thu, 26 Apr 2007 08:48:19 -0700 (PDT)
> Christoph Lameter <clameter@sgi.com> wrote:
> 
> > On Thu, 26 Apr 2007, KAMEZAWA Hiroyuki wrote:
> > 
> > > (1)Use new zonelist ordering always and move init_task's tied cpu to a
> > >   cpu on the best node. 
> > >   Child processes will start in good nodes even if Node 0 has small memory.
> > 
> > How about renumbering the nodes? Node 0 is the one with no DMA memory and 
> > node 1 may be the one with the DMA? That would take care of things even 
> > without core modifications. We can start on node 0 (which hardware 1) and 
> > consume the required memory for boot there not impacting the node with the 
> > DMA memory.
> > 
> It seems a bit complicated. If we do so, following can occur,
> 
> Node1: cpu0,1,2,3
> Node0: cpu4,5,6,7
> 
> the system layout will be not imaginable look, maybe.

Interesting.  A colleague recently showed me that this can occur on HP
platforms if we boot from, say, node 1 instead of node 0.  The kernel
doesn't mind because it maintains a translation of cpus to nodes and
vice versa.  Applications don't need to mind if they use libnuma's
numa_node_to_cpus(), rather than assume a fixed relationship.  But, I
agree, that it may surprise some people when/if node_id !=
cpu_id/cpus_per_node.

Lee

