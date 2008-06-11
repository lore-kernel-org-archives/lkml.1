Return-Path: <linux-kernel-owner+w=401wt.eu-S1757774AbYFLAfb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757774AbYFLAfb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 20:35:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753214AbYFLAep
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 20:34:45 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:38470 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751117AbYFLAem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 20:34:42 -0400
Date: Wed, 11 Jun 2008 14:37:29 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@osdl.org>
Subject: [PATCH -mm] mm/shmem.c: ret can be used uninitialized
Message-ID: <20080611193729.GD13365@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 6c4eb2ce2849308c4a745ec1f93001e5064a469c Mon Sep 17 00:00:00 2001
From: Serge Hallyn <serge@us.ibm.com>
Date: Wed, 11 Jun 2008 11:20:28 -0500
Subject: [PATCH -mm] mm/shmem.c: ret can be used uninitialized

Make sure ret is defined before check at line 1408.

Signed-off-by: Serge Hallyn <serge@us.ibm.com>
---
 mm/shmem.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index ad24be7..b326ff2 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1365,7 +1365,7 @@ repeat:
 		}
 
 		if (!filepage) {
-			int ret;
+			int ret = 0;
 
 			spin_unlock(&info->lock);
 			filepage = shmem_alloc_page(gfp, info, idx);
-- 
1.5.4.3

