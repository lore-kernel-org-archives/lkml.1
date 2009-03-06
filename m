Return-Path: <linux-kernel-owner+w=401wt.eu-S1754946AbZCFKgU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754946AbZCFKgU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 05:36:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752944AbZCFKgF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 05:36:05 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:59025 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752888AbZCFKgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 05:36:03 -0500
Date: Fri, 6 Mar 2009 19:34:38 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>, linux-mm@kvack.org,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Bharata B Rao <bharata@in.ibm.com>, Paul Menage <menage@google.com>,
       lizf@cn.fujitsu.com, linux-kernel@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       David Rientjes <rientjes@google.com>,
       Pavel Emelianov <xemul@openvz.org>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [RFC][PATCH 0/3] memory controller soft limit (Yet Another One) v1
Message-Id: <20090306193438.8084837d.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090306185440.66b92ca3.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090306092323.21063.93169.sendpatchset@localhost.localdomain>
	<20090306185440.66b92ca3.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I don't say this should go but there are big distance between Balbir and me, so
showing what I'm thinking of in a patch. 

[1/3] interface of softlimit.
[2/3] recalaim logic of softlimit
[3/3] documenation.

Characteristic is.

  1. No hook to fast path.
  2. memory.softlimit_priority file is used in addtion to memory.softlimit file.
  3. vicitm cgroup at softlimit depends on priority given by user.
  4. softlimit can be set to any cgroup even if it's children in hierarchy.
  5. has some logic to sync with kswapd()'s balance_pgdat().

This patch should be sophisticated to some extent.(and may have bug.)

Example) Assume group_A which uses hierarchy and childrsn 01, 02, 03.
         The lower number priority, the less memory is reclaimd. 

   /group_A/    softlimit=300M      priority=0  (priority0 is ignored)
            01/ softlimit=unlimited priority=1
            02/ softlimit=unlimited priority=3
            03/ softlimit=unlimited priority=3
 
  1. When kswapd runs, memory will be reclaimed by 02 and 03 in round-robin.
  2. If no memory can be reclaimed from 02 and 03, memory will be reclaimed from 01
  3. If no memory can be reclaimed from 01,02,03, global shrink_zone() is called.

I'm sorry if my response is too slow.

Thanks,
-Kame

