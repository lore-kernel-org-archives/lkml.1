Return-Path: <linux-kernel-owner+w=401wt.eu-S1756374AbZFESAR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756374AbZFESAR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 14:00:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755092AbZFESAG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 14:00:06 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:33624 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754395AbZFESAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 14:00:04 -0400
Message-ID: <4A295DD9.2050301@oracle.com>
Date: Fri, 05 Jun 2009 11:03:05 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       mirq-linux@rere.qmqm.pl, Pierre Ossman <pierre@ossman.eu>
Subject: [PATCH -next] mmc: cb710 cleanups
References: <20090605164104.3cebe18d.sfr@canb.auug.org.au>
In-Reply-To: <20090605164104.3cebe18d.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt008.oracle.com [141.146.116.17]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A09020B.4A295D15.0311:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

- don't define DEBUG, just use CONFIG_CB710_DEBUG or CONFIG_MMC_DEBUG
- fix printk format warnings

In file included from drivers/mmc/host/cb710-mmc.h:13,
                 from drivers/mmc/host/cb710-mmc.c:15:
include/linux/cb710.h:14:1: warning: "DEBUG" redefined
<command-line>: warning: this is the location of the previous definition

drivers/mmc/host/cb710-mmc.c:222: warning: format '%d' expects type 'int', but argument 4 has type 'size_t'
drivers/mmc/host/cb710-mmc.c:222: warning: format '%d' expects type 'int', but argument 6 has type 'size_t'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: mirq-linux@rere.qmqm.pl
Cc: Pierre Ossman <pierre@ossman.eu>
---
 drivers/mmc/host/cb710-mmc.c |    2 +-
 include/linux/cb710.h        |    4 ----
 2 files changed, 1 insertion(+), 5 deletions(-)

--- linux-next-20090605.orig/drivers/mmc/host/cb710-mmc.c
+++ linux-next-20090605/drivers/mmc/host/cb710-mmc.c
@@ -219,7 +219,7 @@ static void cb710_mmc_set_transfer_size(
 	cb710_write_port_32(slot, CB710_MMC_TRANSFER_SIZE_PORT,
 		((count - 1) << 16)|(blocksize - 1));
 
-	dev_vdbg(cb710_slot_dev(slot), "set up for %d block%s of %d bytes\n",
+	dev_vdbg(cb710_slot_dev(slot), "set up for %zu block%s of %zu bytes\n",
 		count, count == 1 ? "" : "s", blocksize);
 }
 
--- linux-next-20090605.orig/include/linux/cb710.h
+++ linux-next-20090605/include/linux/cb710.h
@@ -10,10 +10,6 @@
 #ifndef LINUX_CB710_DRIVER_H
 #define LINUX_CB710_DRIVER_H
 
-#ifdef CONFIG_CB710_DEBUG
-#define DEBUG
-#endif
-
 /* verify assumptions on platform_device framework */
 #define CONFIG_CB710_DEBUG_ASSUMPTIONS
 


-- 
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
