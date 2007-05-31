Return-Path: <linux-kernel-owner+w=401wt.eu-S1761003AbXEaJ2p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761003AbXEaJ2p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 05:28:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760810AbXEaJ2Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 05:28:25 -0400
Received: from ausmtp05.au.ibm.com ([202.81.18.154]:56600 "EHLO
	ausmtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760756AbXEaJ2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 05:28:24 -0400
Message-ID: <465E93D7.2020506@linux.vnet.ibm.com>
Date: Thu, 31 May 2007 14:52:31 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.10 (X11/20070306)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Pavel Emelianov <xemul@openvz.org>, Paul Menage <menage@google.com>,
       Balbir Singh <balbir@in.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@openvz.org, Kirill Korotaev <dev@openvz.org>
Subject: Re: [PATCH 8/8] Per-container pages reclamation
References: <465D9739.8070209@openvz.org> <465D9B62.5050507@openvz.org> <20070530144737.56456aaf.akpm@linux-foundation.org> <465E85B5.2030106@linux.vnet.ibm.com>
In-Reply-To: <465E85B5.2030106@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Vaidyanathan Srinivasan wrote:
> 
> Andrew Morton wrote:
>> On Wed, 30 May 2007 19:42:26 +0400
>> Pavel Emelianov <xemul@openvz.org> wrote:
>>
> [snip]
>>> +#ifdef CONFIG_RSS_CONTAINER
>>> +unsigned long try_to_free_pages_in_container(struct rss_container *cnt)
>>> +{
>>> +	struct scan_control sc = {
>>> +		.gfp_mask = GFP_KERNEL,
>>> +		.may_writepage = 1,
>>> +		.swap_cluster_max = 1,
>>> +		.may_swap = 1,
>>> +		.swappiness = vm_swappiness,
>>> +		.order = 0, /* in this case we wanted one page only */
>>> +		.cnt = cnt,
>>> +		.isolate_pages = isolate_pages_in_container,
>>> +	};
>>> +	int node;
>>> +	struct zone **zones;
>>> +
>>> +	for_each_online_node(node) {
>>> +#ifdef CONFIG_HIGHMEM
>>> +		zones = NODE_DATA(node)->node_zonelists[ZONE_HIGHMEM].zones;
>>> +		if (do_try_to_free_pages(zones, sc.gfp_mask, &sc))
>>> +			return 1;
>>> +#endif
>>> +		zones = NODE_DATA(node)->node_zonelists[ZONE_NORMAL].zones;
>>> +		if (do_try_to_free_pages(zones, sc.gfp_mask, &sc))
>>> +			return 1;
>>> +	}
>> Definitely need to handle ZONE_DMA32 and ZONE_DMA (some architectures put
>> all memory into ZONE_DMA (or they used to))
> 

Won't the node_zonelists[ZONE_NORMAL].zones contain all lower zones (including
ZONE_DMA and ZONE_DMA32) from various nodes organized by cost?

I need to go lookup the node_zonelists creation.


-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
