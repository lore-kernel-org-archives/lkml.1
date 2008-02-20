Return-Path: <linux-kernel-owner+w=401wt.eu-S1759320AbYBTEa7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759320AbYBTEa7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 23:30:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751713AbYBTEau
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 23:30:50 -0500
Received: from gate.crashing.org ([63.228.1.57]:45615 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751616AbYBTEat (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 23:30:49 -0500
Date: Tue, 19 Feb 2008 22:27:48 -0600 (CST)
From: Kumar Gala <galak@kernel.crashing.org>
X-X-Sender: galak@blarg.am.freescale.net
To: davem@davemloft.net
cc: sparclinux@vger.kernel.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [LMB]: Fix lmb_add_region if region should be added at the
 head
Message-ID: <Pine.LNX.4.64.0802192227170.2215@blarg.am.freescale.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We introduced a bug in fixing lmb_add_region to handle an initial
region being non-zero.  Before that fix it was impossible to insert
a region at the head of the list since the first region always started
at zero.

Now that its possible for the first region to be non-zero we need to
check to see if the new region should be added at the head and if so
actually add it.

Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
---
 lib/lmb.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/lib/lmb.c b/lib/lmb.c
index e3c8dcb..3c43b95 100644
--- a/lib/lmb.c
+++ b/lib/lmb.c
@@ -184,6 +184,11 @@ static long __init lmb_add_region(struct lmb_region *rgn, u64 base, u64 size)
 			break;
 		}
 	}
+
+	if (base < rgn->region[0].base) {
+		rgn->region[0].base = base;
+		rgn->region[0].size = size;
+	}
 	rgn->cnt++;

 	return 0;
-- 
1.5.3.8

