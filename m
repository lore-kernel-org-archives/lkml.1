Return-Path: <linux-kernel-owner+w=401wt.eu-S932581AbYD3XrV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932581AbYD3XrV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 19:47:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757396AbYD3XrM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 19:47:12 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:27506 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756046AbYD3XrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 19:47:11 -0400
Date: Wed, 30 Apr 2008 16:45:58 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Kumar Gala <galak@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>,
       Andrew Morton <akpm@linux-foundation.org>, <Wei.Zhang@freescale.com>,
       torvalds@linux-foundation.org, mporter@kernel.crashing.org,
       benh@kernel.crashing.org, linuxppc-dev@ozlabs.org
Subject: [PATCH] rapidio: fix current kernel-doc notation
Message-Id: <20080430164558.03b5f517.randy.dunlap@oracle.com>
In-Reply-To: <4818EFEC.4080003@oracle.com>
References: <Pine.LNX.4.64.0804292009000.18219@shark.he.net>
	<20080430113500.dfe21880.akpm@linux-foundation.org>
	<51A34080-7981-4958-B225-4921FC95B84A@kernel.crashing.org>
	<20080430121239.28492328.akpm@linux-foundation.org>
	<18456.60948.463017.139935@cargo.ozlabs.ibm.com>
	<20080430151149.063920cf.randy.dunlap@oracle.com>
	<63DC9937-3C82-4744-8281-B9FDB941FEE1@kernel.crashing.org>
	<4818EFEC.4080003@oracle.com>
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

Fix current (-git16) missing docbook/kernel-doc notation in RapidIO files.

Warning(linux-2.6.25-git16//include/linux/rio.h:187): No description found for parameter 'sys_size'
Warning(linux-2.6.25-git16//include/linux/rio.h:187): No description found for parameter 'phy_type'

Warning(linux-2.6.25-git16//arch/powerpc/sysdev/fsl_rio.c:188): No description found for parameter 'mport'
Warning(linux-2.6.25-git16//arch/powerpc/sysdev/fsl_rio.c:224): No description found for parameter 'mport'
Warning(linux-2.6.25-git16//arch/powerpc/sysdev/fsl_rio.c:245): No description found for parameter 'mport'
Warning(linux-2.6.25-git16//arch/powerpc/sysdev/fsl_rio.c:270): No description found for parameter 'mport'
Warning(linux-2.6.25-git16//arch/powerpc/sysdev/fsl_rio.c:311): No description found for parameter 'mport'
Warning(linux-2.6.25-git16//arch/powerpc/sysdev/fsl_rio.c:996): No description found for parameter 'dev'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 arch/powerpc/sysdev/fsl_rio.c |    9 +++++++--
 include/linux/rio.h           |    2 ++
 2 files changed, 9 insertions(+), 2 deletions(-)

--- linux-2.6.25-git16.orig/include/linux/rio.h
+++ linux-2.6.25-git16/include/linux/rio.h
@@ -161,6 +161,8 @@ enum rio_phy_type {
  * @ops: configuration space functions
  * @id: Port ID, unique among all ports
  * @index: Port index, unique among all port interfaces of the same type
+ * @sys_size: RapidIO common transport system size
+ * @phy_type: RapidIO phy type
  * @name: Port name string
  * @priv: Master port private data
  */
--- linux-2.6.25-git16.orig/arch/powerpc/sysdev/fsl_rio.c
+++ linux-2.6.25-git16/arch/powerpc/sysdev/fsl_rio.c
@@ -176,6 +176,7 @@ struct rio_priv {
 
 /**
  * fsl_rio_doorbell_send - Send a MPC85xx doorbell message
+ * @mport: RapidIO master port info
  * @index: ID of RapidIO interface
  * @destid: Destination ID of target device
  * @data: 16-bit info field of RapidIO doorbell message
@@ -211,6 +212,7 @@ static int fsl_rio_doorbell_send(struct 
 
 /**
  * fsl_local_config_read - Generate a MPC85xx local config space read
+ * @mport: RapidIO master port info
  * @index: ID of RapdiIO interface
  * @offset: Offset into configuration space
  * @len: Length (in bytes) of the maintenance transaction
@@ -232,6 +234,7 @@ static int fsl_local_config_read(struct 
 
 /**
  * fsl_local_config_write - Generate a MPC85xx local config space write
+ * @mport: RapidIO master port info
  * @index: ID of RapdiIO interface
  * @offset: Offset into configuration space
  * @len: Length (in bytes) of the maintenance transaction
@@ -254,6 +257,7 @@ static int fsl_local_config_write(struct
 
 /**
  * fsl_rio_config_read - Generate a MPC85xx read maintenance transaction
+ * @mport: RapidIO master port info
  * @index: ID of RapdiIO interface
  * @destid: Destination ID of transaction
  * @hopcount: Number of hops to target device
@@ -295,6 +299,7 @@ fsl_rio_config_read(struct rio_mport *mp
 
 /**
  * fsl_rio_config_write - Generate a MPC85xx write maintenance transaction
+ * @mport: RapidIO master port info
  * @index: ID of RapdiIO interface
  * @destid: Destination ID of transaction
  * @hopcount: Number of hops to target device
@@ -985,8 +990,8 @@ static inline void fsl_rio_info(struct d
 }
 
 /**
- * fsl_rio_setup - Setup MPC85xx RapidIO interface
- * @fsl_rio_setup - Setup Freescale PowerPC RapidIO interface
+ * fsl_rio_setup - Setup Freescale PowerPC RapidIO interface
+ * @dev: of_device pointer
  *
  * Initializes MPC85xx RapidIO hardware interface, configures
  * master port with system-specific info, and registers the
