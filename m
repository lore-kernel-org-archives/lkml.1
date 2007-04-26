Return-Path: <linux-kernel-owner+w=401wt.eu-S1752264AbXDZQgm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752264AbXDZQgm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 12:36:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754811AbXDZQgm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 12:36:42 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:45646 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752264AbXDZQgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 12:36:41 -0400
Date: Thu, 26 Apr 2007 09:36:40 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, ak@suse.de,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       akpm@linux-foundation.org, Eric Whitney <eric.whitney@hp.com>
Subject: Re: [PATCH] change global zonelist order on NUMA v3
In-Reply-To: <1177604962.5705.55.camel@localhost>
Message-ID: <Pine.LNX.4.64.0704260934430.22248@schroedinger.engr.sgi.com>
References: <20070426183417.058f6f9e.kamezawa.hiroyu@jp.fujitsu.com> 
 <200704261147.44413.ak@suse.de>  <20070426191043.df96c114.kamezawa.hiroyu@jp.fujitsu.com>
  <20070426195348.6a4e5652.kamezawa.hiroyu@jp.fujitsu.com> 
 <1177603203.5705.36.camel@localhost>  <Pine.LNX.4.64.0704260904190.1655@schroedinger.engr.sgi.com>
 <1177604962.5705.55.camel@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Apr 2007, Lee Schermerhorn wrote:

> I have been considering an HP-platform-specific boot option [handled by
> a new ia64 machine vec op] to re-distance the interleaved node, but for
> other platforms, such as Kame's, I think we still need the ability to
> move the DMA zones last in the Normal zone lists.  Or, exclude them
> altogether?

Maybe a solution would be to have a dma_penalty option on boot? The dma 
penalty is added to the dma zone. If its higher than zero then the dma 
zone will become a node at that distance to other nodes.

The default is zero which would leave it as is.

If you boot with

	dma_penalty=40

then a new slit entry is generated for the DMA zone and its put at that 
distance.

