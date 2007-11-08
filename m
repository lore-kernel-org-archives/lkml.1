Return-Path: <linux-kernel-owner+w=401wt.eu-S1762735AbXKHTsD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762735AbXKHTsD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 14:48:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761514AbXKHTry
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 14:47:54 -0500
Received: from waste.org ([66.93.16.53]:46317 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761497AbXKHTrx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 14:47:53 -0500
Date: Thu, 8 Nov 2007 13:47:35 -0600
From: Matt Mackall <mpm@selenic.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Mel Gorman <mel@skynet.ie>, akpm@linux-foundatin.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch 02/23] SLUB: Rename NUMA defrag_ratio to remote_node_defrag_ratio
Message-ID: <20071108194735.GW19691@waste.org>
References: <20071107011130.382244340@sgi.com> <20071107011226.844437184@sgi.com> <20071108145044.GB2591@skynet.ie> <20071108172548.GW17536@waste.org> <Pine.LNX.4.64.0711081116060.9279@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0711081116060.9279@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 08, 2007 at 11:16:33AM -0800, Christoph Lameter wrote:
> On Thu, 8 Nov 2007, Matt Mackall wrote:
> 
> > > I cannot figure out what the number of cycles currently showing on the TSC
> > > have to do with a ratio :(. I could semi-understand if we were counting up
> > > how many cycles were being spent trying to pack objects but that does not
> > > appear to be the case. The comment didn't help a whole lot either. It felt
> > > like a cost for packing, not a ratio
> > 
> > It's just a random number generator. And a bad one: lots of arches
> > return 0. And I believe at least one of them has some NUMA support.
> 
> Do we have a better one? Something with minimal processing overhead? I'd 
> be glad to switch it.

Not really. drivers/char/random.c does:

__get_cpu_var(trickle_count)++ & 0xfff

for a similar purpose.

-- 
Mathematics is the supreme nostalgia of our time.
