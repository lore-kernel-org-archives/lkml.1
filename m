Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753776Ab0BXBqF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 20:46:05 -0500
Received: from mga09.intel.com ([134.134.136.24]:31141 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753021Ab0BXBqA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 20:46:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,528,1262592000"; 
   d="scan'208";a="598597499"
Message-Id: <20100224013921.914926000@intel.com>
References: <20100224013858.506388000@intel.com>
User-Agent: quilt/0.46-1
Date: Tue, 23 Feb 2010 17:39:01 -0800
From: venkatesh.pallipadi@intel.com
To: Ingo Molnar <mingo@elte.hu>, H Peter Anvin <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Woodhouse <dwmw2@infradead.org>, Eric Paris <eparis@redhat.com>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>, linux-kernel@vger.kernel.org
Subject: [patch 3/3] jffs2: Fixup rb_root initializations to use RB_ROOT
Content-Disposition: inline; filename=0003-jffs2-fix.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

jffs2 uses rb_node = NULL; to zero rb_root.
The problem with this is that 17d9ddc72fb8bba0d4f678 in the
linux-next tree adds a new field to that struct which needs to be NULLas well.
This patch uses RB_ROOT as the intializer so all of the relevant fields will
be NULL'd.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
---
 fs/jffs2/readinode.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/jffs2/readinode.c b/fs/jffs2/readinode.c
index e22de83..d32ee94 100644
--- a/fs/jffs2/readinode.c
+++ b/fs/jffs2/readinode.c
@@ -567,7 +567,7 @@ static void jffs2_free_tmp_dnode_info_list(struct rb_root *list)
 			else BUG();
 		}
 	}
-	list->rb_node = NULL;
+	*list = RB_ROOT;
 }
 
 static void jffs2_free_full_dirent_list(struct jffs2_full_dirent *fd)
-- 
1.6.0.6

-- 

