Return-Path: <linux-kernel-owner+w=401wt.eu-S1755265AbZCJQoV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755265AbZCJQoV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 12:44:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755372AbZCJQnk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 12:43:40 -0400
Received: from zelda.netsplit.com ([87.194.19.211]:34583 "EHLO
	zelda.netsplit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753746AbZCJQni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 12:43:38 -0400
Message-Id: <c6919858453711fcfb8202da07b54dae483592c7.1236702228.git.scott@canonical.com>
In-Reply-To: <cover.1236702228.git.scott@canonical.com>
References: <cover.1236702228.git.scott@canonical.com>
From: Scott James Remnant <scott@canonical.com>
Date: Mon, 2 Mar 2009 16:44:00 +0000
Subject: [PATCH 02/31] netlink: Auto-load af_netlink module when socket opened.
To: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The af_netlink module is missing the net-pf-16 alias that would cause it
to be auto-loaded when a socket of that type is opened.  This patch adds
the alias.

While we normally build this module in, some users may choose to
reconfigure their kernel with this as a module.

Signed-off-by: Scott James Remnant <scott@canonical.com>
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 net/netlink/af_netlink.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 3ae3cb8..a9d5484 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -2007,3 +2007,5 @@ panic:
 }
 
 core_initcall(netlink_proto_init);
+
+MODULE_ALIAS_NETPROTO(PF_NETLINK);
-- 
1.6.0.5

