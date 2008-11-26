Return-Path: <linux-kernel-owner+w=401wt.eu-S1754024AbYKZNld@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024AbYKZNld (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 08:41:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752567AbYKZNlX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 08:41:23 -0500
Received: from mga14.intel.com ([143.182.124.37]:33067 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751954AbYKZNlW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 08:41:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,668,1220252400"; 
   d="scan'208";a="83174250"
Date: Wed, 26 Nov 2008 21:41:05 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Eric Van Hensbergen <ericvh@gmail.com>,
       Latchesar Ionkov <lucho@ionkov.net>,
       v9fs-developer@lists.sourceforge.net,
       LKML <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: [PATCH] vfs: initialize d_iname to null for long file names
Message-ID: <20081126134105.GA25795@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dentry->d_iname is currently uninitialized for long file names.  Init
it to null string to avoid bad behaviors on careless references to it.

Signed-off-by: Wu Fengguang <wfg@linux.intel.com>
---
diff --git a/fs/dcache.c b/fs/dcache.c
index a1d86c7..29d1768 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -929,6 +929,7 @@ struct dentry *d_alloc(struct dentry * parent, const struct qstr *name)
 			kmem_cache_free(dentry_cache, dentry); 
 			return NULL;
 		}
+		dentry->d_iname[0] = '\0';
 	} else  {
 		dname = dentry->d_iname;
 	}	
