Return-Path: <linux-kernel-owner+w=401wt.eu-S1757259AbZANFP7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757259AbZANFP7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 00:15:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753223AbZANFPv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 00:15:51 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:57471 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751650AbZANFPu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 00:15:50 -0500
Message-ID: <496D74CE.2070308@cn.fujitsu.com>
Date: Wed, 14 Jan 2009 13:14:54 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>
CC: Rakib Mullick <rakib.mullick@gmail.com>,
       Linux-kernel Mailing List <linux-kernel@vger.kernel.org>, mingo@elte.hu,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [PATCH] mm: Fix section mismatch in memcontrol.c
References: <b9df5fa10901122139h4bfb727i64f864ec185c731d@mail.gmail.com>	<496C2B4F.3090406@cn.fujitsu.com>	<20090113151307.e9ddc085.kamezawa.hiroyu@jp.fujitsu.com>	<b9df5fa10901132043j5a577b2fxeaaa4cc1fdd551f2@mail.gmail.com> <20090114140010.3649cd2e.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090114140010.3649cd2e.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> On Wed, 14 Jan 2009 10:43:24 +0600
> "Rakib Mullick" <rakib.mullick@gmail.com> wrote:
> 
>> Sure. You can carryout your other jobs. Here is the patch.
>> Thanks for your help guys.
>>
> Thank you. I confirmed this fixes mismatch.
> 
> Could you send this with your Signed-off-by, again ?
> 
> you got my Ack.
> Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 

No... This patch is still not correct..

It's mem_cgroup_create() but not enable_swap_cgroup() that needs
to be marked as __init_refok.

Here is the correct one:

===============

From: Li Zefan <lizf@cn.fujitsu.com>
Date: Wed, 14 Jan 2009 13:07:31 +0800
Subject: [PATCH] memcg: fix section mismatch

At system boot when creating the top cgroup, mem_cgroup_create() calls
enable_swap_cgroup() which is marked as __init, so mark mem_cgroup_create()
as __init_refok to avoid false section mismatch warning.

Reported-by: Rakib Mullick <rakib.mullick@gmail.com>
Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 mm/memcontrol.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index e2996b8..a2c929f 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2181,7 +2181,7 @@ static void __init enable_swap_cgroup(void)
 }
 #endif
 
-static struct cgroup_subsys_state *
+static struct cgroup_subsys_state * __init_refok
 mem_cgroup_create(struct cgroup_subsys *ss, struct cgroup *cont)
 {
 	struct mem_cgroup *mem, *parent;
-- 
1.5.4.rc3
