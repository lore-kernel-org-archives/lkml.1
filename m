Return-Path: <linux-kernel-owner+w=401wt.eu-S1752853AbZESBSR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752853AbZESBSR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 21:18:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753105AbZESBSG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 21:18:06 -0400
Received: from mga01.intel.com ([192.55.52.88]:3167 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752714AbZESBSE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 21:18:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,212,1241420400"; 
   d="scan'208";a="691565749"
From: "Zhang, Yanmin" <yanmin.zhang@intel.com>
To: "Wu, Fengguang" <fengguang.wu@intel.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>
Date: Tue, 19 May 2009 09:16:25 +0800
Subject: RE: [PATCH 4/4] zone_reclaim_mode is always 0 by default
Thread-Topic: [PATCH 4/4] zone_reclaim_mode is always 0 by default
Thread-Index: AcnXa7H5GvLvkHIJROObWC1FrOVfWwAs1fbA
Message-ID: <4D05DB80B95B23498C72C700BD6C2E0B2EF6E127@pdsmsx502.ccr.corp.intel.com>
References: <20090513120155.5879.A69D9226@jp.fujitsu.com>
 <20090513120729.5885.A69D9226@jp.fujitsu.com>
 <20090518034907.GF5869@localhost>
In-Reply-To: <20090518034907.GF5869@localhost>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id n4J1IOlL022440

>>-----Original Message-----
>>From: Wu, Fengguang
>>Sent: 2009Äê5ÔÂ18ÈÕ 11:49
>>To: KOSAKI Motohiro
>>Cc: LKML; linux-mm; Andrew Morton; Rik van Riel; Christoph Lameter; Zhang,
>>Yanmin
>>Subject: Re: [PATCH 4/4] zone_reclaim_mode is always 0 by default
>>
>>On Wed, May 13, 2009 at 12:08:12PM +0900, KOSAKI Motohiro wrote:
>>> Subject: [PATCH] zone_reclaim_mode is always 0 by default
>>>
>>> Current linux policy is, if the machine has large remote node distance,
>>>  zone_reclaim_mode is enabled by default because we've be able to assume to
>>> large distance mean large server until recently.
>>>
>>> Unfrotunately, recent modern x86 CPU (e.g. Core i7, Opeteron) have P2P
>>transport
>>> memory controller. IOW it's NUMA from software view.
>>>
>>> Some Core i7 machine has large remote node distance and zone_reclaim don't
>>> fit desktop and small file server. it cause performance degression.
>>
>>I can confirm this, Yanmin recently ran into exactly such a
>>regression, which was fixed by manually disabling the zone reclaim
>>mode. So I guess you can safely add an
[YM] Fengguang told the truth. One Nehalem machine has 12GB memory,
but there is always 2GB free although applications accesses lots of files.
Eventually we located the root cause as zone_reclaim_mode=1.

Acked.



>>
>>Tested-by: "Zhang, Yanmin" <yanmin.zhang@intel.com>
>>
>>> Thus, zone_reclaim == 0 is better by default. sorry, HPC gusy.
>>> you need to turn zone_reclaim_mode on manually now.
>>
>>I guess the borderline will continue to blur up. It will be more
>>dependent on workloads instead of physical NUMA capabilities. So
>>
>>Acked-by: Wu Fengguang <fengguang.wu@intel.com>
>>
>>> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
>>> Cc: Christoph Lameter <cl@linux-foundation.org>
>>> Cc: Rik van Riel <riel@redhat.com>
>>> ---
>>>  mm/page_alloc.c |    7 -------
>>>  1 file changed, 7 deletions(-)
>>>
>>> Index: b/mm/page_alloc.c
>>> ===================================================================
>>> --- a/mm/page_alloc.c
>>> +++ b/mm/page_alloc.c
>>> @@ -2494,13 +2494,6 @@ static void build_zonelists(pg_data_t *p
>>>  		int distance = node_distance(local_node, node);
>>>
>>>  		/*
>>> -		 * If another node is sufficiently far away then it is better
>>> -		 * to reclaim pages in a zone before going off node.
>>> -		 */
>>> -		if (distance > RECLAIM_DISTANCE)
>>> -			zone_reclaim_mode = 1;
>>> -
>>> -		/*
>>>  		 * We don't want to pressure a particular node.
>>>  		 * So adding penalty to the first node in same
>>>  		 * distance group to make it round-robin.
>>>
>>>
>>> --
>>> To unsubscribe, send a message with 'unsubscribe linux-mm' in
>>> the body to majordomo@kvack.org.  For more info on Linux MM,
>>> see: http://www.linux-mm.org/ .
>>> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
