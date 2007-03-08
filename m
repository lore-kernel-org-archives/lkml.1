Return-Path: <linux-kernel-owner+w=401wt.eu-S1752617AbXCHSQn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752617AbXCHSQn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 13:16:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752616AbXCHSQn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 13:16:43 -0500
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:48774 "EHLO
	netops-testserver-4.corp.sgi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752614AbXCHSQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 13:16:42 -0500
Date: Thu, 8 Mar 2007 10:16:27 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Mel Gorman <mel@skynet.ie>
cc: akpm@osdl.org, Marcelo Tosatti <marcelo@kvack.org>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, mpm@selenic.com,
       Manfred Spraul <manfred@colorfullife.com>
Subject: Re: [SLUB 0/3] SLUB: The unqueued slab allocator V4
In-Reply-To: <20070308174004.GB12958@skynet.ie>
Message-ID: <Pine.LNX.4.64.0703081013270.27731@schroedinger.engr.sgi.com>
References: <20070307023502.19658.39217.sendpatchset@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0703081022040.1615@skynet.skynet.ie>
 <Pine.LNX.4.64.0703080836300.27191@schroedinger.engr.sgi.com>
 <20070308174004.GB12958@skynet.ie>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Mar 2007, Mel Gorman wrote:

> > Note that the 16kb page size has a major 
> > impact on SLUB performance. On IA64 slub will use only 1/4th the locking 
> > overhead as on 4kb platforms.
> It'll be interesting to see the kernbench tests then with debugging
> disabled.

You can get a similar effect on 4kb platforms by specifying slub_min_order=2 on bootup.
This means that we have to rely on your patches to allow higher order 
allocs to work reliably though. The higher the order of slub the less 
locking overhead. So the better your patches deal with fragmentation the 
more we can reduce locking overhead in slub.

