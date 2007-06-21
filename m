Return-Path: <linux-kernel-owner+w=401wt.eu-S1756839AbXFUN0m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756839AbXFUN0m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 09:26:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755227AbXFUN0e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 09:26:34 -0400
Received: from calculon.skynet.ie ([193.1.99.88]:56338 "EHLO
	calculon.skynet.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754837AbXFUN0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 09:26:34 -0400
Message-ID: <467A7C88.2040102@csn.ul.ie>
Date: Thu, 21 Jun 2007 14:26:32 +0100
From: Mel Gorman <mel@csn.ul.ie>
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       kamezawa.hiroyu@jp.fujitsu.com, clameter@sgi.com
Subject: Re: [PATCH 7/7] Compact memory directly by a process when a high-order
 allocation fails
References: <20070618092821.7790.52015.sendpatchset@skynet.skynet.ie>	<20070618093042.7790.30669.sendpatchset@skynet.skynet.ie> <20070621052813.ac93e12e.akpm@linux-foundation.org>
In-Reply-To: <20070621052813.ac93e12e.akpm@linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
>> On Mon, 18 Jun 2007 10:30:42 +0100 (IST) Mel Gorman <mel@csn.ul.ie> wrote:
>> +
>> +			/*
>> +			 * It's a race if compaction frees a suitable page but
>> +			 * someone else allocates it
>> +			 */
>> +			count_vm_event(COMPACTRACE);
>> +		}
> 
> Could perhaps cause arbitrarily long starvation. 

More likely it will just fail allocations where it could have succeeded.
I knew the situation would occur so I thought I would count how often it
happens before doing.

> A fix would be to free
> the synchronously-compacted higher-order page into somewhere which is
> private to this task (a new field in task_struct would be one such place).

There used to be such fields and a process flag PF_FREE_PAGES for a
similar purpose. I'll look into reintroducing it. Thanks

-- 
Mel Gorman
