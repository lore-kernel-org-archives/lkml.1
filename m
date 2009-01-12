Return-Path: <linux-kernel-owner+w=401wt.eu-S1760231AbZALXIo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760231AbZALXIo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 18:08:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753560AbZALXIf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 18:08:35 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:65387 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752959AbZALXIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 18:08:35 -0500
Message-ID: <496BCD45.7010005@oracle.com>
Date: Mon, 12 Jan 2009 15:07:49 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Andrew Morton <akpm@linux-foundation.org>,
       "rdreier@cisco.com" <rdreier@cisco.com>
Subject: [PATCH mmotm] infiniband: fix iser dependency
References: <200901122101.n0CL1fnr017411@imap1.linux-foundation.org>
In-Reply-To: <200901122101.n0CL1fnr017411@imap1.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt705.oracle.com [141.146.40.83]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.496BCD4A.0024:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix ib_iser build to depend on INFINIBAND_ADDR_TRANS:

ERROR: "rdma_destroy_id" [drivers/infiniband/ulp/iser/ib_iser.ko] undefined!
ERROR: "rdma_connect" [drivers/infiniband/ulp/iser/ib_iser.ko] undefined!
ERROR: "rdma_destroy_qp" [drivers/infiniband/ulp/iser/ib_iser.ko] undefined!
ERROR: "rdma_create_id" [drivers/infiniband/ulp/iser/ib_iser.ko] undefined!
ERROR: "rdma_create_qp" [drivers/infiniband/ulp/iser/ib_iser.ko] undefined!
ERROR: "rdma_resolve_route" [drivers/infiniband/ulp/iser/ib_iser.ko] undefined!
ERROR: "rdma_disconnect" [drivers/infiniband/ulp/iser/ib_iser.ko] undefined!
ERROR: "rdma_resolve_addr" [drivers/infiniband/ulp/iser/ib_iser.ko] undefined!

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/infiniband/ulp/iser/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- mmotm-2009-0112-1301.orig/drivers/infiniband/ulp/iser/Kconfig
+++ mmotm-2009-0112-1301/drivers/infiniband/ulp/iser/Kconfig
@@ -1,6 +1,6 @@
 config INFINIBAND_ISER
 	tristate "iSCSI Extensions for RDMA (iSER)"
-	depends on SCSI && INET
+	depends on SCSI && INET && INFINIBAND_ADDR_TRANS
 	select SCSI_ISCSI_ATTRS
 	---help---
 	  Support for the iSCSI Extensions for RDMA (iSER) Protocol
