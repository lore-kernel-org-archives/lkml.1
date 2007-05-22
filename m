Return-Path: <linux-kernel-owner+w=401wt.eu-S1764158AbXEVM5b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764158AbXEVM5b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 08:57:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756790AbXEVM5X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 08:57:23 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34610 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756489AbXEVM5W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 08:57:22 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 2/2] AF_RXRPC: Make call state names available if
	CONFIG_PROC_FS=n
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, netdeg@vger.kernel.org, dhowells@redhat.com
Date: Tue, 22 May 2007 13:56:10 +0100
Message-ID: <20070522125610.27625.60126.stgit@warthog.cambridge.redhat.com>
In-Reply-To: <20070522125605.27625.42682.stgit@warthog.cambridge.redhat.com>
References: <20070522125605.27625.42682.stgit@warthog.cambridge.redhat.com>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Make the call state names array available even if CONFIG_PROC_FS is disabled
as it's used in other places (such as debugging statements) too.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 net/rxrpc/ar-call.c |   19 +++++++++++++++++++
 net/rxrpc/ar-proc.c |   19 -------------------
 2 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/net/rxrpc/ar-call.c b/net/rxrpc/ar-call.c
index 4d92d88..3c04b00 100644
--- a/net/rxrpc/ar-call.c
+++ b/net/rxrpc/ar-call.c
@@ -15,6 +15,25 @@
 #include <net/af_rxrpc.h>
 #include "ar-internal.h"
 
+const char *rxrpc_call_states[] = {
+	[RXRPC_CALL_CLIENT_SEND_REQUEST]	= "ClSndReq",
+	[RXRPC_CALL_CLIENT_AWAIT_REPLY]		= "ClAwtRpl",
+	[RXRPC_CALL_CLIENT_RECV_REPLY]		= "ClRcvRpl",
+	[RXRPC_CALL_CLIENT_FINAL_ACK]		= "ClFnlACK",
+	[RXRPC_CALL_SERVER_SECURING]		= "SvSecure",
+	[RXRPC_CALL_SERVER_ACCEPTING]		= "SvAccept",
+	[RXRPC_CALL_SERVER_RECV_REQUEST]	= "SvRcvReq",
+	[RXRPC_CALL_SERVER_ACK_REQUEST]		= "SvAckReq",
+	[RXRPC_CALL_SERVER_SEND_REPLY]		= "SvSndRpl",
+	[RXRPC_CALL_SERVER_AWAIT_ACK]		= "SvAwtACK",
+	[RXRPC_CALL_COMPLETE]			= "Complete",
+	[RXRPC_CALL_SERVER_BUSY]		= "SvBusy  ",
+	[RXRPC_CALL_REMOTELY_ABORTED]		= "RmtAbort",
+	[RXRPC_CALL_LOCALLY_ABORTED]		= "LocAbort",
+	[RXRPC_CALL_NETWORK_ERROR]		= "NetError",
+	[RXRPC_CALL_DEAD]			= "Dead    ",
+};
+
 struct kmem_cache *rxrpc_call_jar;
 LIST_HEAD(rxrpc_calls);
 DEFINE_RWLOCK(rxrpc_call_lock);
diff --git a/net/rxrpc/ar-proc.c b/net/rxrpc/ar-proc.c
index 58f4b4e..1c0be0e 100644
--- a/net/rxrpc/ar-proc.c
+++ b/net/rxrpc/ar-proc.c
@@ -25,25 +25,6 @@ static const char *rxrpc_conn_states[] = {
 	[RXRPC_CONN_NETWORK_ERROR]	= "NetError",
 };
 
-const char *rxrpc_call_states[] = {
-	[RXRPC_CALL_CLIENT_SEND_REQUEST]	= "ClSndReq",
-	[RXRPC_CALL_CLIENT_AWAIT_REPLY]		= "ClAwtRpl",
-	[RXRPC_CALL_CLIENT_RECV_REPLY]		= "ClRcvRpl",
-	[RXRPC_CALL_CLIENT_FINAL_ACK]		= "ClFnlACK",
-	[RXRPC_CALL_SERVER_SECURING]		= "SvSecure",
-	[RXRPC_CALL_SERVER_ACCEPTING]		= "SvAccept",
-	[RXRPC_CALL_SERVER_RECV_REQUEST]	= "SvRcvReq",
-	[RXRPC_CALL_SERVER_ACK_REQUEST]		= "SvAckReq",
-	[RXRPC_CALL_SERVER_SEND_REPLY]		= "SvSndRpl",
-	[RXRPC_CALL_SERVER_AWAIT_ACK]		= "SvAwtACK",
-	[RXRPC_CALL_COMPLETE]			= "Complete",
-	[RXRPC_CALL_SERVER_BUSY]		= "SvBusy  ",
-	[RXRPC_CALL_REMOTELY_ABORTED]		= "RmtAbort",
-	[RXRPC_CALL_LOCALLY_ABORTED]		= "LocAbort",
-	[RXRPC_CALL_NETWORK_ERROR]		= "NetError",
-	[RXRPC_CALL_DEAD]			= "Dead    ",
-};
-
 /*
  * generate a list of extant and dead calls in /proc/net/rxrpc_calls
  */

