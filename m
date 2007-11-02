Return-Path: <linux-kernel-owner+w=401wt.eu-S1760879AbXKBSyy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760879AbXKBSyy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 14:54:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757427AbXKBSyq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 14:54:46 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:53671 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757350AbXKBSyp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 14:54:45 -0400
Date: Fri, 2 Nov 2007 13:52:15 -0500
From: Michael Halcrow <mhalcrow@us.ibm.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, ecryptfs-devel@lists.sourceforge.net,
       trevor.highland@gmail.com
Subject: [PATCH 2/3] eCryptfs: Increment extent_offset once per loop interation
Message-ID: <20071102185215.GB30760@localhost.austin.ibm.com>
Reply-To: Michael Halcrow <mhalcrow@us.ibm.com>
References: <20071102185033.GB30487@localhost.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071102185033.GB30487@localhost.austin.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The extent_offset is getting incremented twice per loop iteration
through any given page. It should only be getting incremented
once. This bug should only impact hosts with >4K page sizes.

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
---
 fs/ecryptfs/crypto.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/fs/ecryptfs/crypto.c b/fs/ecryptfs/crypto.c
index ca0dfea..4f14d4c 100644
--- a/fs/ecryptfs/crypto.c
+++ b/fs/ecryptfs/crypto.c
@@ -503,7 +503,6 @@ int ecryptfs_encrypt_page(struct page *page)
 					"\n", rc);
 			goto out;
 		}
-		extent_offset++;
 	}
 out:
 	kfree(enc_extent_virt);
@@ -639,7 +638,6 @@ int ecryptfs_decrypt_page(struct page *page)
 			       "rc = [%d]\n", __FUNCTION__, rc);
 			goto out;
 		}
-		extent_offset++;
 	}
 out:
 	kfree(enc_extent_virt);
-- 
1.5.0.6

