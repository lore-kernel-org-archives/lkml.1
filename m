Return-Path: <linux-kernel-owner+w=401wt.eu-S1758555AbXFAJWr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758555AbXFAJWr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 05:22:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755625AbXFAJWj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 05:22:39 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:1346 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755489AbXFAJWi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 05:22:38 -0400
Message-ID: <465FE67C.2040206@openvz.org>
Date: Fri, 01 Jun 2007 13:27:24 +0400
From: Pavel Emelianov <xemul@openvz.org>
User-Agent: Thunderbird 1.5 (X11/20060317)
MIME-Version: 1.0
To: balbir@linux.vnet.ibm.com,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Paul Menage <menage@google.com>,
       Balbir Singh <balbir@in.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@openvz.org, Kirill Korotaev <dev@openvz.org>
Subject: Re: [PATCH 8/8] Per-container pages reclamation
References: <465D9739.8070209@openvz.org> <465D9B62.5050507@openvz.org> <20070530144737.56456aaf.akpm@linux-foundation.org> <465E85B5.2030106@linux.vnet.ibm.com> <465E93D7.2020506@linux.vnet.ibm.com>
In-Reply-To: <465E93D7.2020506@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Balbir Singh wrote:

[snip]

>>>> +	for_each_online_node(node) {
>>>> +#ifdef CONFIG_HIGHMEM
>>>> +		zones = NODE_DATA(node)->node_zonelists[ZONE_HIGHMEM].zones;
>>>> +		if (do_try_to_free_pages(zones, sc.gfp_mask, &sc))
>>>> +			return 1;
>>>> +#endif
>>>> +		zones = NODE_DATA(node)->node_zonelists[ZONE_NORMAL].zones;
>>>> +		if (do_try_to_free_pages(zones, sc.gfp_mask, &sc))
>>>> +			return 1;
>>>> +	}
>>> Definitely need to handle ZONE_DMA32 and ZONE_DMA (some architectures put
>>> all memory into ZONE_DMA (or they used to))
> 
> Won't the node_zonelists[ZONE_NORMAL].zones contain all lower zones (including
> ZONE_DMA and ZONE_DMA32) from various nodes organized by cost?
> 
> I need to go lookup the node_zonelists creation.


OK, I've got it. The node's zonelist indexed with ZONE_XXX contains
the zone specified and all the zones beyond it. Thus shrinking from
ZONE_HIGHMEM (ZONE_NORMAL if the latter does not exist) is enough.

Thanks,
Pavel
