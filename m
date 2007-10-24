Return-Path: <linux-kernel-owner+w=401wt.eu-S1754634AbXJXTcq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754634AbXJXTcq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 15:32:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754881AbXJXTcZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 15:32:25 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:38198 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754429AbXJXTcX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 15:32:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=lYmNlOMl7JcAOmz9xF4LsNRVteFry/+1XaihSNWjn6gaOQe5/L3TeXqhLdeRy4L0dfEMYIM3Mb7Y7VGVHxkA+8hvCvRQ+xqv9nGsKT4kQ1FogvQGvxmeA594Hu4vW+VeKZhT71GbOhysv3sJqepL1aAURBc/UR0F36s74MZtXHM=
From: Miguel =?iso-8859-1?q?Bot=F3n?= <mboton.lkml@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] ssb: Add "ssb_pci_set_power_state" function
Date: Wed, 24 Oct 2007 21:31:21 +0200
User-Agent: KMail/1.9.7
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com, mb@bu3sch.de
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200710242131.21959.mboton.lkml@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add "ssb_pci_set_power_state" function. This allows set the power state of a 
PCI device (for example b44 ethernet device).

diff -ruN linux-2.6.23/include/linux/ssb/ssb.h 
linux-2.6.23.orig/include/linux/ssb/ssb.h
--- linux-2.6.23.orig/include/linux/ssb/ssb.h	2007-10-24 19:02:33.000000000 
+0200
+++ linux-2.6.23/include/linux/ssb/ssb.h	2007-10-24 19:49:37.000000000 +0200
@@ -402,6 +402,14 @@
 {
 	pci_unregister_driver(driver);
 }
+
+/* Set PCI device power state */
+static inline
+void ssb_pci_set_power_state(struct ssb_device *dev, pci_power_t state)
+{
+	if(dev->bus->bustype == SSB_BUSTYPE_PCI)
+		pci_set_power_state(dev->bus->host_pci, state);
+}
 #endif /* CONFIG_SSB_PCIHOST */
 
 

-- 
	Miguel Botón
