Return-Path: <linux-kernel-owner+w=401wt.eu-S932783AbXBERCh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932783AbXBERCh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 12:02:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932838AbXBERCg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 12:02:36 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:30905 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932783AbXBERCf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 12:02:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=GRNYP4nJVbdzD00F7ePylnGurN2dcrwv1Jva1EaKxlTc9R/TuVZWL1RUDj1IIsEfBlHEla6ws0RmhD0YEuydj3iGALjgOO/tWFGFYCVt8RfxjF/+SaEZLLiAMH+LvDcDIFylji+x8rTLLhTDtVYNjMbsNhNHwYrAQyZiRUkrdw4=
Date: Mon, 5 Feb 2007 18:56:22 +0200
To: yi.zhu@intel.com, linville@tuxdriver.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 2.6.20] ipw2100: Use ARRAY_SIZE macro when appropriate
Message-ID: <20070205165622.GF3896@Ahmed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070205165429.GD3896@Ahmed>
User-Agent: Mutt/1.5.11
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

A patch to use ARRAY_SIZE macro already defined in kernel.h.

Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
---
Patch is compile tested.

diff --git a/drivers/net/wireless/ipw2100.c b/drivers/net/wireless/ipw2100.c
index b85857a..a9d944a 100644
--- a/drivers/net/wireless/ipw2100.c
+++ b/drivers/net/wireless/ipw2100.c
@@ -2888,7 +2888,7 @@ static int __ipw2100_tx_process(struct ipw2100_priv *priv)
 
 #ifdef CONFIG_IPW2100_DEBUG
 		if (packet->info.c_struct.cmd->host_command_reg <
-		    sizeof(command_types) / sizeof(*command_types))
+		    ARRAY_SIZE(command_types))
 			IPW_DEBUG_TX("Command '%s (%d)' processed: %d.\n",
 				     command_types[packet->info.c_struct.cmd->
 						   host_command_reg],
@@ -3736,7 +3736,7 @@ static ssize_t show_registers(struct device *d, struct device_attribute *attr,
 
 	out += sprintf(out, "%30s [Address ] : Hex\n", "Register");
 
-	for (i = 0; i < (sizeof(hw_data) / sizeof(*hw_data)); i++) {
+	for (i = 0; i < ARRAY_SIZE(hw_data); i++) {
 		read_register(dev, hw_data[i].addr, &val);
 		out += sprintf(out, "%30s [%08X] : %08X\n",
 			       hw_data[i].name, hw_data[i].addr, val);
@@ -3757,7 +3757,7 @@ static ssize_t show_hardware(struct device *d, struct device_attribute *attr,
 
 	out += sprintf(out, "%30s [Address ] : Hex\n", "NIC entry");
 
-	for (i = 0; i < (sizeof(nic_data) / sizeof(*nic_data)); i++) {
+	for (i = 0; i < ARRAY_SIZE(nic_data); i++) {
 		u8 tmp8;
 		u16 tmp16;
 		u32 tmp32;
@@ -3894,13 +3894,11 @@ static ssize_t show_ordinals(struct device *d, struct device_attribute *attr,
 	if (priv->status & STATUS_RF_KILL_MASK)
 		return 0;
 
-	if (loop >= sizeof(ord_data) / sizeof(*ord_data))
+	if (loop >= ARRAY_SIZE(ord_data))
 		loop = 0;
 
 	/* sysfs provides us PAGE_SIZE buffer */
-	while (len < PAGE_SIZE - 128 &&
-	       loop < (sizeof(ord_data) / sizeof(*ord_data))) {
-
+	while (len < PAGE_SIZE - 128 && loop < ARRAY_SIZE(ord_data)) {
 		val_len = sizeof(u32);
 
 		if (ipw2100_get_ordinal(priv, ord_data[loop].index, &val,
@@ -6589,7 +6587,7 @@ static const long ipw2100_rates_11b[] = {
 	11000000
 };
 
-#define RATE_COUNT (sizeof(ipw2100_rates_11b) / sizeof(ipw2100_rates_11b[0]))
+#define RATE_COUNT ARRAY_SIZE(ipw2100_rates_11b)
 
 static int ipw2100_wx_get_name(struct net_device *dev,
 			       struct iw_request_info *info,


-- 
Ahmed S. Darwish
http://darwish-07.blogspot.com
