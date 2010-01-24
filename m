Return-Path: <linux-kernel-owner+w=401wt.eu-S1753924Ab0AXQGN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753924Ab0AXQGN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jan 2010 11:06:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753884Ab0AXQGJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jan 2010 11:06:09 -0500
Received: from qw-out-2122.google.com ([74.125.92.24]:11891 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753852Ab0AXQGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jan 2010 11:06:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Q/bYPAK9SQXUyJa5oeItYppTGn8xnEFVb0NNNeLyYEEWpNcHVWpljGWyzjmFfZoB8G
         /2oQeDkyoKAMe27mpZ5l6rR0P0B4gwgWNjuH21F9QxHWmyM6/g9vwLyOwJJo2Je3zl4R
         GS6TmpE3r9qMr/ggCuA9YOJK074+8R8JggpEY=
From: Thiago Farina <tfransosi@gmail.com>
To: tfransosi@gmail.com
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>,
       Pavel Emelyanov <xemul@openvz.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       Li Zefan <lizf@cn.fujitsu.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] mm/memcontrol.c: fix "integer as NULL pointer" warning.
Date: Sun, 24 Jan 2010 11:03:51 -0500
Message-Id: <1264349038-1766-4-git-send-email-tfransosi@gmail.com>
X-Mailer: git-send-email 1.6.6.1.383.g5a9f
In-Reply-To: <1264349038-1766-1-git-send-email-tfransosi@gmail.com>
References: <1264349038-1766-1-git-send-email-tfransosi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mm/memcontrol.c:2548:32: warning: Using plain integer as NULL pointer

Signed-off-by: Thiago Farina <tfransosi@gmail.com>
---
 mm/memcontrol.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 954032b..d813823 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2545,7 +2545,7 @@ static int mem_cgroup_force_empty_list(struct mem_cgroup *mem,
 		pc = list_entry(list->prev, struct page_cgroup, lru);
 		if (busy == pc) {
 			list_move(&pc->lru, list);
-			busy = 0;
+			busy = NULL;
 			spin_unlock_irqrestore(&zone->lru_lock, flags);
 			continue;
 		}
-- 
1.6.6.1.383.g5a9f

