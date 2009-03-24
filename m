Return-Path: <linux-kernel-owner+w=401wt.eu-S1761531AbZCXOUA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761531AbZCXOUA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 10:20:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760777AbZCXOLw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 10:11:52 -0400
Received: from mx2.redhat.com ([66.187.237.31]:37604 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759380AbZCXOLs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 10:11:48 -0400
From: David Teigland <teigland@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Joe Perches <joe@perches.com>
Subject: [PATCH 2/7] dlm: use ipv6_addr_copy
Date: Tue, 24 Mar 2009 09:07:47 -0500
Message-Id: <1237903672-18913-3-git-send-email-teigland@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: David Teigland <teigland@redhat.com>
---
 fs/dlm/lowcomms.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/dlm/lowcomms.c b/fs/dlm/lowcomms.c
index 103a5eb..bf09262 100644
--- a/fs/dlm/lowcomms.c
+++ b/fs/dlm/lowcomms.c
@@ -53,6 +53,7 @@
 #include <linux/mutex.h>
 #include <linux/sctp.h>
 #include <net/sctp/user.h>
+#include <net/ipv6.h>
 
 #include "dlm_internal.h"
 #include "lowcomms.h"
@@ -250,8 +251,7 @@ static int nodeid_to_addr(int nodeid, struct sockaddr *retaddr)
 	} else {
 		struct sockaddr_in6 *in6  = (struct sockaddr_in6 *) &addr;
 		struct sockaddr_in6 *ret6 = (struct sockaddr_in6 *) retaddr;
-		memcpy(&ret6->sin6_addr, &in6->sin6_addr,
-		       sizeof(in6->sin6_addr));
+		ipv6_addr_copy(&ret6->sin6_addr, &in6->sin6_addr);
 	}
 
 	return 0;
-- 
1.5.5.6

