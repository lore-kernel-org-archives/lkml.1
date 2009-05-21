Return-Path: <linux-kernel-owner+w=401wt.eu-S1755578AbZEUAXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755578AbZEUAXT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 20:23:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753558AbZEUAXJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 20:23:09 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:53004 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753475AbZEUAXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 20:23:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=U81KwgufB/cSEpOUIRHYiiWx7+Mv7RcqAaV1OCwK4tNxBrq4Eur8jQcyUqyyAmhgGW
         stwwMyLkHsMpcELafBmVtZgdDSvlu5Tgm0C/RqNN5aNxr/NV2ZHqIFYyVgHfDMs96Q83
         ObKxPhZ855y/dIZHqOHjP0Lgvl+IxWyLR9p0s=
Date: Thu, 21 May 2009 09:22:44 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
Cc: Mel Gorman <mel@csn.ul.ie>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
       Yasunori Goto <y-goto@jp.fujitsu.com>
Subject: [PATCH 0/3]  fix zone watermark and inactive ration when memory
 hotplug occur  V2
Message-Id: <20090521092244.244a17c6.minchan.kim@barrios-desktop>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changelog since V1 
 o Add reviewd-by and acked-by
 o Change functions name properly. 

Thanks for careful review. Mel, KOSAKI, Yasunori. 

This patch series clean up setup_per_zone_pages_min 
and fix memory hotplug bug. (watermark, inactive ratio of zone)

Patch 1/3 is independent of others.

But I just add it for convinient since it is tivial.
If anyone want to devide it, i will do it. 

patch 1/3 - change function name related to pages_min
patch 2/3 - devide setup_per_zone_inactive_ratio with per 
zone function. this patch helps 3/3
patch 3/3 - reset wmark_min and inactive ratio of zone when 
hotplug happens

 include/linux/mm.h  |    3 ++-
 mm/memory_hotplug.c |    6 +++++-
 mm/page_alloc.c     |   43 ++++++++++++++++++++++++-------------------
 3 files changed, 31 insertions(+), 21 deletions(-)


-- 
Kinds Regards
Minchan Kim
