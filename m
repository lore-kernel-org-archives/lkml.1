Return-Path: <linux-kernel-owner+w=401wt.eu-S1161174AbXAZS4r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161174AbXAZS4r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 13:56:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161175AbXAZS4r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 13:56:47 -0500
Received: from zrtps0kn.nortel.com ([47.140.192.55]:47719 "EHLO
	zrtps0kn.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161174AbXAZS4q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 13:56:46 -0500
X-Greylist: delayed 1267 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Jan 2007 13:56:46 EST
Message-ID: <45BA49F2.2000804@nortel.com>
Date: Fri, 26 Jan 2007 12:35:30 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Mel Gorman <mel@csn.ul.ie>
CC: Christoph Lameter <clameter@sgi.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/8] Allow huge page allocations to use GFP_HIGH_MOVABLE
References: <20070125234458.28809.5412.sendpatchset@skynet.skynet.ie> <20070125234558.28809.21103.sendpatchset@skynet.skynet.ie> <Pine.LNX.4.64.0701260832260.6141@schroedinger.engr.sgi.com> <Pine.LNX.4.64.0701261649040.23091@skynet.skynet.ie> <Pine.LNX.4.64.0701260903110.6966@schroedinger.engr.sgi.com> <Pine.LNX.4.64.0701261720120.23091@skynet.skynet.ie> <Pine.LNX.4.64.0701260921310.7301@schroedinger.engr.sgi.com> <Pine.LNX.4.64.0701261727400.23091@skynet.skynet.ie> <Pine.LNX.4.64.0701260944270.7457@schroedinger.engr.sgi.com> <Pine.LNX.4.64.0701261747290.23091@skynet.skynet.ie>
In-Reply-To: <Pine.LNX.4.64.0701261747290.23091@skynet.skynet.ie>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Jan 2007 18:35:35.0098 (UTC) FILETIME=[C47129A0:01C74178]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mel Gorman wrote:

> Worse, the problem is to have high order contiguous blocks free at the 
> time of allocation without reclaim or migration. If the allocations were 
> not atomic, anti-fragmentation as it is today would be enough.

Has anyone looked at marking the buffers as "needs refilling" then kick 
off a kernel thread or something to do the allocations under GFP_KERNEL? 
  That way we avoid having to allocate the buffers with GFP_ATOMIC.

I seem to recall that the tulip driver used to do this.  Is it just too 
complicated from a race condition standpoint?

We currently see this issue on our systems, as we have older e1000 
hardware with 9KB jumbo frames.  After a while we just fail to allocate 
buffers and the system goes belly-up.

Chris
