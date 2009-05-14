Return-Path: <linux-kernel-owner+w=401wt.eu-S1754376AbZENRZ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754376AbZENRZ7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 13:25:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752756AbZENRZt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 13:25:49 -0400
Received: from exprod6ob111.obsmtp.com ([64.18.1.26]:58395 "HELO psmtp.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752694AbZENRZt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 13:25:49 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [PATCH] net/sunrpc/svc.c: fix sparse warning
Date: Thu, 14 May 2009 13:25:45 -0400
Message-ID: <BD79186B4FD85F4B8E60E381CAEE19090179A5BE@mi8nycmail19.Mi8.com>
In-Reply-To: <20090514160030.GA5675@fieldses.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] net/sunrpc/svc.c: fix sparse warning
Thread-Index: AcnUrRxkV0P6L2ykRJWhReQaXq1jwAACi5Eg
References: <BD79186B4FD85F4B8E60E381CAEE1909015F8D20@mi8nycmail19.Mi8.com> <20090416190601.GA1145@fieldses.org> <BD79186B4FD85F4B8E60E381CAEE1909015F8F97@mi8nycmail19.Mi8.com> <20090511230541.GL793@fieldses.org> <BD79186B4FD85F4B8E60E381CAEE19090179A55B@mi8nycmail19.Mi8.com> <20090514160030.GA5675@fieldses.org>
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 14 May 2009 17:25:46.0252 (UTC) FILETIME=[04463CC0:01C9D4B9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change any_online_node() from a macro to a static inline function.

any_online_node() uses the symbol 'node', this causes a sparse
warning in net/sunrpc/svc.c.  Changing the macro to a static
inline function removes the sparse warning and will prevent the
same warning from possibly occurring in the future.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>

---

diff --git a/include/linux/nodemask.h b/include/linux/nodemask.h
index 848025c..16df302 100644
--- a/include/linux/nodemask.h
+++ b/include/linux/nodemask.h
@@ -440,15 +440,6 @@ static inline int num_node_state(enum node_states state)
 #define node_online_map 	node_states[N_ONLINE]
 #define node_possible_map 	node_states[N_POSSIBLE]
 
-#define any_online_node(mask)			\
-({						\
-	int node;				\
-	for_each_node_mask(node, (mask))	\
-		if (node_online(node))		\
-			break;			\
-	node;					\
-})
-
 #define num_online_nodes()	num_node_state(N_ONLINE)
 #define num_possible_nodes()	num_node_state(N_POSSIBLE)
 #define node_online(node)	node_state((node), N_ONLINE)
@@ -460,4 +451,15 @@ static inline int num_node_state(enum node_states state)
 #define for_each_node(node)	   for_each_node_state(node, N_POSSIBLE)
 #define for_each_online_node(node) for_each_node_state(node, N_ONLINE)
 
+static inline int any_online_node(nodemask_t mask)
+{
+	int node;
+
+	for_each_node_mask(node, mask) {
+		if (node_online(node))
+			break;
+	}
+	return node;
+}
+
 #endif /* __LINUX_NODEMASK_H */ 
