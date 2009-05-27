Return-Path: <linux-kernel-owner+w=401wt.eu-S1763925AbZE0SAQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763925AbZE0SAQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 14:00:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756710AbZE0SAE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 14:00:04 -0400
Received: from mout3.freenet.de ([195.4.92.93]:45576 "EHLO mout3.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755228AbZE0SAD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 14:00:03 -0400
Date: Wed, 27 May 2009 19:59:55 +0200
From: Alex Riesen <raa.lkml@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org, Tom Talpey <tmtalpey@gmail.com>,
       Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [PATCH] Use formatting of module name in SUNRPC
Message-ID: <20090527175955.GB8969@blimp.localdomain>
Reply-To: Alex Riesen <raa.lkml@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Besides, the old code caused gcc-4.3.3 to produce the warning:
  "format not a string literal and no format arguments"

Signed-off-by: Alex Riesen <raa.lkml@gmail.com>
---
 net/sunrpc/xprt.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/net/sunrpc/xprt.c b/net/sunrpc/xprt.c
index 06ca058..82f62fd 100644
--- a/net/sunrpc/xprt.c
+++ b/net/sunrpc/xprt.c
@@ -162,7 +162,6 @@ EXPORT_SYMBOL_GPL(xprt_unregister_transport);
 int xprt_load_transport(const char *transport_name)
 {
 	struct xprt_class *t;
-	char module_name[sizeof t->name + 5];
 	int result;
 
 	result = 0;
@@ -174,9 +173,7 @@ int xprt_load_transport(const char *transport_name)
 		}
 	}
 	spin_unlock(&xprt_list_lock);
-	strcpy(module_name, "xprt");
-	strncat(module_name, transport_name, sizeof t->name);
-	result = request_module(module_name);
+	result = request_module("xprt%s", transport_name);
 out:
 	return result;
 }
-- 
1.6.3.1.197.g41544


