Return-Path: <linux-kernel-owner+w=401wt.eu-S1753141AbYAAAS0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753141AbYAAAS0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2007 19:18:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751750AbYAAASR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Dec 2007 19:18:17 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:65118 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751749AbYAAASP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2007 19:18:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:from;
        b=rVfszzVbDQg8E9HBOsbWNZt4HLStGuilS361tpLsrhXJGJikocejfnYTG85eMu3ctBfAWEyseR6o+/nAbgTj0TJG07/SKX7nUHXw007H7B6EHQhqS1YNdTR17Pt7cVo+BNtRYLEr8ft9Cntzov1rjBnJC+wT5GXkAKE4CbMICSM=
To: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] ssb: add 'ssb_pcihost_set_power_state' function
Date: Tue, 1 Jan 2008 01:16:46 +0100
User-Agent: KMail/1.9.7
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com, mb@bu3sch.de
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200801010116.46190.mboton@gmail.com>
From: Miguel =?utf-8?q?Bot=C3=B3n?= <mboton.lkml@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the 'ssb_pcihost_set_power_state' function.

This function allows us to set the power state of a PCI device
(for example b44 ethernet device). 

Signed-off-by: Miguel Botón <mboton@gmail.com>

diff --git a/include/linux/ssb/ssb.h b/include/linux/ssb/ssb.h
index a21ab29..aa70fd0 100644
--- a/include/linux/ssb/ssb.h
+++ b/include/linux/ssb/ssb.h
@@ -349,6 +349,13 @@ static inline void ssb_pcihost_unregister(struct pci_driver *driver)
 {
 	pci_unregister_driver(driver);
 }
+
+static inline
+void ssb_pcihost_set_power_state(struct ssb_device *sdev, pci_power_t state)
+{
+	if (sdev->bus->bustype == SSB_BUSTYPE_PCI)
+		pci_set_power_state(sdev->bus->host_pci, state);
+}
 #endif /* CONFIG_SSB_PCIHOST */
 
 

-- 
	Miguel Botón
