Return-Path: <linux-kernel-owner+w=401wt.eu-S1763000AbZAORv0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763000AbZAORv0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 12:51:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761030AbZAORuF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 12:50:05 -0500
Received: from relay2.sgi.com ([192.48.179.30]:45126 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758141AbZAORuA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 12:50:00 -0500
Message-Id: <20090115174959.582789186@attica.americas.sgi.com>
User-Agent: quilt/0.47-1
Date: Thu, 15 Jan 2009 11:49:50 -0600
From: holt@sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, dcn@sgi.com, <stable@kernel.org>
Subject: [patch 2/3] sgi-xpc: Remove NULL pointer dereference.
References: <20090115174948.731212661@attica.americas.sgi.com>
Content-Disposition: inline; filename=xpc_remove_null_pointer_deref
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robin Holt <holt@sgi.com>

If the bte copy fails, the attempt to retrieve payloads merely returns
a null pointer deref and not NULL as was expected.


Signed-off-by: Robin Holt <holt@sgi.com>
Signed-off-by: Dean Nelson <dcn@sgi.com>
Cc: <stable@kernel.org>

---

 drivers/misc/sgi-xp/xpc_sn2.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)
Index: xpc-fixes-20090115/drivers/misc/sgi-xp/xpc_sn2.c
===================================================================
--- xpc-fixes-20090115.orig/drivers/misc/sgi-xp/xpc_sn2.c	2009-01-15 10:21:56.024557255 -0600
+++ xpc-fixes-20090115/drivers/misc/sgi-xp/xpc_sn2.c	2009-01-15 10:50:00.953033142 -0600
@@ -1957,11 +1957,13 @@ xpc_get_deliverable_payload_sn2(struct x
 
 			msg = xpc_pull_remote_msg_sn2(ch, get);
 
-			DBUG_ON(msg != NULL && msg->number != get);
-			DBUG_ON(msg != NULL && (msg->flags & XPC_M_SN2_DONE));
-			DBUG_ON(msg != NULL && !(msg->flags & XPC_M_SN2_READY));
+			if (msg != NULL) {
+				DBUG_ON(msg->number != get);
+				DBUG_ON(msg->flags & XPC_M_SN2_DONE);
+				DBUG_ON(!(msg->flags & XPC_M_SN2_READY));
 
-			payload = &msg->payload;
+				payload = &msg->payload;
+			}
 			break;
 		}
 

