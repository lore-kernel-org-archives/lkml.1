Return-Path: <linux-kernel-owner+w=401wt.eu-S1763736AbZAQVs3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763736AbZAQVs3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 16:48:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753135AbZAQVsE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 16:48:04 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:44666 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755133AbZAQVsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 16:48:01 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 17 Jan 2009 22:47:58 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 4/4] firewire: core: remove condition which is always false
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.ca8b7763ca31e24d@s5r6.in-berlin.de>
Message-ID: <tkrat.34873244488c3e6c@s5r6.in-berlin.de>
References: <tkrat.ca8b7763ca31e24d@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

reread_bus_info_block() only gets to see devices whose config_rom_length
is at least 6 (ROM header, bus info block, root directory header).

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-device.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/drivers/firewire/fw-device.c
===================================================================
--- linux.orig/drivers/firewire/fw-device.c
+++ linux/drivers/firewire/fw-device.c
@@ -887,15 +887,15 @@ static int reread_bus_info_block(struct 
 	for (i = 0; i < 6; i++) {
 		if (read_rom(device, generation, i, &q) != RCODE_COMPLETE)
 			return REREAD_BIB_ERROR;
 
 		if (i == 0 && q == 0)
 			return REREAD_BIB_GONE;
 
-		if (i > device->config_rom_length || q != device->config_rom[i])
+		if (q != device->config_rom[i])
 			return REREAD_BIB_CHANGED;
 	}
 
 	return REREAD_BIB_UNCHANGED;
 }
 
 static void fw_device_refresh(struct work_struct *work)

-- 
Stefan Richter
-=====-==--= ---= =---=
http://arcgraph.de/sr/

