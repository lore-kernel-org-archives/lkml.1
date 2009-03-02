Return-Path: <linux-kernel-owner+w=401wt.eu-S1756889AbZCJQog@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756889AbZCJQog (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 12:44:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755546AbZCJQnl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 12:43:41 -0400
Received: from zelda.netsplit.com ([87.194.19.211]:34584 "EHLO
	zelda.netsplit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754679AbZCJQni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 12:43:38 -0400
Message-Id: <74b87ec3359e6e65d59cd6fb62a83fb469e6c8ae.1236702228.git.scott@canonical.com>
In-Reply-To: <cover.1236702228.git.scott@canonical.com>
References: <cover.1236702228.git.scott@canonical.com>
From: Scott James Remnant <scott@canonical.com>
Date: Mon, 2 Mar 2009 16:40:10 +0000
Subject: [PATCH 01/31] bridge: Auto-load bridge module when socket opened.
To: linux-kernel@vger.kernel.org
Cc: shemminger@linux-foundation.org, bridge@lists.linux-foundation.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The bridge module is missing the net-pf-7 alias that would cause it to
be auto-loaded when a socket of that type is opened.  This patch adds
the alias.

Signed-off-by: Scott James Remnant <scott@canonical.com>
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 net/bridge/br.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/net/bridge/br.c b/net/bridge/br.c
index 4d2c1f1..229daee 100644
--- a/net/bridge/br.c
+++ b/net/bridge/br.c
@@ -16,6 +16,7 @@
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
 #include <linux/init.h>
+#include <linux/net.h>
 #include <linux/llc.h>
 #include <net/llc.h>
 #include <net/stp.h>
@@ -108,3 +109,4 @@ module_init(br_init)
 module_exit(br_deinit)
 MODULE_LICENSE("GPL");
 MODULE_VERSION(BR_VERSION);
+MODULE_ALIAS_NETPROTO(PF_BRIDGE);
-- 
1.6.0.5

