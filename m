Return-Path: <linux-kernel-owner+w=401wt.eu-S1753557AbYL2VXr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753557AbYL2VXr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 16:23:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752844AbYL2VXg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 16:23:36 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:57142 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752600AbYL2VXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 16:23:35 -0500
X-Greylist: delayed 1318 seconds by postgrey-1.27 at vger.kernel.org; Mon, 29 Dec 2008 16:23:35 EST
Date: Mon, 29 Dec 2008 13:23:12 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: scsi <linux-scsi@vger.kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, kxie@chelsio.com,
       akpm <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       jejb <James.Bottomley@hansenpartnership.com>
Subject: [PATCH -next v2] cxgb3i: use same dependencies & selects as
 CHELSIO_T3
Message-Id: <20081229132312.10934479.randy.dunlap@oracle.com>
In-Reply-To: <20081229130110.67d5271a.randy.dunlap@oracle.com>
References: <20081230031621.60acd90b.sfr@canb.auug.org.au>
	<20081229130110.67d5271a.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt705.oracle.com [141.146.40.83]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.49593FC5.01A1:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Make the CXGB iSCSI driver (that selects the CXGB net driver) have the same
dependencies as the net driver, since kconfig doesn't do that automatically.
Also make it select INET_LRO & FW_LOADER like the net driver does.

drivers/net/cxgb3/cxgb3_main.c:269: error: implicit declaration of function 'pci_disable_msix'
drivers/net/cxgb3/cxgb3_main.c:272: error: implicit declaration of function 'pci_disable_msi'
drivers/net/cxgb3/cxgb3_main.c:2778: error: array type has incomplete element type
drivers/net/cxgb3/cxgb3_main.c:2781: warning: type defaults to 'int' in declaration of 'type name'
drivers/net/cxgb3/cxgb3_main.c:2781: warning: type defaults to 'int' in declaration of 'type name'
drivers/net/cxgb3/cxgb3_main.c:2781: error: size of array 'type name' is negative
drivers/net/cxgb3/cxgb3_main.c:2784: error: implicit declaration of function 'pci_enable_msix'
drivers/net/cxgb3/cxgb3_main.c:2784: warning: type defaults to 'int' in declaration of 'type name'
drivers/net/cxgb3/cxgb3_main.c:2784: warning: type defaults to 'int' in declaration of 'type name'
drivers/net/cxgb3/cxgb3_main.c:2784: error: size of array 'type name' is negative
drivers/net/cxgb3/cxgb3_main.c:2786: warning: type defaults to 'int' in declaration of 'type name'
drivers/net/cxgb3/cxgb3_main.c:2786: warning: type defaults to 'int' in declaration of 'type name'
drivers/net/cxgb3/cxgb3_main.c:2786: error: size of array 'type name' is negative
drivers/net/cxgb3/cxgb3_main.c:2778: warning: unused variable 'entries'
drivers/net/cxgb3/cxgb3_main.c:3011: error: implicit declaration of function 'pci_enable_msi'

and from a different build:

ERROR: "lro_vlan_hwaccel_receive_frags" [drivers/net/cxgb3/cxgb3.ko] undefined!
ERROR: "lro_receive_frags" [drivers/net/cxgb3/cxgb3.ko] undefined!
ERROR: "lro_receive_skb" [drivers/net/cxgb3/cxgb3.ko] undefined!
ERROR: "lro_vlan_hwaccel_receive_skb" [drivers/net/cxgb3/cxgb3.ko] undefined!
ERROR: "lro_flush_all" [drivers/net/cxgb3/cxgb3.ko] undefined!

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/scsi/cxgb3i/Kconfig |    3 +++
 1 file changed, 3 insertions(+)

--- linux-next-20081229.orig/drivers/scsi/cxgb3i/Kconfig
+++ linux-next-20081229/drivers/scsi/cxgb3i/Kconfig
@@ -1,6 +1,9 @@
 config SCSI_CXGB3_ISCSI
 	tristate "Chelsio S3xx iSCSI support"
+	depends on PCI && INET
 	select CHELSIO_T3
 	select SCSI_ISCSI_ATTRS
+	select INET_LRO
+	select FW_LOADER
 	---help---
 	This driver supports iSCSI offload for the Chelsio S3 series devices.
