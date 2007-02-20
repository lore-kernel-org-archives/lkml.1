Return-Path: <linux-kernel-owner+w=401wt.eu-S1750938AbXBTAWh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750938AbXBTAWh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 19:22:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750933AbXBTAUG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 19:20:06 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:36021 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750943AbXBTAGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 19:06:40 -0500
Date: Tue, 20 Feb 2007 01:06:39 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dhowells@redhat.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] kill net/rxrpc/rxrpc_syms.c
Message-ID: <20070220000639.GF13958@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves the EXPORT_SYMBOL's from net/rxrpc/rxrpc_syms.c to the 
files with the actual functions.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

This patch was already sent on:
- 26 Nov 2006

 net/rxrpc/Makefile     |    1 -
 net/rxrpc/call.c       |    5 +++++
 net/rxrpc/connection.c |    2 ++
 net/rxrpc/rxrpc_syms.c |   34 ----------------------------------
 net/rxrpc/transport.c  |    4 ++++
 5 files changed, 11 insertions(+), 35 deletions(-)

--- linux-2.6.19-rc6-mm1/net/rxrpc/Makefile.old	2006-11-26 04:49:25.000000000 +0100
+++ linux-2.6.19-rc6-mm1/net/rxrpc/Makefile	2006-11-26 04:50:08.000000000 +0100
@@ -12,7 +12,6 @@
 	krxtimod.o \
 	main.o \
 	peer.o \
-	rxrpc_syms.o \
 	transport.o
 
 ifeq ($(CONFIG_PROC_FS),y)
--- linux-2.6.19-rc6-mm1/net/rxrpc/call.c.old	2006-11-26 04:50:51.000000000 +0100
+++ linux-2.6.19-rc6-mm1/net/rxrpc/call.c	2006-11-26 04:51:58.000000000 +0100
@@ -314,6 +314,7 @@
 	_leave(" = %d", ret);
 	return ret;
 } /* end rxrpc_create_call() */
+EXPORT_SYMBOL(rxrpc_create_call);
 
 /*****************************************************************************/
 /*
@@ -465,6 +466,7 @@
 
 	_leave(" [destroyed]");
 } /* end rxrpc_put_call() */
+EXPORT_SYMBOL(rxrpc_put_call);
 
 /*****************************************************************************/
 /*
@@ -923,6 +925,7 @@
 	return __rxrpc_call_abort(call, error);
 
 } /* end rxrpc_call_abort() */
+EXPORT_SYMBOL(rxrpc_call_abort);
 
 /*****************************************************************************/
 /*
@@ -1910,6 +1913,7 @@
 	}
 
 } /* end rxrpc_call_read_data() */
+EXPORT_SYMBOL(rxrpc_call_read_data);
 
 /*****************************************************************************/
 /*
@@ -2076,6 +2080,7 @@
 	return ret;
 
 } /* end rxrpc_call_write_data() */
+EXPORT_SYMBOL(rxrpc_call_write_data);
 
 /*****************************************************************************/
 /*
--- linux-2.6.19-rc6-mm1/net/rxrpc/connection.c.old	2006-11-26 04:52:08.000000000 +0100
+++ linux-2.6.19-rc6-mm1/net/rxrpc/connection.c	2006-11-26 04:52:32.000000000 +0100
@@ -207,6 +207,7 @@
 	spin_unlock(&peer->conn_gylock);
 	goto make_active;
 } /* end rxrpc_create_connection() */
+EXPORT_SYMBOL(rxrpc_create_connection);
 
 /*****************************************************************************/
 /*
@@ -411,6 +412,7 @@
 
 	_leave(" [killed]");
 } /* end rxrpc_put_connection() */
+EXPORT_SYMBOL(rxrpc_put_connection);
 
 /*****************************************************************************/
 /*
--- linux-2.6.19-rc6-mm1/net/rxrpc/transport.c.old	2006-11-26 04:52:43.000000000 +0100
+++ linux-2.6.19-rc6-mm1/net/rxrpc/transport.c	2006-11-26 04:53:36.000000000 +0100
@@ -146,6 +146,7 @@
 	_leave(" = %d", ret);
 	return ret;
 } /* end rxrpc_create_transport() */
+EXPORT_SYMBOL(rxrpc_create_transport);
 
 /*****************************************************************************/
 /*
@@ -196,6 +197,7 @@
 
 	_leave("");
 } /* end rxrpc_put_transport() */
+EXPORT_SYMBOL(rxrpc_put_transport);
 
 /*****************************************************************************/
 /*
@@ -231,6 +233,7 @@
 	_leave("= %d", ret);
 	return ret;
 } /* end rxrpc_add_service() */
+EXPORT_SYMBOL(rxrpc_add_service);
 
 /*****************************************************************************/
 /*
@@ -248,6 +251,7 @@
 
 	_leave("");
 } /* end rxrpc_del_service() */
+EXPORT_SYMBOL(rxrpc_del_service);
 
 /*****************************************************************************/
 /*
--- linux-2.6.19-rc6-mm1/net/rxrpc/rxrpc_syms.c	2006-09-20 05:42:06.000000000 +0200
+++ /dev/null	2006-09-19 00:45:31.000000000 +0200
@@ -1,34 +0,0 @@
-/* rxrpc_syms.c: exported Rx RPC layer interface symbols
- *
- * Copyright (C) 2002 Red Hat, Inc. All Rights Reserved.
- * Written by David Howells (dhowells@redhat.com)
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * as published by the Free Software Foundation; either version
- * 2 of the License, or (at your option) any later version.
- */
-
-#include <linux/module.h>
-
-#include <rxrpc/transport.h>
-#include <rxrpc/connection.h>
-#include <rxrpc/call.h>
-#include <rxrpc/krxiod.h>
-
-/* call.c */
-EXPORT_SYMBOL(rxrpc_create_call);
-EXPORT_SYMBOL(rxrpc_put_call);
-EXPORT_SYMBOL(rxrpc_call_abort);
-EXPORT_SYMBOL(rxrpc_call_read_data);
-EXPORT_SYMBOL(rxrpc_call_write_data);
-
-/* connection.c */
-EXPORT_SYMBOL(rxrpc_create_connection);
-EXPORT_SYMBOL(rxrpc_put_connection);
-
-/* transport.c */
-EXPORT_SYMBOL(rxrpc_create_transport);
-EXPORT_SYMBOL(rxrpc_put_transport);
-EXPORT_SYMBOL(rxrpc_add_service);
-EXPORT_SYMBOL(rxrpc_del_service);


