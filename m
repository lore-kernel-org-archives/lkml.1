Return-Path: <linux-kernel-owner+w=401wt.eu-S1757758AbXHUI7K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757758AbXHUI7K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 04:59:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752958AbXHUI64
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 04:58:56 -0400
Received: from gir.skynet.ie ([193.1.99.77]:35891 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752210AbXHUI6z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 04:58:55 -0400
Date: Tue, 21 Aug 2007 09:58:53 +0100
To: Christoph Lameter <clameter@sgi.com>
Cc: Lee.Schermerhorn@hp.com, ak@suse.de, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 4/6] Record how many zones can be safely skipped in the zonelist
Message-ID: <20070821085853.GD29794@skynet.ie>
References: <20070817201647.14792.2690.sendpatchset@skynet.skynet.ie> <20070817201808.14792.13501.sendpatchset@skynet.skynet.ie> <Pine.LNX.4.64.0708171402540.9635@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0708171402540.9635@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: mel@skynet.ie (Mel Gorman)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On (17/08/07 14:03), Christoph Lameter didst pronounce:
> Is there any performance improvement because of this patch? It looks 
> like processing got more expensive since an additional cacheline needs to 
> be fetches to get the skip factor.
> 

It's a small gain on a few machines. Where I thought it was more likely
to be a win is on x86-64 NUMA machines particularly if the zonelist
ordering was zone order as there would be potentially many nodes to
skip.

Kernbench didn't show up any regressions for the other machines but the
userspace portion of that workload is unlikely to notice the loss of a
cache line.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
