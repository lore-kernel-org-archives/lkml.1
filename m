Return-Path: <linux-kernel-owner+w=401wt.eu-S1752102AbYHZUfq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752102AbYHZUfq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 16:35:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751389AbYHZUfi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 16:35:38 -0400
Received: from relay1.sgi.com ([192.48.171.29]:33692 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751339AbYHZUfi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 16:35:38 -0400
Message-ID: <48B46917.6080304@sgi.com>
Date: Tue, 26 Aug 2008 13:35:35 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, cl@linux-foundation.org,
       tokunaga.keiich@jp.fujitsu.com
Subject: Re: [RFC][PATCH 2/2] quicklist shouldn't be proportional to # of
 CPUs
References: <20080821183648.22AF.KOSAKI.MOTOHIRO@jp.fujitsu.com> <48B2FE79.8060709@sgi.com> <20080826083243.232F.KOSAKI.MOTOHIRO@jp.fujitsu.com>
In-Reply-To: <20080826083243.232F.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro wrote:
>>> +	int node = numa_node_id();
>>> +	struct zone *zones = NODE_DATA(node)->node_zones;
>>> +	int num_cpus_on_node;
>>> +	node_to_cpumask_ptr(cpumask_on_node, node);
>>>  
>>>  	node_free_pages =
>>>  #ifdef CONFIG_ZONE_DMA
>>> @@ -38,6 +41,10 @@ static unsigned long max_pages(unsigned 
>>>  		zone_page_state(&zones[ZONE_NORMAL], NR_FREE_PAGES);
>>>  
>>>  	max = node_free_pages / FRACTION_OF_NODE_MEM;
>>> +
>>> +	num_cpus_on_node = cpus_weight_nr(*cpumask_on_node);
>>> +	max /= num_cpus_on_node;
>>> +
>>>  	return max(max, min_pages);
>> Exactly!  And (many thanks to them!) the sparc maintainers have
>> implemented a similar internal function definition for node_to_cpumask_ptr().
> 
> Can I think get your Ack?
> 

Based on code review, sure.  I'll also give it a try on one of my
test machines as soon as I can.

Mike
