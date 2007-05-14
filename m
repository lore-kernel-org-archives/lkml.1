Return-Path: <linux-kernel-owner+w=401wt.eu-S1760008AbXENJMd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760008AbXENJMd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 05:12:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755420AbXENJM0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 05:12:26 -0400
Received: from mail.linux-boards.com ([192.114.83.142]:44867 "EHLO
	mail.linux-boards.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755519AbXENJMZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 05:12:25 -0400
X-Greylist: delayed 3018 seconds by postgrey-1.27 at vger.kernel.org; Mon, 14 May 2007 05:12:19 EDT
Message-ID: <46481C2C.8030402@compulab.co.il>
Date: Mon, 14 May 2007 11:22:04 +0300
From: Mike Rapoport <mike@compulab.co.il>
User-Agent: Thunderbird 2.0.0.0 (X11/20070506)
MIME-Version: 1.0
To: drzeus-mmc@drzeus.cx
CC: linux-kernel@vger.kernel.org
Subject: pxamci.c fails to compile
Content-Type: multipart/mixed;
 boundary="------------050300070007050401050005"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050300070007050401050005
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

The PXA MMC controller does not compile for PXA27x after MMC
reorganization, because it uses protocol defines to implement HW erratum
workaround (lines 232 - 247 of drivers/mmc/host/pxamci.c ).
The following patch fixes it


-- 
Sincerely yours,
Mike.



--------------050300070007050401050005
Content-Type: text/x-patch;
 name="mmc_fix.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="mmc_fix.patch"

diff --git a/drivers/mmc/host/pxamci.c b/drivers/mmc/host/pxamci.c
index d97d386..00fc99f 100644
--- a/drivers/mmc/host/pxamci.c
+++ b/drivers/mmc/host/pxamci.c
@@ -24,6 +24,7 @@
 #include <linux/interrupt.h>
 #include <linux/dma-mapping.h>
 #include <linux/mmc/host.h>
+#include <linux/mmc/mmc.h>
 
 #include <asm/dma.h>
 #include <asm/io.h>

--------------050300070007050401050005--
