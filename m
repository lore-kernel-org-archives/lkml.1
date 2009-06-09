Return-Path: <linux-kernel-owner+w=401wt.eu-S1759107AbZFIII6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759107AbZFIII6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 04:08:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757427AbZFIIIo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 04:08:44 -0400
Received: from gir.skynet.ie ([193.1.99.77]:56256 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755220AbZFIIIn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 04:08:43 -0400
Date: Tue, 9 Jun 2009 09:08:43 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Rik van Riel <riel@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>, yanmin.zhang@intel.com,
       Wu Fengguang <fengguang.wu@intel.com>, linuxram@us.ibm.com,
       linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] Reintroduce zone_reclaim_interval for when
	zone_reclaim() scans and fails to avoid CPU spinning at 100% on NUMA
Message-ID: <20090609080842.GC18380@csn.ul.ie>
References: <1244466090-10711-1-git-send-email-mel@csn.ul.ie> <1244466090-10711-2-git-send-email-mel@csn.ul.ie> <4A2D129D.3020309@redhat.com> <20090608135433.GD15070@csn.ul.ie> <4A2D24B0.4080301@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <4A2D24B0.4080301@redhat.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 08, 2009 at 10:48:16AM -0400, Rik van Riel wrote:
> Mel Gorman wrote:
>> On Mon, Jun 08, 2009 at 09:31:09AM -0400, Rik van Riel wrote:
>>> Mel Gorman wrote:
>>>
>>>> The scanning occurs because zone_reclaim() cannot tell
>>>> in advance the scan is pointless because the counters do not distinguish
>>>> between pagecache pages backed by disk and by RAM. 
>>> Yes it can.  Since 2.6.27, filesystem backed and swap/ram backed
>>> pages have been living on separate LRU lists. 
>>
>> Yes, they're on separate LRU lists but they are not the only pages on those
>> lists. The tmpfs pages are mixed in together with anonymous pages so we
>> cannot use NR_*_ANON.
>>
>> Look at patch 2 and where I introduced;
>
> I have to admit I did not read patches 2 and 3 before
> replying to the (strange looking, at the time) text
> above patch 1.
>

Sorry about that. The ordering of the patches was in "patch that fixes
bug, patch that addresses expectations and patch that fixes imaginery
bug but that makes sense". If it was a real patchset, patch 2 would have
come first.

> With that logic from patch 2 in place, patch 1 makes
> perfect sense.
>
> Acked-by: Rik van Riel <riel@redhat.com>
>

Thanks

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
