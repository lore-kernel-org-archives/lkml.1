Return-Path: <linux-kernel-owner+w=401wt.eu-S932696AbXCGEpr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932696AbXCGEpr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 23:45:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932768AbXCGEpq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 23:45:46 -0500
Received: from wip-ec-wd.wipro.com ([203.91.193.32]:55645 "EHLO
	wip-ec-wd.wipro.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932696AbXCGEpq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 23:45:46 -0500
Subject: [kj]Patch8:replace pci_find_device in drivers/telephony/ixj.c
From: Surya <surya.prabhakar@wipro.com>
To: eokerson@quicknet.net
Cc: alan@lxorguk.ukuu.org.uk, kernel-janitors@lists.osdl.org,
       linux-kernel@vger.kernel.org, trivial@kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Linux COE, Wipro Technologies, Bangalore, India.
Date: Wed, 07 Mar 2007 10:15:39 +0530
Message-Id: <1173242739.3931.0.camel@bluegenie>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
X-OriginalArrivalTime: 07 Mar 2007 04:45:43.0771 (UTC) FILETIME=[77059AB0:01C76073]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
   Cleaning up of pci_find_device in drivers/telephony/ixj.c.
Applies and compiles clean on Linus tree. No hardware hence not tested!!

Unable to find a suitable Maintainer for the current subsection in the Maintainers file.
I am not sure whether this is orphaned or maintained. 

Can somebody help me identify the actual maintainer.

thank you.


Signed-off-by: Surya Prabhakar <surya.prabhakar@wipro.com>
--- 


diff --git a/drivers/telephony/ixj.c b/drivers/telephony/ixj.c
index 71cb64e..c7b0a35 100644
--- a/drivers/telephony/ixj.c
+++ b/drivers/telephony/ixj.c
@@ -7692,7 +7692,7 @@ static int __init ixj_probe_pci(int *cnt
 	IXJ *j = NULL;
 
 	for (i = 0; i < IXJMAX - *cnt; i++) {
-		pci = pci_find_device(PCI_VENDOR_ID_QUICKNET,
+		pci = pci_get_device(PCI_VENDOR_ID_QUICKNET,
 				      PCI_DEVICE_ID_QUICKNET_XJ, pci);
 		if (!pci)
 			break;
@@ -7712,6 +7712,7 @@ static int __init ixj_probe_pci(int *cnt
 			printk(KERN_INFO "ixj: found Internet PhoneJACK PCI at 0x%x\n", j->DSPbase);
 		++*cnt;
 	}
+	pci_dev_put(pci);
 	return probe;
 }
 

-- 
surya.
