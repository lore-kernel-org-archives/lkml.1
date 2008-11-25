Return-Path: <linux-kernel-owner+w=401wt.eu-S1752801AbYKYNdb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752801AbYKYNdb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 08:33:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750793AbYKYNdX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 08:33:23 -0500
Received: from mx2.redhat.com ([66.187.237.31]:39038 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750745AbYKYNdW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 08:33:22 -0500
Message-ID: <492BFE6F.5090902@redhat.com>
Date: Tue, 25 Nov 2008 08:32:31 -0500
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org, mel@csn.ul.ie,
       akpm@linux-foundation.org
Subject: Re: [PATCH] vmscan: bail out of page reclaim after swap_cluster_max
 pages
References: <20081124145057.4211bd46@bree.surriel.com> <20081125203333.26F0.KOSAKI.MOTOHIRO@jp.fujitsu.com>
In-Reply-To: <20081125203333.26F0.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro wrote:
>> Sometimes the VM spends the first few priority rounds rotating back
>> referenced pages and submitting IO.  Once we get to a lower priority,
>> sometimes the VM ends up freeing way too many pages.
>>
>> The fix is relatively simple: in shrink_zone() we can check how many
>> pages we have already freed, direct reclaim tasks break out of the
>> scanning loop if they have already freed enough pages and have reached
>> a lower priority level.
>>
>> However, in order to do this we do need to know how many pages we already
>> freed, so move nr_reclaimed into scan_control.
>>
>> Signed-off-by: Rik van Riel <riel@redhat.com>
>> ---
>> Kosaki, this should address the zone scanning pressure issue.
> 
> hmmmm. I still don't like the behavior when priority==DEF_PRIORITY.
> but I also should explain by code and benchmark.

Well, the behaviour when priority==DEF_PRIORITY is the
same as the kernel's behaviour without the patch...

> therefore, I'll try to mesure this patch in this week.

Looking forward to it.

-- 
All rights reversed.
