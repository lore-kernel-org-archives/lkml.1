Return-Path: <linux-kernel-owner+w=401wt.eu-S1752733AbYCLHis@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752733AbYCLHis (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 03:38:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751229AbYCLHik
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 03:38:40 -0400
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:52324 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201AbYCLHij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 03:38:39 -0400
Message-ID: <47D78863.101@linux.vnet.ibm.com>
Date: Wed, 12 Mar 2008 13:08:11 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Hugh Dickins <hugh@veritas.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       Pavel Emelyanov <xemul@openvz.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH rc5-mm1 1/3] mm-have-zonelist: fix memcg ooms
References: <Pine.LNX.4.64.0803112108470.17067@blonde.site>
In-Reply-To: <Pine.LNX.4.64.0803112108470.17067@blonde.site>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> Memcgroups up against their limit were OOMing unjustifiably on x86_32
> with highmem: pages ripe for freeing were not being found.
> 
> It's because the zonelist changes in vmscan.c now derive zone from gfp_mask,
> and the gfp mask being passed into try_to_free_mem_cgroup_pages is atuned
> to allocating a struct page_cgroup (__GFP_HIGHMEM masked off), whereas here
> we need to be scanning highmem zones.
> 

Very good catch. I see a high_zoneidx field being derived from gfp_mask -mm.
I've been looking at mainline code too often.


-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL

