Return-Path: <linux-kernel-owner+w=401wt.eu-S1762032AbYBULH1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762032AbYBULH1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 06:07:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765600AbYBULGp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 06:06:45 -0500
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:39398 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765576AbYBULGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 06:06:44 -0500
Message-ID: <47BD5A31.9070401@linux.vnet.ibm.com>
Date: Thu, 21 Feb 2008 16:32:09 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] the proposal of improve page reclaim by throttle
References: <20080219134715.7E90.KOSAKI.MOTOHIRO@jp.fujitsu.com> <47BD48F3.3040903@linux.vnet.ibm.com> <2f11576a0802210301sb162ac9u6cf4ba4d5cb179b4@mail.gmail.com>
In-Reply-To: <2f11576a0802210301sb162ac9u6cf4ba4d5cb179b4@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro wrote:
> Hi balbir-san
> 
>>  It's good to keep the main reclaim code and the memory controller reclaim in
>>  sync, so this is a nice effort.
> 
> thank you.
> I will repost next version (fixed nick's opinion) while a few days.
> 
>>  > @@ -1456,7 +1501,7 @@ unsigned long try_to_free_mem_cgroup_pag
>>  >       int target_zone = gfp_zone(GFP_HIGHUSER_MOVABLE);
>>  >
>>  >       zones = NODE_DATA(numa_node_id())->node_zonelists[target_zone].zones;
>>  > -     if (do_try_to_free_pages(zones, sc.gfp_mask, &sc))
>>  > +     if (try_to_free_pages_throttled(zones, 0, sc.gfp_mask, &sc))
>>  >               return 1;
>>  >       return 0;
>>  >  }
>>
>>  try_to_free_pages_throttled checks for zone_watermark_ok(), that will not work
>>  in the case that we are reclaiming from a cgroup which over it's limit. We need
>>  a different check, to see if the mem_cgroup is still over it's limit or not.
> 
> That makes sense.
> 
> unfortunately, I don't know mem-cgroup so much.
> What do i use function, instead?

One option could be that once the memory controller has this feature, we'll need
no changes in try_to_free_mem_cgroup_pages.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
