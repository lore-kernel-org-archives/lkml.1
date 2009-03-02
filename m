Return-Path: <linux-kernel-owner+w=401wt.eu-S1756194AbZCJQn6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756194AbZCJQn6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 12:43:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755118AbZCJQnj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 12:43:39 -0400
Received: from zelda.netsplit.com ([87.194.19.211]:34580 "EHLO
	zelda.netsplit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754000AbZCJQni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 12:43:38 -0400
Message-Id: <57f2570f73bb02c80489fe38ef75d518f19f27e0.1236702228.git.scott@canonical.com>
In-Reply-To: <cover.1236702228.git.scott@canonical.com>
References: <cover.1236702228.git.scott@canonical.com>
From: Scott James Remnant <scott@canonical.com>
Date: Mon, 2 Mar 2009 17:06:37 +0000
Subject: [PATCH 06/31] connector: Auto-load cn module when socket opened.
To: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The cn module is missing the net-pf-16-proto-11 alias that would cause
it to be auto-loaded when a socket of that type is opened.  This patch
adds the alias.

Signed-off-by: Scott James Remnant <scott@canonical.com>
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 drivers/connector/connector.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/connector/connector.c b/drivers/connector/connector.c
index bf48300..c610089 100644
--- a/drivers/connector/connector.c
+++ b/drivers/connector/connector.c
@@ -23,6 +23,7 @@
 #include <linux/module.h>
 #include <linux/list.h>
 #include <linux/skbuff.h>
+#include <linux/net.h>
 #include <linux/netlink.h>
 #include <linux/moduleparam.h>
 #include <linux/connector.h>
@@ -35,6 +36,7 @@
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Evgeniy Polyakov <johnpol@2ka.mipt.ru>");
 MODULE_DESCRIPTION("Generic userspace <-> kernelspace connector.");
+MODULE_ALIAS_NET_PF_PROTO(PF_NETLINK, NETLINK_CONNECTOR);
 
 static u32 cn_idx = CN_IDX_CONNECTOR;
 static u32 cn_val = CN_VAL_CONNECTOR;
-- 
1.6.0.5

