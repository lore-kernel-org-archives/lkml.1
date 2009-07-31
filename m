Return-Path: <linux-kernel-owner+w=401wt.eu-S1752950AbZGaWB5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752950AbZGaWB5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 18:01:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752195AbZGaWB4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 18:01:56 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:32505 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751611AbZGaWBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 18:01:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=WcPtfvoXrfkkZVg2ZnpsYYKWO5TkTcd5xA67+Vu2njmzKBwNxe48KlAe8fQwkPobHD
         tuq8lH0eVHDXFbuUpmp/qCMH+VGA/SLsz/prqq8y4sbqletuGDQPRgx/Xhj694thml35
         xgsgx/AR0qjGinKkiL9p0yn/Eh7SHZzCLYQq8=
MIME-Version: 1.0
Date: Fri, 31 Jul 2009 23:01:54 +0100
Message-ID: <5c43c2d40907311501t1a817cb5lff8d9eac5d01f231@mail.gmail.com>
Subject: [PATCH] vnic_dev: Use #define for wait time constant.
From: =?ISO-8859-1?Q?Andr=E9_Nogueira?= <andre.neo.net@gmail.com>
To: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This trivial patch just uses #define for wait time constant.

Signed-off-by: Andre Nogueira <andre.neo.net@gmail.com>

---
 drivers/scsi/fnic/vnic_dev.c |   58 ++++++++++++++---------------------------
 1 files changed, 20 insertions(+), 38 deletions(-)

diff --git a/drivers/scsi/fnic/vnic_dev.c b/drivers/scsi/fnic/vnic_dev.c
index 5667706..b000c65 100644
--- a/drivers/scsi/fnic/vnic_dev.c
+++ b/drivers/scsi/fnic/vnic_dev.c
@@ -53,6 +53,7 @@ struct vnic_dev {
 	(sizeof(struct vnic_resource_header) + \
 	sizeof(struct vnic_resource) * RES_TYPE_MAX)
 #define VNIC_RES_STRIDE	128
+#define VNIC_WAIT	1000

 void *vnic_dev_priv(struct vnic_dev *vdev)
 {
@@ -293,7 +294,6 @@ int vnic_dev_fw_info(struct vnic_dev *vdev,
 	struct vnic_devcmd_fw_info **fw_info)
 {
 	u64 a0, a1 = 0;
-	int wait = 1000;
 	int err = 0;

 	if (!vdev->fw_info) {
@@ -306,7 +306,7 @@ int vnic_dev_fw_info(struct vnic_dev *vdev,
 		a0 = vdev->fw_info_pa;

 		/* only get fw_info once and cache it */
-		err = vnic_dev_cmd(vdev, CMD_MCPU_FW_INFO, &a0, &a1, wait);
+		err = vnic_dev_cmd(vdev, CMD_MCPU_FW_INFO, &a0, &a1, VNIC_WAIT);
 	}

 	*fw_info = vdev->fw_info;
@@ -318,13 +318,12 @@ int vnic_dev_spec(struct vnic_dev *vdev,
unsigned int offset, unsigned int size,
 	void *value)
 {
 	u64 a0, a1;
-	int wait = 1000;
 	int err;

 	a0 = offset;
 	a1 = size;

-	err = vnic_dev_cmd(vdev, CMD_DEV_SPEC, &a0, &a1, wait);
+	err = vnic_dev_cmd(vdev, CMD_DEV_SPEC, &a0, &a1, VNIC_WAIT);

 	switch (size) {
 	case 1:
@@ -350,14 +349,12 @@ int vnic_dev_spec(struct vnic_dev *vdev,
unsigned int offset, unsigned int size,
 int vnic_dev_stats_clear(struct vnic_dev *vdev)
 {
 	u64 a0 = 0, a1 = 0;
-	int wait = 1000;
-	return vnic_dev_cmd(vdev, CMD_STATS_CLEAR, &a0, &a1, wait);
+	return vnic_dev_cmd(vdev, CMD_STATS_CLEAR, &a0, &a1, VNIC_WAIT);
 }

 int vnic_dev_stats_dump(struct vnic_dev *vdev, struct vnic_stats **stats)
 {
 	u64 a0, a1;
-	int wait = 1000;

 	if (!vdev->stats) {
 		vdev->stats = pci_alloc_consistent(vdev->pdev,
@@ -370,46 +367,41 @@ int vnic_dev_stats_dump(struct vnic_dev *vdev,
struct vnic_stats **stats)
 	a0 = vdev->stats_pa;
 	a1 = sizeof(struct vnic_stats);

-	return vnic_dev_cmd(vdev, CMD_STATS_DUMP, &a0, &a1, wait);
+	return vnic_dev_cmd(vdev, CMD_STATS_DUMP, &a0, &a1, VNIC_WAIT);
 }

 int vnic_dev_close(struct vnic_dev *vdev)
 {
 	u64 a0 = 0, a1 = 0;
-	int wait = 1000;
-	return vnic_dev_cmd(vdev, CMD_CLOSE, &a0, &a1, wait);
+	return vnic_dev_cmd(vdev, CMD_CLOSE, &a0, &a1, VNIC_WAIT);
 }

 int vnic_dev_enable(struct vnic_dev *vdev)
 {
 	u64 a0 = 0, a1 = 0;
-	int wait = 1000;
-	return vnic_dev_cmd(vdev, CMD_ENABLE, &a0, &a1, wait);
+	return vnic_dev_cmd(vdev, CMD_ENABLE, &a0, &a1, VNIC_WAIT);
 }

 int vnic_dev_disable(struct vnic_dev *vdev)
 {
 	u64 a0 = 0, a1 = 0;
-	int wait = 1000;
-	return vnic_dev_cmd(vdev, CMD_DISABLE, &a0, &a1, wait);
+	return vnic_dev_cmd(vdev, CMD_DISABLE, &a0, &a1, VNIC_WAIT);
 }

 int vnic_dev_open(struct vnic_dev *vdev, int arg)
 {
 	u64 a0 = (u32)arg, a1 = 0;
-	int wait = 1000;
-	return vnic_dev_cmd(vdev, CMD_OPEN, &a0, &a1, wait);
+	return vnic_dev_cmd(vdev, CMD_OPEN, &a0, &a1, VNIC_WAIT);
 }

 int vnic_dev_open_done(struct vnic_dev *vdev, int *done)
 {
 	u64 a0 = 0, a1 = 0;
-	int wait = 1000;
 	int err;

 	*done = 0;

-	err = vnic_dev_cmd(vdev, CMD_OPEN_STATUS, &a0, &a1, wait);
+	err = vnic_dev_cmd(vdev, CMD_OPEN_STATUS, &a0, &a1, VNIC_WAIT);
 	if (err)
 		return err;

@@ -421,19 +413,17 @@ int vnic_dev_open_done(struct vnic_dev *vdev, int *done)
 int vnic_dev_soft_reset(struct vnic_dev *vdev, int arg)
 {
 	u64 a0 = (u32)arg, a1 = 0;
-	int wait = 1000;
-	return vnic_dev_cmd(vdev, CMD_SOFT_RESET, &a0, &a1, wait);
+	return vnic_dev_cmd(vdev, CMD_SOFT_RESET, &a0, &a1, VNIC_WAIT);
 }

 int vnic_dev_soft_reset_done(struct vnic_dev *vdev, int *done)
 {
 	u64 a0 = 0, a1 = 0;
-	int wait = 1000;
 	int err;

 	*done = 0;

-	err = vnic_dev_cmd(vdev, CMD_SOFT_RESET_STATUS, &a0, &a1, wait);
+	err = vnic_dev_cmd(vdev, CMD_SOFT_RESET_STATUS, &a0, &a1, VNIC_WAIT);
 	if (err)
 		return err;

@@ -445,20 +435,18 @@ int vnic_dev_soft_reset_done(struct vnic_dev
*vdev, int *done)
 int vnic_dev_hang_notify(struct vnic_dev *vdev)
 {
 	u64 a0, a1;
-	int wait = 1000;
-	return vnic_dev_cmd(vdev, CMD_HANG_NOTIFY, &a0, &a1, wait);
+	return vnic_dev_cmd(vdev, CMD_HANG_NOTIFY, &a0, &a1, VNIC_WAIT);
 }

 int vnic_dev_mac_addr(struct vnic_dev *vdev, u8 *mac_addr)
 {
 	u64 a0, a1;
-	int wait = 1000;
 	int err, i;

 	for (i = 0; i < ETH_ALEN; i++)
 		mac_addr[i] = 0;

-	err = vnic_dev_cmd(vdev, CMD_MAC_ADDR, &a0, &a1, wait);
+	err = vnic_dev_cmd(vdev, CMD_MAC_ADDR, &a0, &a1, VNIC_WAIT);
 	if (err)
 		return err;

@@ -472,7 +460,6 @@ void vnic_dev_packet_filter(struct vnic_dev *vdev,
int directed, int multicast,
 	int broadcast, int promisc, int allmulti)
 {
 	u64 a0, a1 = 0;
-	int wait = 1000;
 	int err;

 	a0 = (directed ? CMD_PFILTER_DIRECTED : 0) |
@@ -481,7 +468,7 @@ void vnic_dev_packet_filter(struct vnic_dev *vdev,
int directed, int multicast,
 	     (promisc ? CMD_PFILTER_PROMISCUOUS : 0) |
 	     (allmulti ? CMD_PFILTER_ALL_MULTICAST : 0);

-	err = vnic_dev_cmd(vdev, CMD_PACKET_FILTER, &a0, &a1, wait);
+	err = vnic_dev_cmd(vdev, CMD_PACKET_FILTER, &a0, &a1, VNIC_WAIT);
 	if (err)
 		printk(KERN_ERR "Can't set packet filter\n");
 }
@@ -489,14 +476,13 @@ void vnic_dev_packet_filter(struct vnic_dev
*vdev, int directed, int multicast,
 void vnic_dev_add_addr(struct vnic_dev *vdev, u8 *addr)
 {
 	u64 a0 = 0, a1 = 0;
-	int wait = 1000;
 	int err;
 	int i;

 	for (i = 0; i < ETH_ALEN; i++)
 		((u8 *)&a0)[i] = addr[i];

-	err = vnic_dev_cmd(vdev, CMD_ADDR_ADD, &a0, &a1, wait);
+	err = vnic_dev_cmd(vdev, CMD_ADDR_ADD, &a0, &a1, VNIC_WAIT);
 	if (err)
 		printk(KERN_ERR
 			"Can't add addr [%02x:%02x:%02x:%02x:%02x:%02x], %d\n",
@@ -507,14 +493,13 @@ void vnic_dev_add_addr(struct vnic_dev *vdev, u8 *addr)
 void vnic_dev_del_addr(struct vnic_dev *vdev, u8 *addr)
 {
 	u64 a0 = 0, a1 = 0;
-	int wait = 1000;
 	int err;
 	int i;

 	for (i = 0; i < ETH_ALEN; i++)
 		((u8 *)&a0)[i] = addr[i];

-	err = vnic_dev_cmd(vdev, CMD_ADDR_DEL, &a0, &a1, wait);
+	err = vnic_dev_cmd(vdev, CMD_ADDR_DEL, &a0, &a1, VNIC_WAIT);
 	if (err)
 		printk(KERN_ERR
 			"Can't del addr [%02x:%02x:%02x:%02x:%02x:%02x], %d\n",
@@ -525,7 +510,6 @@ void vnic_dev_del_addr(struct vnic_dev *vdev, u8 *addr)
 int vnic_dev_notify_set(struct vnic_dev *vdev, u16 intr)
 {
 	u64 a0, a1;
-	int wait = 1000;

 	if (!vdev->notify) {
 		vdev->notify = pci_alloc_consistent(vdev->pdev,
@@ -539,19 +523,18 @@ int vnic_dev_notify_set(struct vnic_dev *vdev, u16 intr)
 	a1 = ((u64)intr << 32) & 0x0000ffff00000000ULL;
 	a1 += sizeof(struct vnic_devcmd_notify);

-	return vnic_dev_cmd(vdev, CMD_NOTIFY, &a0, &a1, wait);
+	return vnic_dev_cmd(vdev, CMD_NOTIFY, &a0, &a1, VNIC_WAIT);
 }

 void vnic_dev_notify_unset(struct vnic_dev *vdev)
 {
 	u64 a0, a1;
-	int wait = 1000;

 	a0 = 0;  /* paddr = 0 to unset notify buffer */
 	a1 = 0x0000ffff00000000ULL; /* intr num = -1 to unreg for intr */
 	a1 += sizeof(struct vnic_devcmd_notify);

-	vnic_dev_cmd(vdev, CMD_NOTIFY, &a0, &a1, wait);
+	vnic_dev_cmd(vdev, CMD_NOTIFY, &a0, &a1, VNIC_WAIT);
 }

 static int vnic_dev_notify_ready(struct vnic_dev *vdev)
@@ -579,8 +562,7 @@ static int vnic_dev_notify_ready(struct vnic_dev *vdev)
 int vnic_dev_init(struct vnic_dev *vdev, int arg)
 {
 	u64 a0 = (u32)arg, a1 = 0;
-	int wait = 1000;
-	return vnic_dev_cmd(vdev, CMD_INIT, &a0, &a1, wait);
+	return vnic_dev_cmd(vdev, CMD_INIT, &a0, &a1, VNIC_WAIT);
 }

 int vnic_dev_link_status(struct vnic_dev *vdev)
-- 
1.6.2.5
