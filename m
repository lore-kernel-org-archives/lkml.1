Return-Path: <linux-kernel-owner+w=401wt.eu-S1753416AbYHSIYo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416AbYHSIYo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 04:24:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751103AbYHSIY0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 04:24:26 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:47599 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937AbYHSIYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 04:24:25 -0400
Date: Tue, 19 Aug 2008 17:30:14 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "yamamoto@valinux.co.jp" <yamamoto@valinux.co.jp>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       ryov@valinux.co.jp
Subject: [PATCH -mm][preview] memcg: a patch series for next [0/9]
Message-Id: <20080819173014.17358c17.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, 

This post is for showing what I'm trying now.

This patch set is for memory resource controller.
4 purposes here.
  - improve performance of memcg.
  - remove lock_page_cgroup()
  - making page_cgroup->flags to be atomic_ops.
  - support mem+swap controller.

But this is still under test and the series is not well organised.
and base tree is old. (2.6.27-rc1-mm1) I'll rebase this set to newer mmtom tree.

Maybe this set have some troubles/objections but I think the direction is not bad.

Patch description. (patch ordering is bad. I'll fix in the next post.)

[1/9] ... private_counter ...replace res_counter with my own counter.
          This is for supporting mem+swap controller.
          (And I think memcg has a bit different characteristics from other
           users of res_counter....)

[2/9] ... change-order-uncharge ...
          This patch is for making it easy to handle swap-cache.

[3/9] ... atomic_flags
          This patch changes operations for page_cgroup->flags to be atomic_ops.

[4/9] ... delayed freeing.
          delaying to free page_cgroup at uncharge.

[5/9] ... RCU freeing of page_cgroup
          free page_cgroup by RCU.

[6/9] ... lockress page cgroup.
          remove lock_page_cgroup() and use RCU semantics.

[7/9] ... add preftech
          add prefetch() macro

[8/9] ... mem+swap controller base.
          introduce mem+swap controller. A bit big patch....but have tons of TODO.
          and have troubles. (it seems it's difficult to cause OOM killer.)

[9/9] ... mem+swap controller control files.
          add mem+swap controller's control files.

I'd like to push patch [2,3,4,5,6,7] first.

Thanks,
-Kame

