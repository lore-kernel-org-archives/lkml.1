Return-Path: <linux-kernel-owner+w=401wt.eu-S1755841AbZETHSi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755841AbZETHSi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 03:18:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752893AbZETHSb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 03:18:31 -0400
Received: from mail-px0-f123.google.com ([209.85.216.123]:55587 "EHLO
	mail-px0-f123.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752811AbZETHSb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 03:18:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=EcSkhkVp3KKOzq/XVfmRU7ffYD92DjMGfHG7Su4Y0k4f/98YCog/M9mXoZvKpa7Una
         Z/b5rh2w2EC8mEERak0LAHmqroisk/ZokNsae8gBkudHZUf5pPGRRMmqd1JvLzskePtK
         mF3IYFJp0ZB2tv5eXjQasXUTpixqbax8lKzck=
Date: Wed, 20 May 2009 16:18:22 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
Cc: Mel Gorman <mel@csn.ul.ie>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>
Subject: [PATCH 0/3] fix zone watermark and inactive ration when memory hot
 plug occur
Message-Id: <20090520161822.e2f2d94a.minchan.kim@barrios-desktop>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch series clean up setup_per_zone_pages_min 
and fix memory hotplug bug. (watermark, inactive ratio of zone)

Patch 1/3 is independent of others.

But I just add it for convinient since it is tivial.
If anyone want to devide it, i will do it. 

patch 1/3 - change setup_per_zone_pages_min function name 
patch 2/3 - devide setup_per_zone_inactive_ratio with per 
zone function. this patch helps 3/3
patch 3/3 - reset wmark_min and inactive ratio of zone when 
hotplug happens


 include/linux/mm.h  |    3 ++- 
 mm/memory_hotplug.c |    6 +++++-
 mm/page_alloc.c     |   28 ++++++++++++++++------------
 3 files changed, 23 insertions(+), 14 deletions(-)

-- 
Kinds Regards
Minchan Kim
