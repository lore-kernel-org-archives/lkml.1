Return-Path: <linux-kernel-owner+w=401wt.eu-S933216AbXAYEjo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933216AbXAYEjo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 23:39:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933214AbXAYEjo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 23:39:44 -0500
Received: from adsl-207-214-87-82.dsl.snfc21.pacbell.net ([207.214.87.82]:34753
	"EHLO lade.trondhjem.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933216AbXAYEjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 23:39:43 -0500
X-Greylist: delayed 429 seconds by postgrey-1.27 at vger.kernel.org; Wed, 24 Jan 2007 23:39:43 EST
From: Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [PATCH] MM: Remove [PATCH] invalidate_inode_pages2_range() debug
Date: Wed, 24 Jan 2007 20:32:33 -0800
To: akpm@osdl.org
Cc: Chuck Lever <chuck.lever@oracle.com>, Steve Dickson <SteveD@redhat.com>,
       Adrian Bunk <bunk@stusta.de>, linux-kernel@vger.kernel.org
Message-Id: <20070125043233.16260.83569.stgit@lade.trondhjem.org>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
User-Agent: StGIT/0.9
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Trond Myklebust <Trond.Myklebust@netapp.com>

NFS can handle the case where invalidate_inode_pages2_range() fails, so the
premise behind commit 8258d4a574d3a8c01f0ef68aa26b969398a0e140 is now gone.

Remove the WARN_ON_ONCE() which is causing users grief as we can see from
http://bugzilla.kernel.org/show_bug.cgi?id=7826

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
---

 mm/truncate.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/mm/truncate.c b/mm/truncate.c
index 6c79ca4..54ae710 100644
--- a/mm/truncate.c
+++ b/mm/truncate.c
@@ -422,7 +422,6 @@ int invalidate_inode_pages2_range(struct
 		pagevec_release(&pvec);
 		cond_resched();
 	}
-	WARN_ON_ONCE(ret);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(invalidate_inode_pages2_range);
