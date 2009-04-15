Return-Path: <linux-kernel-owner+w=401wt.eu-S1755110AbZDOTrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755110AbZDOTrU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 15:47:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753690AbZDOTrH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 15:47:07 -0400
Received: from exprod6og108.obsmtp.com ([64.18.1.21]:41251 "HELO
	exprod6og108.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752902AbZDOTrG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 15:47:06 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: [PATCH] net/sunrpc/svc.c: fix sparse warning
Date: Wed, 15 Apr 2009 15:46:13 -0400
Message-ID: <BD79186B4FD85F4B8E60E381CAEE1909015F8D20@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] net/sunrpc/svc.c: fix sparse warning
Thread-Index: Acm+AtV39LjdCuviRZmjMEuIOnSUvg==
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 15 Apr 2009 19:47:03.0267 (UTC) FILETIME=[F2FD5330:01C9BE02]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix sparse warning in net/sunrpc/svc.c.

	warning: symbol 'node' shadows an earlier one

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>

---

diff --git a/net/sunrpc/svc.c b/net/sunrpc/svc.c
index 8847add..e781135 100644
--- a/net/sunrpc/svc.c
+++ b/net/sunrpc/svc.c
@@ -122,7 +122,7 @@ module_param_call(pool_mode, param_set_pool_mode,
param_get_pool_mode,
 static int
 svc_pool_map_choose_mode(void)
 {
-	unsigned int node;
+	unsigned int nid;
 
 	if (num_online_nodes() > 1) {
 		/*
@@ -132,8 +132,8 @@ svc_pool_map_choose_mode(void)
 		return SVC_POOL_PERNODE;
 	}
 
-	node = any_online_node(node_online_map);
-	if (nr_cpus_node(node) > 2) {
+	nid = any_online_node(node_online_map);
+	if (nr_cpus_node(nid) > 2) {
 		/*
 		 * Non-trivial SMP, or CONFIG_NUMA on
 		 * non-NUMA hardware, e.g. with a generic 
