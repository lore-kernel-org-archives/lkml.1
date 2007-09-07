Return-Path: <linux-kernel-owner+w=401wt.eu-S1758595AbXIGU22@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758595AbXIGU22 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 16:28:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752190AbXIGU2V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 16:28:21 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:34782 "EHLO
	dwalker5.mvista.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752104AbXIGU2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 16:28:20 -0400
Message-Id: <20070907202625.702755508@mvista.com>
User-Agent: quilt/0.46-1
Date: Fri, 07 Sep 2007 13:26:25 -0700
From: Daniel Walker <dwalker@mvista.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] net: myri10ge: force select inet_lro
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This driver uses the inet_lro facilities , but it doesn't force it
to be enabled .. Someone would have to know to enable inet_lro if
they select the driver .. 

Instead, just force INET_LRO if this driver is selected..

Signed-off-by: Daniel Walker <dwalker@mvista.com>

---
 drivers/net/Kconfig |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6.22/drivers/net/Kconfig
===================================================================
--- linux-2.6.22.orig/drivers/net/Kconfig
+++ linux-2.6.22/drivers/net/Kconfig
@@ -2103,6 +2103,7 @@ source "drivers/net/ixp2000/Kconfig"
 config MYRI_SBUS
 	tristate "MyriCOM Gigabit Ethernet support"
 	depends on SBUS
+	select INET_LRO
 	help
 	  This driver supports MyriCOM Sbus gigabit Ethernet cards.
 
-- 

-- 
