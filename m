Return-Path: <linux-kernel-owner+w=401wt.eu-S1766015AbYBGAoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766015AbYBGAoU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 19:44:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934307AbYBGAaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 19:30:05 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:18429 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934109AbYBGAaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 19:30:00 -0500
Date: Wed, 6 Feb 2008 16:27:54 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: khali@linux-fr.org, shemminger@linux-foundation.org,
       akpm <akpm@linux-foundation.org>
Subject: [PATCH -mm] apanel: fix kconfig dependencies
Message-Id: <20080206162754.73114579.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Add I2C to config since the driver makes several i2c*() calls.

Add PCI to config because the config selects I2C_I801, which depends
on PCI, but currently config* does not follow dependency chains,
so randconfig can enable INPUT_APANEL even when PCI is not enabled,
which leads to these warnings:
linux-2.6.24-mm1/drivers/i2c/busses/i2c-i801.c:641: error: implicit declaration of function 'pci_request_region'
/linux-2.6.24-mm1/drivers/i2c/busses/i2c-i801.c:681: error: implicit declaration of function 'pci_release_region'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/input/misc/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.24-mm1.orig/drivers/input/misc/Kconfig
+++ linux-2.6.24-mm1/drivers/input/misc/Kconfig
@@ -42,7 +42,7 @@ config INPUT_M68K_BEEP
 
 config INPUT_APANEL
 	tristate "Fujitsu Lifebook Application Panel buttons"
-	depends on X86
+	depends on X86 && I2C && PCI
 	select I2C_I801
 	select INPUT_POLLDEV
 	select CHECK_SIGNATURE
