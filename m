Return-Path: <linux-kernel-owner+w=401wt.eu-S932703AbZGABW5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932703AbZGABW5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 21:22:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757845AbZGABEY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 21:04:24 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:59243 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765519AbZGABES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 21:04:18 -0400
From: Andy Isaacson <adi@vmware.com>
To: linux-kernel@vger.kernel.org, tpmdd-devel@lists.sourceforge.net
Cc: adi@hexapodia.org, Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
       dds@google.com, Mimi Zohar <zohar@linux.vnet.ibm.com>,
       Shahbaz Khan <shaz.linux@gmail.com>, seiji.munetoh@gmail.com,
       Andy Isaacson <adi@vmware.com>
Subject: [PATCH 4/6] tpm_tis: print complete vendor information
Date: Tue, 30 Jun 2009 18:04:13 -0700
Message-Id: <1246410255-6839-5-git-send-email-adi@vmware.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1246410255-6839-1-git-send-email-adi@vmware.com>
References: <1246410255-6839-1-git-send-email-adi@vmware.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The TPM_VID field contains a vendor-id as well as a device-id,
but the code only prints the device-id.  Fix it.

Signed-off-by: Andy Isaacson <adi@vmware.com>
---
 drivers/char/tpm/tpm_tis.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
index e0bda02..50c2a8a 100644
--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -464,7 +464,7 @@ static int tpm_tis_init(struct device *dev, resource_size_t start,
 	vendor = ioread32(chip->vendor.iobase + TPM_DID_VID(0));
 
 	dev_info(dev,
-		 "1.2 TPM (device-id 0x%X, rev-id %d)\n",
+		 "1.2 TPM (%04X:%04X rev %d)\n", vendor & 0xffff,
 		 vendor >> 16, ioread8(chip->vendor.iobase + TPM_RID(0)));
 
 	/* Figure out the capabilities */
-- 
1.6.3.1

