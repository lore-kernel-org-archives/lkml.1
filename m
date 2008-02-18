Return-Path: <linux-kernel-owner+w=401wt.eu-S1755618AbYBRHgX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755618AbYBRHgX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 02:36:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753940AbYBRHgQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 02:36:16 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:57607 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753804AbYBRHgP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 02:36:15 -0500
Message-ID: <47B93518.6@cn.fujitsu.com>
Date: Mon, 18 Feb 2008 15:34:48 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: akpm@linux-foundation.org
CC: balbir@linux.vnet.ibm.com, containers@lists.linux-foundation.org,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] memcgroup: remove a useless VM_BUG_ON()
References: <47B9223C.9020106@linux.vnet.ibm.com> <20080218062209.DA59B1E3C58@siro.lan> <47B923C8.3090904@linux.vnet.ibm.com> <47B929EE.7080202@cn.fujitsu.com> <47B92D47.2050008@linux.vnet.ibm.com>
In-Reply-To: <47B92D47.2050008@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove this VM_BUG_ON(), as Balbir stated:

We used to have a for loop with !list_empty() as a termination condition
and VM_BUG_ON(!pc) is a spill over. With the new loop, VM_BUG_ON(!pc) does not
make sense.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 mm/memcontrol.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 718acf8..631002d 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -534,7 +534,6 @@ unsigned long mem_cgroup_isolate_pages(unsigned long nr_to_scan,
 		if (scan >= nr_to_scan)
 			break;
 		page = pc->page;
-		VM_BUG_ON(!pc);
 
 		if (unlikely(!PageLRU(page)))
 			continue;
-- 
1.5.4.rc3
