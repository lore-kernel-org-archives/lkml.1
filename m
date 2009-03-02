Return-Path: <linux-kernel-owner+w=401wt.eu-S1757658AbZCJQsk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757658AbZCJQsk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 12:48:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755530AbZCJQnw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 12:43:52 -0400
Received: from zelda.netsplit.com ([87.194.19.211]:34625 "EHLO
	zelda.netsplit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755497AbZCJQnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 12:43:41 -0400
Message-Id: <c02d25a7a8784c9e83fc77ebc0b8fbdb9b713ec0.1236702228.git.scott@canonical.com>
In-Reply-To: <cover.1236702228.git.scott@canonical.com>
References: <cover.1236702228.git.scott@canonical.com>
From: Scott James Remnant <scott@canonical.com>
Date: Mon, 2 Mar 2009 17:09:44 +0000
Subject: [PATCH 07/31] scsi: Auto-load scsi_transport_iscsi module when socket opened.
To: linux-kernel@vger.kernel.org
Cc: michaelc@cs.wisc.edu, open-iscsi@googlegroups.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The scsi_transport_iscsi module is missing the net-pf-16-proto-8 alias
that would cause it to be auto-loaded when a socket of that type is
opened.  This patch adds the alias.

Signed-off-by: Scott James Remnant <scott@canonical.com>
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 drivers/scsi/scsi_transport_iscsi.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 75c9297..056fdae 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -22,6 +22,8 @@
  */
 #include <linux/module.h>
 #include <linux/mutex.h>
+#include <linux/net.h>
+#include <linux/netlink.h>
 #include <net/tcp.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_host.h>
@@ -2013,3 +2015,4 @@ MODULE_AUTHOR("Mike Christie <michaelc@cs.wisc.edu>, "
 MODULE_DESCRIPTION("iSCSI Transport Interface");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(ISCSI_TRANSPORT_VERSION);
+MODULE_ALIAS_NET_PF_PROTO(PF_NETLINK, NETLINK_ISCSI);
-- 
1.6.0.5

