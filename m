Return-Path: <linux-kernel-owner+w=401wt.eu-S1755339AbXD3PGK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755339AbXD3PGK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 11:06:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755340AbXD3PGJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 11:06:09 -0400
Received: from atlrel9.hp.com ([156.153.255.214]:36134 "EHLO atlrel9.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755339AbXD3PGG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 11:06:06 -0400
Subject: Re: [PATCH] change global zonelist order on NUMA v2
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, ak@suse.de,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       akpm@linux-foundation.org
In-Reply-To: <Pine.LNX.4.64.0704261824340.23914@schroedinger.engr.sgi.com>
References: <20070426183417.058f6f9e.kamezawa.hiroyu@jp.fujitsu.com>
	 <200704261147.44413.ak@suse.de>
	 <20070426191043.df96c114.kamezawa.hiroyu@jp.fujitsu.com>
	 <Pine.LNX.4.64.0704260846590.1382@schroedinger.engr.sgi.com>
	 <20070427092736.d0626a30.kamezawa.hiroyu@jp.fujitsu.com>
	 <Pine.LNX.4.64.0704261824340.23914@schroedinger.engr.sgi.com>
Content-Type: text/plain
Organization: HP/OSLO
Date: Mon, 30 Apr 2007 11:03:06 -0400
Message-Id: <1177945387.5623.21.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-04-26 at 18:25 -0700, Christoph Lameter wrote:
> On Fri, 27 Apr 2007, KAMEZAWA Hiroyuki wrote:
> 
> > > DMA memory.
> > > 
> > It seems a bit complicated. If we do so, following can occur,
> > 
> > Node1: cpu0,1,2,3
> > Node0: cpu4,5,6,7
> 
> We were discussing a two node NUMA system. If you have more put it onto 
> the last.

Doesn't this [renumbering nodes] just move the problem to that "last"
node?  I.e., when one attempts to allocate normal memory from the last
node, it will overflow to the DMA zone.  What we need is for and DMA[32]
zone[s] to be last in [or excluded from?] the Normal/Movable/High/...
zonelist for each node.  That is what Kame's patch does.

Lee


