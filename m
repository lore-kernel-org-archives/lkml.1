Return-Path: <linux-kernel-owner+w=401wt.eu-S1763648AbXGJLF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763648AbXGJLF0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 07:05:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758175AbXGJLFO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 07:05:14 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:42241 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753308AbXGJLFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 07:05:12 -0400
Subject: Re: -mm merge plans -- anti-fragmentation
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Mel Gorman <mel@skynet.ie>
Cc: Andrew Morton <akpm@linux-foundation.org>, npiggin@suse.de,
       kenchen@google.com, jschopp@austin.ibm.com, apw@shadowen.org,
       kamezawa.hiroyu@jp.fujitsu.com, y-goto@jp.fujitsu.com, clameter@sgi.com,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <20070710102043.GA20303@skynet.ie>
References: <20070710102043.GA20303@skynet.ie>
Content-Type: text/plain
Date: Tue, 10 Jul 2007 13:04:05 +0200
Message-Id: <1184065445.5281.16.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-07-10 at 11:20 +0100, Mel Gorman wrote:

<snip>

> > lumpy-reclaim-v4.patch
> 
> This patch is really what lumpy reclaim is. I believe Peter has looked
> at this and was happy enough at the time although he is cc'd here again
> in case this has changed. This is mainly useful with either grouping
> pages by mobility or the ZONE_MOVABLE stuff. However, at the time the
> patch was proposed, there was a feeling that it might help jumbo frame
> allocation on e1000's and maybe if fsblock optimistically uses
> contiguous pages it would have an application. I would like to see it go
> through to see does it help e1000 at least.

I'm not seeing how this will help e1000 (and other jumbo drivers). They
typically allocate using GFP_ATOMIC, so in order to satisfy those you'd
need to either have a higher order watermark or do atomic defrag of the
free space.


