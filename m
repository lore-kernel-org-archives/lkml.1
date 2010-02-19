Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754674Ab0BSUAS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 15:00:18 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:48916 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404Ab0BSUAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 15:00:16 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Fri, 19 Feb 2010 21:00:02 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] firewire: core: fix an information leak
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.41cd283579a10140@s5r6.in-berlin.de>
Message-ID: <tkrat.6a1e3df293205a1b@s5r6.in-berlin.de>
References: <tkrat.206fe651745e1dd7@s5r6.in-berlin.de>
 <tkrat.040d1f77b4f1ddb4@s5r6.in-berlin.de>
 <tkrat.41cd283579a10140@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a device exposes a sparsely populated configuration ROM,
firewire-core's sysfs interface and character device file interface
showed random data in the gaps between config ROM blocks.  Fix this by
zero-initialization of the config ROM reader's scratch buffer.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/core-device.c |    1 +
 1 file changed, 1 insertion(+)

Index: b/drivers/firewire/core-device.c
===================================================================
--- a/drivers/firewire/core-device.c
+++ b/drivers/firewire/core-device.c
@@ -514,6 +514,7 @@ static int read_bus_info_block(struct fw
 		return -ENOMEM;
 
 	stack = &rom[READ_BIB_ROM_SIZE];
+	memset(rom, 0, sizeof(*rom) * READ_BIB_ROM_SIZE);
 
 	device->max_speed = SCODE_100;
 

-- 
Stefan Richter
-=====-==-=- --=- =--==
http://arcgraph.de/sr/

