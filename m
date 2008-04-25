Return-Path: <linux-kernel-owner+w=401wt.eu-S932994AbYDYXNR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932994AbYDYXNR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 19:13:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752781AbYDYXNF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 19:13:05 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:10780 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751870AbYDYXNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 19:13:04 -0400
Date: Fri, 25 Apr 2008 16:11:30 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, mporter@kernel.crashing.org
Subject: [PATCH -mm] rapidio: fix kernel-doc problems
Message-Id: <20080425161130.cc4e4062.randy.dunlap@oracle.com>
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
cc: Matt Porter <mporter@kernel.crashing.org>

RapidIO kernel-doc:
fix multiple kernel-doc warnings and correct some doc typos.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 arch/powerpc/sysdev/fsl_rio.c |   13 +++++++++++--
 drivers/rapidio/rio.c         |   10 +++++-----
 include/linux/rio.h           |    5 +++++
 3 files changed, 21 insertions(+), 7 deletions(-)

--- linux-2.6.25-mm1.orig/include/linux/rio.h
+++ linux-2.6.25-mm1/include/linux/rio.h
@@ -163,9 +163,13 @@ enum rio_phy_type {
  * @outb_msg: RIO outbound message event descriptors
  * @host_deviceid: Host device ID associated with this master port
  * @ops: configuration space functions
+ * @mops: memory operations functions
  * @id: Port ID, unique among all ports
  * @index: Port index, unique among all port interfaces of the same type
+ * @sys_size: RapidIO common transport system size
+ * @phy_type: RapidIO phy type
  * @name: Port name string
+ * @dev: struct device pointer
  * @priv: Master port private data
  */
 struct rio_mport {
@@ -329,6 +333,7 @@ struct rio_route_ops {
  * @node: Node in list of memories
  * @virt: The virtual address for mapped memory accessing.
  * @owner: The owner id of this memory.
+ * @dev: device-specific pointer
  * @size: The size of memory space, it should same to iores and riores.
  * @iores: The resource of local IO region for mapping.
  * @riores: The resource of mapped RapidIO space region.
--- linux-2.6.25-mm1.orig/drivers/rapidio/rio.c
+++ linux-2.6.25-mm1/drivers/rapidio/rio.c
@@ -353,7 +353,7 @@ int rio_release_outb_dbell(struct rio_de
  * @mport: Master port
  * @res: Resource need be requested.
  *
- * Return: 0 - Successed.
+ * Return: 0 - Success.
  */
 int rio_request_io_region(struct rio_mport *mport, struct resource *res)
 {
@@ -369,7 +369,7 @@ EXPORT_SYMBOL_GPL(rio_request_io_region)
  * @mport: Master port
  * @size: IO resource size
  * @name: Resource name
- * @flag: Flag for resource
+ * @flags: Flags for resource
  * @res: Return resource which has been allocated.
  */
 int rio_alloc_io(struct rio_mport *mport, resource_size_t size,
@@ -476,7 +476,7 @@ void rio_unmap_outb_region(struct rio_mp
  * @mport: Master port
  * @mem: Inbound region descriptor
  *
- * Return 0 is successed.
+ * Return 0 -- success.
  */
 int rio_release_inb_region(struct rio_mport *mport, struct rio_mem *mem)
 {
@@ -508,7 +508,7 @@ int rio_release_inb_region(struct rio_mp
  * @name: The region name
  * @owner: The region owner driver id
  *
- * Retrun: The rio_mem struction for inbound memory descriptor.
+ * Return: The rio_mem struction for inbound memory descriptor.
  *
  * This function is used for request RapidIO space inbound region. If the size
  * less than 4096 or not aligned to 2^N, it will be adjusted. The function will
@@ -582,7 +582,7 @@ err:
  * @mport: Master port
  * @mem: Outbound region descriptor
  *
- * Return 0 is successed.
+ * Return 0 -- success.
  */
 int rio_release_outb_region(struct rio_mport *mport, struct rio_mem *mem)
 {
--- linux-2.6.25-mm1.orig/arch/powerpc/sysdev/fsl_rio.c
+++ linux-2.6.25-mm1/arch/powerpc/sysdev/fsl_rio.c
@@ -198,6 +198,7 @@ struct rio_priv {
 
 /**
  * fsl_rio_doorbell_send - Send a MPC85xx doorbell message
+ * @mport: RapidIO master port info
  * @index: ID of RapidIO interface
  * @destid: Destination ID of target device
  * @data: 16-bit info field of RapidIO doorbell message
@@ -233,6 +234,7 @@ static int fsl_rio_doorbell_send(struct 
 
 /**
  * fsl_local_config_read - Generate a MPC85xx local config space read
+ * @mport: RapidIO master port info
  * @index: ID of RapdiIO interface
  * @offset: Offset into configuration space
  * @len: Length (in bytes) of the maintenance transaction
@@ -254,6 +256,7 @@ static int fsl_local_config_read(struct 
 
 /**
  * fsl_local_config_write - Generate a MPC85xx local config space write
+ * @mport: RapidIO master port info
  * @index: ID of RapdiIO interface
  * @offset: Offset into configuration space
  * @len: Length (in bytes) of the maintenance transaction
@@ -276,6 +279,7 @@ static int fsl_local_config_write(struct
 
 /**
  * fsl_rio_config_read - Generate a MPC85xx read maintenance transaction
+ * @mport: RapidIO master port info
  * @index: ID of RapdiIO interface
  * @destid: Destination ID of transaction
  * @hopcount: Number of hops to target device
@@ -317,6 +321,7 @@ fsl_rio_config_read(struct rio_mport *mp
 
 /**
  * fsl_rio_config_write - Generate a MPC85xx write maintenance transaction
+ * @mport: RapidIO master port info
  * @index: ID of RapdiIO interface
  * @destid: Destination ID of transaction
  * @hopcount: Number of hops to target device
@@ -357,6 +362,7 @@ fsl_rio_config_write(struct rio_mport *m
 
 /**
  * fsl_rio_map_inb_mem -- Mapping inbound memory region.
+ * @mport: RapidIO master port info
  * @lstart: Local memory space start address.
  * @rstart: RapidIO space start address.
  * @size: The mapping region size.
@@ -419,6 +425,7 @@ static int fsl_rio_map_inb_mem(struct ri
 
 /**
  * fsl_rio_map_outb_mem -- Mapping outbound memory region.
+ * @mport: RapidIO master port info
  * @lstart: Local memory space start address.
  * @rstart: RapidIO space start address.
  * @size: The mapping region size.
@@ -487,6 +494,7 @@ static int fsl_rio_map_outb_mem(struct r
 
 /**
  * fsl_rio_unmap_inb_mem -- Unmapping inbound memory region.
+ * @mport: RapidIO master port info
  * @lstart: Local memory space start address.
  */
 static void fsl_rio_unmap_inb_mem(struct rio_mport *mport,
@@ -510,6 +518,7 @@ static void fsl_rio_unmap_inb_mem(struct
 
 /**
  * fsl_rio_unmap_inb_mem -- Unmapping outbound memory region.
+ * @mport: RapidIO master port info
  * @lstart: Local memory space start address.
  */
 static void fsl_rio_unmap_outb_mem(struct rio_mport *mport,
@@ -1201,8 +1210,8 @@ static inline void fsl_rio_info(struct d
 }
 
 /**
- * fsl_rio_setup - Setup MPC85xx RapidIO interface
- * @fsl_rio_setup - Setup Freescale PowerPC RapidIO interface
+ * fsl_rio_setup - Setup Freescale PowerPC RapidIO interface
+ * @dev: of_device pointer
  *
  * Initializes MPC85xx RapidIO hardware interface, configures
  * master port with system-specific info, and registers the
