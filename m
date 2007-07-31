Return-Path: <linux-kernel-owner+w=401wt.eu-S934882AbXGaVv1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934882AbXGaVv1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 17:51:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762418AbXGaVvM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 17:51:12 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:2490 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759921AbXGaVvK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 17:51:10 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 64] drivers/scsi/qla2xxx/qla_init.c: mostly kmalloc + memset conversion to k[cz]alloc
Date: Tue, 31 Jul 2007 23:51:10 +0200
User-Agent: KMail/1.9.5
Cc: kernel-janitors@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-driver@qlogic.com, linux-scsi@vger.kernel.org
References: <200707311845.48807.m.kozlowski@tuxland.pl>
In-Reply-To: <200707311845.48807.m.kozlowski@tuxland.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707312351.10536.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 drivers/scsi/qla2xxx/qla_init.c | 107445 -> 107327 (-118 bytes)
 drivers/scsi/qla2xxx/qla_init.o | 237540 -> 237424 (-116 bytes)

 drivers/scsi/qla2xxx/qla_init.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

--- linux-2.6.23-rc1-mm1-a/drivers/scsi/qla2xxx/qla_init.c	2007-07-26 13:07:42.000000000 +0200
+++ linux-2.6.23-rc1-mm1-b/drivers/scsi/qla2xxx/qla_init.c	2007-07-31 14:24:51.000000000 +0200
@@ -1787,12 +1787,11 @@ qla2x00_alloc_fcport(scsi_qla_host_t *ha
 {
 	fc_port_t *fcport;

-	fcport = kmalloc(sizeof(fc_port_t), flags);
-	if (fcport == NULL)
-		return (fcport);
+	fcport = kzalloc(sizeof(fc_port_t), flags);
+	if (!fcport)
+		return NULL;

 	/* Setup fcport template structure. */
-	memset(fcport, 0, sizeof (fc_port_t));
 	fcport->ha = ha;
 	fcport->vp_idx = ha->vp_idx;
 	fcport->port_type = FCT_UNKNOWN;
@@ -1802,7 +1801,7 @@ qla2x00_alloc_fcport(scsi_qla_host_t *ha
 	fcport->supported_classes = FC_COS_UNSPECIFIED;
 	spin_lock_init(&fcport->rport_lock);

-	return (fcport);
+	return fcport;
 }

 /*
@@ -2497,13 +2496,12 @@ qla2x00_find_all_fabric_devs(scsi_qla_ho
 	rval = QLA_SUCCESS;

 	/* Try GID_PT to get device list, else GAN. */
-	swl = kmalloc(sizeof(sw_info_t) * MAX_FIBRE_DEVICES, GFP_ATOMIC);
-	if (swl == NULL) {
+	swl = kcalloc(MAX_FIBRE_DEVICES, sizeof(sw_info_t), GFP_ATOMIC);
+	if (!swl) {
 		/*EMPTY*/
 		DEBUG2(printk("scsi(%ld): GID_PT allocations failed, fallback "
 		    "on GA_NXT\n", ha->host_no));
 	} else {
-		memset(swl, 0, sizeof(sw_info_t) * MAX_FIBRE_DEVICES);
 		if (qla2x00_gid_pt(ha, swl) != QLA_SUCCESS) {
 			kfree(swl);
 			swl = NULL;
