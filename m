Return-Path: <linux-kernel-owner+w=401wt.eu-S1759444AbXFAJX5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759444AbXFAJX5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 05:23:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755641AbXFAJXu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 05:23:50 -0400
Received: from ausmtp05.au.ibm.com ([202.81.18.154]:62225 "EHLO
	ausmtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755489AbXFAJXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 05:23:48 -0400
Message-ID: <465FE592.1040701@linux.vnet.ibm.com>
Date: Fri, 01 Jun 2007 14:53:30 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.10 (X11/20070306)
MIME-Version: 1.0
To: Pavel Emelianov <xemul@openvz.org>
CC: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Menage <menage@google.com>, Balbir Singh <balbir@in.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@openvz.org, Kirill Korotaev <dev@openvz.org>
Subject: Re: [PATCH 8/8] Per-container pages reclamation
References: <465D9739.8070209@openvz.org> <465D9B62.5050507@openvz.org> <20070530144737.56456aaf.akpm@linux-foundation.org> <465E85B5.2030106@linux.vnet.ibm.com> <465E93D7.2020506@linux.vnet.ibm.com> <465FE67C.2040206@openvz.org>
In-Reply-To: <465FE67C.2040206@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Emelianov wrote:
> Balbir Singh wrote:
> 
> [snip]
> 
>>>>> +	for_each_online_node(node) {
>>>>> +#ifdef CONFIG_HIGHMEM
>>>>> +		zones = NODE_DATA(node)->node_zonelists[ZONE_HIGHMEM].zones;
>>>>> +		if (do_try_to_free_pages(zones, sc.gfp_mask, &sc))
>>>>> +			return 1;
>>>>> +#endif
>>>>> +		zones = NODE_DATA(node)->node_zonelists[ZONE_NORMAL].zones;
>>>>> +		if (do_try_to_free_pages(zones, sc.gfp_mask, &sc))
>>>>> +			return 1;
>>>>> +	}
>>>> Definitely need to handle ZONE_DMA32 and ZONE_DMA (some architectures put
>>>> all memory into ZONE_DMA (or they used to))
>> Won't the node_zonelists[ZONE_NORMAL].zones contain all lower zones (including
>> ZONE_DMA and ZONE_DMA32) from various nodes organized by cost?
>>
>> I need to go lookup the node_zonelists creation.
> 
> 
> OK, I've got it. The node's zonelist indexed with ZONE_XXX contains
> the zone specified and all the zones beyond it. Thus shrinking from
> ZONE_HIGHMEM (ZONE_NORMAL if the latter does not exist) is enough.
> 
> Thanks,
> Pavel

Exactly!

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
