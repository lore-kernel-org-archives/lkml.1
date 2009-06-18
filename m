Return-Path: <linux-kernel-owner+w=401wt.eu-S1756678AbZFRQ65@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756678AbZFRQ65 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 12:58:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755622AbZFRQ6s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 12:58:48 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:36347 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755458AbZFRQ6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 12:58:47 -0400
Message-ID: <4A3A7175.8080006@oracle.com>
Date: Thu, 18 Jun 2009 09:55:17 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>,
       Anil Veerabhadrappa <anilgv@broadcom.com>,
       Michael Chan <mchan@broadcom.com>, scsi <linux-scsi@vger.kernel.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [PATCH -next] bnx2i/cnic: kconfig interactions
References: <20090618145949.d933719a.sfr@canb.auug.org.au>
In-Reply-To: <20090618145949.d933719a.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: abhmt010.oracle.com [141.146.116.19]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010203.4A3A723C.0061:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

NETDEVICES + NETDEV_1000 need to be enabled so that kconfig will check
those branches for selects and enforce "select UIO" under CNIC.
Otherwise the build fails with:

ERROR: "uio_unregister_device" [drivers/net/cnic.ko] undefined!
ERROR: "uio_event_notify" [drivers/net/cnic.ko] undefined!
ERROR: "__uio_register_device" [drivers/net/cnic.ko] undefined!

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Anil Veerabhadrappa <anilgv@broadcom.com>
Cc: Michael Chan <mchan@broadcom.com>
---
 drivers/scsi/bnx2i/Kconfig |    2 ++
 1 file changed, 2 insertions(+)

--- linux-next-20090618.orig/drivers/scsi/bnx2i/Kconfig
+++ linux-next-20090618/drivers/scsi/bnx2i/Kconfig
@@ -1,6 +1,8 @@
 config SCSI_BNX2_ISCSI
 	tristate "Broadcom NetXtreme II iSCSI support"
 	select SCSI_ISCSI_ATTRS
+	select NETDEVICES
+	select NETDEV_1000
 	select CNIC
 	depends on PCI
 	---help---



-- 
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
