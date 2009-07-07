Return-Path: <linux-kernel-owner+w=401wt.eu-S1756073AbZGGOHh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756073AbZGGOHh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 10:07:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757371AbZGGOHO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 10:07:14 -0400
Received: from mtagate1.de.ibm.com ([195.212.17.161]:48393 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756803AbZGGOHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 10:07:12 -0400
Date: Tue, 7 Jul 2009 16:06:39 +0200
From: Alexander Schmidt <alexs@linux.vnet.ibm.com>
To: Roland Dreier <rolandd@cisco.com>
Cc: of-ewg <ewg@lists.openfabrics.org>,
       of-general <general@lists.openfabrics.org>,
       linuxppc-dev <linuxppc-dev@ozlabs.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Stefan Roscher <stefan.roscher@de.ibm.com>,
       Hoang-Nam Nguyen <HNGUYEN@linux.vnet.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>
Subject: [PATCH] ehca: use port autodetect mode as default
Message-ID: <20090707160639.6b45bf4d@BL3D1974.boeblingen.de.ibm.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch sets the port autodetect mode as default for the ehca driver. The
autodetect code has been in the kernel for several releases now and has
proved to be stable.

---
Roland, please queue this change for 2.6.32 if you are okay with it.

 drivers/infiniband/hw/ehca/ehca_main.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- infiniband.git.orig/drivers/infiniband/hw/ehca/ehca_main.c
+++ infiniband.git/drivers/infiniband/hw/ehca/ehca_main.c
@@ -52,7 +52,7 @@
 #include "ehca_tools.h"
 #include "hcp_if.h"
 
-#define HCAD_VERSION "0028"
+#define HCAD_VERSION "0029"
 
 MODULE_LICENSE("Dual BSD/GPL");
 MODULE_AUTHOR("Christoph Raisch <raisch@de.ibm.com>");
@@ -64,7 +64,7 @@ static int ehca_hw_level      = 0;
 static int ehca_poll_all_eqs  = 1;
 
 int ehca_debug_level   = 0;
-int ehca_nr_ports      = 2;
+int ehca_nr_ports      = -1;
 int ehca_use_hp_mr     = 0;
 int ehca_port_act_time = 30;
 int ehca_static_rate   = -1;
@@ -95,8 +95,8 @@ MODULE_PARM_DESC(hw_level,
 		 "Hardware level (0: autosensing (default), "
 		 "0x10..0x14: eHCA, 0x20..0x23: eHCA2)");
 MODULE_PARM_DESC(nr_ports,
-		 "number of connected ports (-1: autodetect, 1: port one only, "
-		 "2: two ports (default)");
+		 "number of connected ports (-1: autodetect (default), "
+		 "1: port one only, 2: two ports)");
 MODULE_PARM_DESC(use_hp_mr,
 		 "Use high performance MRs (default: no)");
 MODULE_PARM_DESC(port_act_time,
