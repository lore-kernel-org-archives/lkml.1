Return-Path: <linux-kernel-owner+w=401wt.eu-S1752926AbYKNKNi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752926AbYKNKNi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 05:13:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751204AbYKNKNa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 05:13:30 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:49455 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132AbYKNKN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 05:13:29 -0500
Date: Fri, 14 Nov 2008 19:12:46 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "linux-mm@kvack.org" <linux-mm@kvack.org>
Cc: "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       pbadari@us.ibm.com, jblunck@suse.de, taka@valinux.co.jp,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/9] memcg updates (14/Nov/2008)
Message-Id: <20081114191246.4f69ff31.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Several patches are posted after last update (12/Nov),
it's better to catch all up as series.

All patchs are mm-of-the-moment snapshot 2008-11-13-17-22
  http://userweb.kernel.org/~akpm/mmotm/
(You may need to patch fs/dquota.c and fix kernel/auditsc.c CONFIG error)

New ones are 1,2,3 and 9. 

IMHO, patch 1-4 are ready to go. (but I want Ack from Balbir to 3/9)

Contents:

[1/9] .... fix memory online/offline with memcg.
  This patch is for "real" memory hotplug. So, people who can test this
  is limited, I think. I asked Badari to try this.
  This fix itself is logically correct I think, but there may be other bugs..

[2/9] .... reduce size of per-cpu allocation.
  This is from Jan Blunck <jblunck@suse.de> and I picked it up and rewrote.
  please test. This tries to reduce memory usage of mem_cgroup struct.

[3/9] .... add force_empty again with proper implementation.
  I removed "force_empty" by account_move patch in mmotm. But I asked not to
  do that brutal removal of interface. I'm sorry.
  This adds "force_empty", but implemntaion itself is much saner. After this,
  force_empty is no longer "debug only" interface.

[4/9] .... account swap-cache.
  Before accounting swap, we have to handle swap-cache.
  This patch have been test for a month and seems to works well. Still here
  and waiting for bug fixes moved into..

[5/9] .... mem+swap controller kconfig
  Kconfig changes and macro for mem+swap controller.

[6/9] .... swap cgroup.
  For accounting swap, we have to prepare a strage for remembering swap.

[7/9] .... mem+swap controller.
  mem+swap controller core logic. I and Nishimura have been testing this
  for a month. It's getting nicer.

[8/9] .... synchronized LRU patch
  remove mz->lru_lock and make use of zone->lru_lock. By this, we do not have to
  duplicate vmscan's global LRU behavior in memcg.
  I think I'm an only tester of this ;) but works well.

[9/9] .... mem_cgroup_disabled() patch
  Replacing if (mem_cgroup_subsys.disabled) to be if (mem_cgroup_disabled()).
  Takahashi (dm-ioband team) posted their bio-cgroup interface working with
  page_cgroup. This is cut out from his one.
  Takahashi, If you ack me, send me Signed-off-by or Acked-by. I'll queue this.

Thanks,
-Kame



