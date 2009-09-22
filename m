Return-Path: <linux-kernel-owner+w=401wt.eu-S1756647AbZIVOFl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756647AbZIVOFl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 10:05:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756146AbZIVOFl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 10:05:41 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:62493 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755986AbZIVOFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 10:05:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=XUeKt4TP9km4vcNxoxbhVNr1xvWkuGQq+wsUG31Iz+xo7ijNzCDPPbTxaSztDK8JtP
         sHi567wyrLw7BV/XAEeqB7x76oN/LawW8iXU9mpLqOf0QzAfA1ZwtPHMomNWLvmllyCE
         lMcrhrVgktfx39q52vf5bmy8tozy+/dv1bCcY=
Message-ID: <4AB8D9B3.4010805@tuffmail.co.uk>
Date: Tue, 22 Sep 2009 15:05:39 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: davem@davemloft.net
CC: netdev@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>,
       Alexander Beregalov <a.beregalov@gmail.com>
Subject: [PATCH] 8139cp: fix duplicate loglevel in module load message
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This was introduced by b93d58 "8139*: convert printk() to pr_<foo>()":

[ 2256252443 ] <6>8139cp: 10/100 PCI Ethernet driver v1.3 (Mar 22, 2004)

The "version" string is printed using pr_info(), so it doesn't need to
include a loglevel.

Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
CC: Alexander Beregalov <a.beregalov@gmail.com>
---
 drivers/net/8139cp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/8139cp.c b/drivers/net/8139cp.c
index d0dbbf3..6841a9a 100644
--- a/drivers/net/8139cp.c
+++ b/drivers/net/8139cp.c
@@ -87,7 +87,7 @@
 
 /* These identify the driver base version and may not be removed. */
 static char version[] =
-KERN_INFO DRV_NAME ": 10/100 PCI Ethernet driver v" DRV_VERSION " (" DRV_RELDATE ")\n";
+DRV_NAME ": 10/100 PCI Ethernet driver v" DRV_VERSION " (" DRV_RELDATE ")\n";
 
 MODULE_AUTHOR("Jeff Garzik <jgarzik@pobox.com>");
 MODULE_DESCRIPTION("RealTek RTL-8139C+ series 10/100 PCI Ethernet driver");
-- 
1.6.3.2



