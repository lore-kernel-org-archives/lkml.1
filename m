Return-Path: <linux-kernel-owner+w=401wt.eu-S1756533AbYAZQnX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756533AbYAZQnX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 11:43:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752532AbYAZQnR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 11:43:17 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:58139 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752452AbYAZQnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 11:43:16 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 26 Jan 2008 17:42:45 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 1/3] firewire: fw-sbp2: unsigned int vs. unsigned
To: linux1394-devel@lists.sourceforge.net
cc: Jarod Wilson <jwilson@redhat.com>,
       =?iso-8859-1?Q?Kristian_H=F8gsberg?= <krh@redhat.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.1198d1dd6ae8d623@s5r6.in-berlin.de>
Message-ID: <tkrat.ba2cdaa770a41cd5@s5r6.in-berlin.de>
References: <tkrat.1198d1dd6ae8d623@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Standardize on "unsigned int" style.
Sort some struct members thematically.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
Depends on Jarod's latest fw-sbp2 patch which I didn't even push to
linux1394-2.6.git yet.

 drivers/firewire/fw-sbp2.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

Index: linux/drivers/firewire/fw-sbp2.c
===================================================================
--- linux.orig/drivers/firewire/fw-sbp2.c
+++ linux/drivers/firewire/fw-sbp2.c
@@ -141,15 +141,13 @@ struct sbp2_logical_unit {
 struct sbp2_target {
 	struct kref kref;
 	struct fw_unit *unit;
+	struct list_head lu_list;
 
 	u64 management_agent_address;
 	int directory_id;
 	int node_id;
 	int address_high;
-
-	unsigned workarounds;
-	struct list_head lu_list;
-
+	unsigned int workarounds;
 	unsigned int mgt_orb_timeout;
 };
 
@@ -160,7 +158,7 @@ struct sbp2_target {
  */
 #define SBP2_MIN_LOGIN_ORB_TIMEOUT	5000U	/* Timeout in ms */
 #define SBP2_MAX_LOGIN_ORB_TIMEOUT	40000U	/* Timeout in ms */
-#define SBP2_ORB_TIMEOUT		2000	/* Timeout in ms */
+#define SBP2_ORB_TIMEOUT		2000U	/* Timeout in ms */
 #define SBP2_ORB_NULL			0x80000000
 #define SBP2_MAX_SG_ELEMENT_LENGTH	0xf000
 
@@ -297,7 +295,7 @@ struct sbp2_command_orb {
 static const struct {
 	u32 firmware_revision;
 	u32 model;
-	unsigned workarounds;
+	unsigned int workarounds;
 } sbp2_workarounds_table[] = {
 	/* DViCO Momobay CX-1 with TSB42AA9 bridge */ {
 		.firmware_revision	= 0x002800,
@@ -836,7 +834,7 @@ static void sbp2_init_workarounds(struct
 				  u32 firmware_revision)
 {
 	int i;
-	unsigned w = sbp2_param_workarounds;
+	unsigned int w = sbp2_param_workarounds;
 
 	if (w)
 		fw_notify("Please notify linux1394-devel@lists.sourceforge.net "
@@ -1197,7 +1195,7 @@ static int sbp2_scsi_queuecommand(struct
 	struct sbp2_logical_unit *lu = cmd->device->hostdata;
 	struct fw_device *device = fw_device(lu->tgt->unit->device.parent);
 	struct sbp2_command_orb *orb;
-	unsigned max_payload;
+	unsigned int max_payload;
 	int retval = SCSI_MLQUEUE_HOST_BUSY;
 
 	/*

-- 
Stefan Richter
-=====-==--- ---= ==-=-
http://arcgraph.de/sr/

