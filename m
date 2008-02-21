Return-Path: <linux-kernel-owner+w=401wt.eu-S1765326AbYBULBf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765326AbYBULBf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 06:01:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764425AbYBULBY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 06:01:24 -0500
Received: from py-out-1112.google.com ([64.233.166.180]:47039 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764331AbYBULBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 06:01:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=qY9mufaVLlZPrisi9MZhp237VSitnIiJK5jTW6nAR8Ov1Izl9WOKQ9OZtciGwMvpGqd9fVrzEV2hX9AmwexaW743HNE2vooPUysqqLuHsy4Y71RbGjhuxIjkIvkl1HajZ+gmdvEuhYqFRAQhwyN6R0/nAVUch5RvQy/v/DAz9X0=
Message-ID: <2f11576a0802210301sb162ac9u6cf4ba4d5cb179b4@mail.gmail.com>
Date: Thu, 21 Feb 2008 20:01:20 +0900
From: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Subject: Re: [RFC][PATCH] the proposal of improve page reclaim by throttle
Cc: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       "Rik van Riel" <riel@redhat.com>,
       "Lee Schermerhorn" <Lee.Schermerhorn@hp.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <47BD48F3.3040903@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080219134715.7E90.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <47BD48F3.3040903@linux.vnet.ibm.com>
X-Google-Sender-Auth: 0c3972a128aa373f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi balbir-san

>  It's good to keep the main reclaim code and the memory controller reclaim in
>  sync, so this is a nice effort.

thank you.
I will repost next version (fixed nick's opinion) while a few days.

>  > @@ -1456,7 +1501,7 @@ unsigned long try_to_free_mem_cgroup_pag
>  >       int target_zone = gfp_zone(GFP_HIGHUSER_MOVABLE);
>  >
>  >       zones = NODE_DATA(numa_node_id())->node_zonelists[target_zone].zones;
>  > -     if (do_try_to_free_pages(zones, sc.gfp_mask, &sc))
>  > +     if (try_to_free_pages_throttled(zones, 0, sc.gfp_mask, &sc))
>  >               return 1;
>  >       return 0;
>  >  }
>
>  try_to_free_pages_throttled checks for zone_watermark_ok(), that will not work
>  in the case that we are reclaiming from a cgroup which over it's limit. We need
>  a different check, to see if the mem_cgroup is still over it's limit or not.

That makes sense.

unfortunately, I don't know mem-cgroup so much.
What do i use function, instead?
