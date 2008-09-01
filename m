Return-Path: <linux-kernel-owner+w=401wt.eu-S1752437AbYIAGRN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752437AbYIAGRN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 02:17:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751016AbYIAGQ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 02:16:59 -0400
Received: from e28smtp05.in.ibm.com ([59.145.155.5]:59191 "EHLO
	e28esmtp05.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750757AbYIAGQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 02:16:59 -0400
Message-ID: <48BB88D5.2020109@linux.vnet.ibm.com>
Date: Mon, 01 Sep 2008 11:46:53 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Andrew Morton <akpm@linux-foundation.org>, hugh@veritas.com,
       menage@google.com, xemul@openvz.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, "nickpiggin@yahoo.com.au" <nickpiggin@yahoo.com.au>
Subject: Re: [RFC][PATCH] Remove cgroup member from struct page
References: <20080831174756.GA25790@balbir.in.ibm.com> <20080901090102.46b75141.kamezawa.hiroyu@jp.fujitsu.com> <48BB6160.4070904@linux.vnet.ibm.com> <20080901130351.f005d5b6.kamezawa.hiroyu@jp.fujitsu.com> <20080901141750.37101182.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080901141750.37101182.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> On Mon, 1 Sep 2008 13:03:51 +0900
> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
>>> That depends, if we can get the lockless page cgroup done quickly, I don't mind
>>> waiting, but if it is going to take longer, I would rather push these changes
>>> in. 
>> The development of lockless-page_cgroup is not stalled. I'm just waiting for
>> my 8cpu box comes back from maintainance...
>> If you want to see, I'll post v3 with brief result on small (2cpu) box.
>>
> This is current status (result of unixbench.)
> result of 2core/1socket x86-64 system.
> 
> ==
> [disabled]
> Execl Throughput                           3103.3 lps   (29.7 secs, 3 samples)
> C Compiler Throughput                      1052.0 lpm   (60.0 secs, 3 samples)
> Shell Scripts (1 concurrent)               5915.0 lpm   (60.0 secs, 3 samples)
> Shell Scripts (8 concurrent)               1142.7 lpm   (60.0 secs, 3 samples)
> Shell Scripts (16 concurrent)               586.0 lpm   (60.0 secs, 3 samples)
> Dc: sqrt(2) to 99 decimal places         131463.3 lpm   (30.0 secs, 3 samples)
> 
> [rc4mm1]
> Execl Throughput                           3004.4 lps   (29.6 secs, 3 samples)
> C Compiler Throughput                      1017.9 lpm   (60.0 secs, 3 samples)
> Shell Scripts (1 concurrent)               5726.3 lpm   (60.0 secs, 3 samples)
> Shell Scripts (8 concurrent)               1124.3 lpm   (60.0 secs, 3 samples)
> Shell Scripts (16 concurrent)               576.0 lpm   (60.0 secs, 3 samples)
> Dc: sqrt(2) to 99 decimal places         125446.5 lpm   (30.0 secs, 3 samples)
> 
> [lockless]
> Execl Throughput                           3041.0 lps   (29.8 secs, 3 samples)
> C Compiler Throughput                      1025.7 lpm   (60.0 secs, 3 samples)
> Shell Scripts (1 concurrent)               5713.6 lpm   (60.0 secs, 3 samples)
> Shell Scripts (8 concurrent)               1113.7 lpm   (60.0 secs, 3 samples)
> Shell Scripts (16 concurrent)               571.3 lpm   (60.0 secs, 3 samples)
> Dc: sqrt(2) to 99 decimal places         125417.9 lpm   (30.0 secs, 3 samples)
> ==
> 
> From this, single-thread results are good. multi-process results are not good ;)
> So, I think the number of atomic ops are reduced but I have should-be-fixed
> contention or cache-bouncing problem yet. I'd like to fix this and check on 8 core
> system when it is back.
> Recently, I wonder within-3%-overhead is realistic goal.

It would be nice to be under 3% and lower if possible. I know it is a hard goal
to achieve, but worth striving for. I'll try and extract some numbers with the
radix tree changes and see if I am adding to the overhead (in terms of time) :)

-- 
	Balbir
