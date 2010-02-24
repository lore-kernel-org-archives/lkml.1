Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753964Ab0BXBqJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 20:46:09 -0500
Received: from mga09.intel.com ([134.134.136.24]:31141 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753463Ab0BXBqB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 20:46:01 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,528,1262592000"; 
   d="scan'208";a="598597500"
Message-Id: <20100224013921.782403000@intel.com>
References: <20100224013858.506388000@intel.com>
User-Agent: quilt/0.46-1
Date: Tue, 23 Feb 2010 17:39:00 -0800
From: venkatesh.pallipadi@intel.com
To: Ingo Molnar <mingo@elte.hu>, H Peter Anvin <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andreas Dilger <adilger@sun.com>, Eric Paris <eparis@redhat.com>
Cc: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>, linux-kernel@vger.kernel.org
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Subject: [patch 2/3] ext3: Fixup rb_root initializations to use RB_ROOT
Content-Disposition: inline; filename=0002-ext3-fix.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ext3 uses rb_node = NULL; to zero rb_root.
The problem with this is that 17d9ddc72fb8bba0d4f678 in the
linux-next tree adds a new field to that struct which needs to be NULLas well.
This patch uses RB_ROOT as the intializer so all of the relevant fields will
be NULL'd.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
---
 fs/ext3/dir.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext3/dir.c b/fs/ext3/dir.c
index 373fa90..e2e72c3 100644
--- a/fs/ext3/dir.c
+++ b/fs/ext3/dir.c
@@ -297,7 +297,7 @@ static void free_rb_tree_fname(struct rb_root *root)
 			kfree (old);
 		}
 		if (!parent)
-			root->rb_node = NULL;
+			*root = RB_ROOT;
 		else if (parent->rb_left == n)
 			parent->rb_left = NULL;
 		else if (parent->rb_right == n)
-- 
1.6.0.6

-- 

