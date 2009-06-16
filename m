Return-Path: <linux-kernel-owner+w=401wt.eu-S1760291AbZFPR3Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760291AbZFPR3Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 13:29:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754512AbZFPR3N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 13:29:13 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:29712 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753299AbZFPR3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 13:29:12 -0400
Message-ID: <4A37D599.5080701@oracle.com>
Date: Tue, 16 Jun 2009 10:25:45 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Michael Chan <mchan@broadcom.com>, linux-scsi@vger.kernel.org,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [PATCH -next] bnx2i/cnic: more kconfig dependencies
References: <20090616165923.8ca4ddcb.sfr@canb.auug.org.au>
In-Reply-To: <20090616165923.8ca4ddcb.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt009.oracle.com [141.146.116.18]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4A37D662.004B:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

BNX2I selects CNIC, CNIC selects UIO.
It looks like BNX2I also needs to select UIO.

BTW, CNIC is under NETDEV_1000, which is not enabled.
I don't see any need to enable (select) it in this case,
but I could be wrong(?).  Should BNX2I also select NETDEV_1000?

cnic.c:(.text+0x17990b): undefined reference to `uio_event_notify'
cnic.c:(.text+0x17a197): undefined reference to `uio_unregister_device'
cnic.c:(.text+0x17c618): undefined reference to `__uio_register_device'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/scsi/bnx2i/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20090616.orig/drivers/scsi/bnx2i/Kconfig
+++ linux-next-20090616/drivers/scsi/bnx2i/Kconfig
@@ -2,6 +2,7 @@ config SCSI_BNX2_ISCSI
 	tristate "Broadcom NetXtreme II iSCSI support"
 	select SCSI_ISCSI_ATTRS
 	select CNIC
+	select UIO
 	depends on PCI
 	---help---
 	This driver supports iSCSI offload for the Broadcom NetXtreme II


-- 
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
