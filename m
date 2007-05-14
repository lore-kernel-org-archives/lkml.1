Return-Path: <linux-kernel-owner+w=401wt.eu-S1031392AbXENL5x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031392AbXENL5x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 07:57:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031762AbXENLlO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 07:41:14 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57714 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031757AbXENLlK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 07:41:10 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
	Directors: Michael Cunningham (USA), Charlie Peters (USA) and
	David Owens (Ireland)
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] AF_RXRPC: AF_RXRPC depends on IPv4
To: akpm@osdl.org, avuton@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       netdev@vger.kernel.org, dhowells@redhat.com
Date: Mon, 14 May 2007 12:41:02 +0100
Message-ID: <20070514114102.7883.64787.stgit@warthog.cambridge.redhat.com>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add a dependency for CONFIG_AF_RXRPC on CONFIG_INET.  This fixes this error:

net/built-in.o: In function `rxrpc_get_peer':
(.text+0x42824): undefined reference to `ip_route_output_key'

Signed-off-by: David Howells <dhowells@redhat.com>
---

 net/rxrpc/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/rxrpc/Kconfig b/net/rxrpc/Kconfig
index 91b3d52..e662f1d 100644
--- a/net/rxrpc/Kconfig
+++ b/net/rxrpc/Kconfig
@@ -4,7 +4,7 @@
 
 config AF_RXRPC
 	tristate "RxRPC session sockets"
-	depends on EXPERIMENTAL
+	depends on INET && EXPERIMENTAL
 	select KEYS
 	help
 	  Say Y or M here to include support for RxRPC session sockets (just

