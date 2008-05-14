Return-Path: <linux-kernel-owner+w=401wt.eu-S1757243AbYENH5k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757243AbYENH5k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 03:57:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753552AbYENH53
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 03:57:29 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:41590 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753362AbYENH53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 03:57:29 -0400
Date: Wed, 14 May 2008 17:02:36 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       "xemul@openvz.org" <xemul@openvz.org>,
       "yamamoto@valinux.co.jp" <yamamoto@valinux.co.jp>,
       "hugh@veritas.com" <hugh@veritas.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [RFC/PATCH 0/6] memcg: peformance improvement at el. v3
Message-Id: <20080514170236.23c9ddd7.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This set is for memory resource controller, reviewer and testers. 

Updated against 2.6.26-rc2 and added fixes.

This set does
 - remove refcnt from page_cgroup. By this, codes can be simplified and
   we can avoid tons of unnecessary calls just for maintain refcnt.
 - handle swap-cache, which is now ignored by memory resource controller.
 - small optimization.
 - make force_empty to drop pages. (NEW)
 
major changes : v2 -> v3
 - fixed shared memory handling.
 - added a call to request recalaim memory from specified memcg (NEW) for shmem.
 - added drop_all_pages_in_mem_cgroup before calling force_empty()
 - dropped 3 patches because it's already sent to -mm queue.

 1/6 -- make force_empty to drop pages. (NEW)
 2/6 -- remove refcnt from page_cgroup (shmem handling is fixed.)
 3/6 -- handle swap cache
 4/6 -- add an interface to reclaim memory from memcg (NEW) (for shmem)
 5/6 -- small optimzation with likely()/unlikely()
 6/6 -- remove redundant check.

If positive feedback, I'd like to send some of them agaisnt -mm queue.

This is based on
  - 2.6.26-rc2 
  - memcg-avoid-unnecessary-initialization.patch (in -mm queue)
  - memcg-make-global-var-read_mostly.patch (in -mm queue)
  - memcg-better-migration-handling.patch (in -mm queue)
tested on x86-64 box. Seems to work very well.

Any comments are welcome.

Thanks,
-Kame

