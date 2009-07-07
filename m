Return-Path: <linux-kernel-owner+w=401wt.eu-S1756611AbZGGRYQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756611AbZGGRYQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 13:24:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754209AbZGGRYB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 13:24:01 -0400
Received: from mx2.redhat.com ([66.187.237.31]:51775 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753174AbZGGRYA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 13:24:00 -0400
Message-ID: <4A5384A4.7060108@redhat.com>
Date: Tue, 07 Jul 2009 13:23:48 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Minchan Kim <minchan.kim@gmail.com>,
       Wu Fengguang <fengguang.wu@intel.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rientjes <rientjes@google.com>
Subject: Re: [PATCH 4/5] add isolate pages vmstat
References: <20090707090120.1e71a060.minchan.kim@barrios-desktop> <20090707090509.0C60.A69D9226@jp.fujitsu.com> <20090707101855.0C63.A69D9226@jp.fujitsu.com> <alpine.DEB.1.10.0907071248560.5124@gentwo.org>
In-Reply-To: <alpine.DEB.1.10.0907071248560.5124@gentwo.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> On Tue, 7 Jul 2009, KOSAKI Motohiro wrote:
> 
>> +++ b/include/linux/mmzone.h
>> @@ -100,6 +100,8 @@ enum zone_stat_item {
>>  	NR_BOUNCE,
>>  	NR_VMSCAN_WRITE,
>>  	NR_WRITEBACK_TEMP,	/* Writeback using temporary buffers */
>> +	NR_ISOLATED_ANON,	/* Temporary isolated pages from anon lru */
>> +	NR_ISOLATED_FILE,	/* Temporary isolated pages from file lru */
> 
> LRU counters are rarer in use then the counters used for dirty pages etc.
> 
> Could you move the counters for reclaim into a separate cacheline?

I don't get the point of that - these counters are
per-cpu anyway, so why would they need to be in a
separate cacheline?
