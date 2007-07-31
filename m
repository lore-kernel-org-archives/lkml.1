Return-Path: <linux-kernel-owner+w=401wt.eu-S934335AbXGaV5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934335AbXGaV5S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 17:57:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758292AbXGaV5A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 17:57:00 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:1032 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757211AbXGaV46 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 17:56:58 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 68] drivers/net/s2io.c: kmalloc + memset conversion to k[cz]alloc
Date: Tue, 31 Jul 2007 23:56:58 +0200
User-Agent: KMail/1.9.5
Cc: kernel-janitors@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       netdev@vger.kernel.org, jgarzik@pobox.com
References: <200707311845.48807.m.kozlowski@tuxland.pl>
In-Reply-To: <200707311845.48807.m.kozlowski@tuxland.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707312356.58934.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 drivers/net/s2io.c | 235587 -> 235340 (-247 bytes)
 drivers/net/s2io.o | 460768 -> 460120 (-648 bytes)

 drivers/net/s2io.c |   14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

--- linux-2.6.23-rc1-mm1-a/drivers/net/s2io.c	2007-07-26 13:07:42.000000000 +0200
+++ linux-2.6.23-rc1-mm1-b/drivers/net/s2io.c	2007-07-31 13:44:02.000000000 +0200
@@ -531,7 +531,7 @@ static int init_shared_mem(struct s2io_n
 	for (i = 0; i < config->tx_fifo_num; i++) {
 		int fifo_len = config->tx_cfg[i].fifo_len;
 		int list_holder_size = fifo_len * sizeof(struct list_info_hold);
-		mac_control->fifos[i].list_info = kmalloc(list_holder_size,
+		mac_control->fifos[i].list_info = kzalloc(list_holder_size,
 							  GFP_KERNEL);
 		if (!mac_control->fifos[i].list_info) {
 			DBG_PRINT(INFO_DBG,
@@ -539,7 +539,6 @@ static int init_shared_mem(struct s2io_n
 			return -ENOMEM;
 		}
 		mem_allocated += list_holder_size;
-		memset(mac_control->fifos[i].list_info, 0, list_holder_size);
 	}
 	for (i = 0; i < config->tx_fifo_num; i++) {
 		int page_num = TXD_MEM_PAGE_CNT(config->tx_cfg[i].fifo_len,
@@ -3788,9 +3787,9 @@ static int s2io_enable_msi_x(struct s2io
 	u16 msi_control; /* Temp variable */
 	int ret, i, j, msix_indx = 1;

-	nic->entries = kmalloc(MAX_REQUESTED_MSI_X * sizeof(struct msix_entry),
+	nic->entries = kcalloc(MAX_REQUESTED_MSI_X, sizeof(struct msix_entry),
 			       GFP_KERNEL);
-	if (nic->entries == NULL) {
+	if (!nic->entries) {
 		DBG_PRINT(INFO_DBG, "%s: Memory allocation failed\n", \
 			__FUNCTION__);
 		nic->mac_control.stats_info->sw_stat.mem_alloc_fail_cnt++;
@@ -3798,12 +3797,11 @@ static int s2io_enable_msi_x(struct s2io
 	}
 	nic->mac_control.stats_info->sw_stat.mem_allocated
 		+= (MAX_REQUESTED_MSI_X * sizeof(struct msix_entry));
-	memset(nic->entries, 0,MAX_REQUESTED_MSI_X * sizeof(struct msix_entry));

 	nic->s2io_entries =
-		kmalloc(MAX_REQUESTED_MSI_X * sizeof(struct s2io_msix_entry),
+		kcalloc(MAX_REQUESTED_MSI_X, sizeof(struct s2io_msix_entry),
 				   GFP_KERNEL);
-	if (nic->s2io_entries == NULL) {
+	if (!nic->s2io_entries) {
 		DBG_PRINT(INFO_DBG, "%s: Memory allocation failed\n",
 			__FUNCTION__);
 		nic->mac_control.stats_info->sw_stat.mem_alloc_fail_cnt++;
@@ -3814,8 +3812,6 @@ static int s2io_enable_msi_x(struct s2io
 	}
 	 nic->mac_control.stats_info->sw_stat.mem_allocated
 		+= (MAX_REQUESTED_MSI_X * sizeof(struct s2io_msix_entry));
-	memset(nic->s2io_entries, 0,
-	       MAX_REQUESTED_MSI_X * sizeof(struct s2io_msix_entry));

 	for (i=0; i< MAX_REQUESTED_MSI_X; i++) {
 		nic->entries[i].entry = i;
