Return-Path: <linux-kernel-owner+w=401wt.eu-S1756257AbYIRQ5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756257AbYIRQ5U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 12:57:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754501AbYIRQ5M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 12:57:12 -0400
Received: from qmta03.emeryville.ca.mail.comcast.net ([76.96.30.32]:58063 "EHLO
	QMTA03.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754128AbYIRQ5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 12:57:11 -0400
X-Greylist: delayed 332 seconds by postgrey-1.27 at vger.kernel.org; Thu, 18 Sep 2008 12:57:11 EDT
X-Authority-Analysis: v=1.0 c=1 a=0NocdUKMf80A:10 a=Wu1yGvdMdLAA:10
 a=qA4RtnA73wSUZ0oI3hMA:9 a=0bwms0IAXKJ8qw1gfKUA:7
 a=bwjo2dUAjv__vxss-0nv9JK_uMoA:4 a=JTUSPwgBgNAA:10 a=XF7b4UCPwd8A:10
To: jbarnes@virtuousgeek.org
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: PCI: Fix MSI-HOWTO.txt info about MSI-X MMIO space
X-Message-Flag: Warning: May contain useful information
X-Priority: 1
X-MSMail-Priority: High
From: Roland Dreier <roland@digitalvampire.org>
Date: Thu, 18 Sep 2008 09:51:33 -0700
Message-ID: <87vdwtv1m2.fsf@shaolin.home.digitalvampire.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.21 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current MSI-HOWTO.txt says that device drivers should not request
the memory space that contains MSI-X tables.  This is because the
original MSI-X implementation did a request_mem_region() on this
space, but that code was removed long ago (in the pre-git era, in
fact).  Years after the code was changed, we might as well clean up
the documention to avoid a confusing mention of requesting regions:
drivers using MSI-X can just use pci_request_regions() just like any
other driver, and so there's no need for MSI-HOWTO.txt to talk about
this at all.

Signed-off-by: Roland Dreier <roland@digitalvampire.org>
---
 Documentation/MSI-HOWTO.txt |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/Documentation/MSI-HOWTO.txt b/Documentation/MSI-HOWTO.txt
index a51f693..256defd 100644
--- a/Documentation/MSI-HOWTO.txt
+++ b/Documentation/MSI-HOWTO.txt
@@ -236,10 +236,8 @@ software system can set different pages for controlling accesses to the
 MSI-X structure. The implementation of MSI support requires the PCI
 subsystem, not a device driver, to maintain full control of the MSI-X
 table/MSI-X PBA (Pending Bit Array) and MMIO address space of the MSI-X
-table/MSI-X PBA.  A device driver is prohibited from requesting the MMIO
-address space of the MSI-X table/MSI-X PBA. Otherwise, the PCI subsystem
-will fail enabling MSI-X on its hardware device when it calls the function
-pci_enable_msix().
+table/MSI-X PBA.  A device driver should not access the MMIO address
+space of the MSI-X table/MSI-X PBA.
 
 5.3.2 API pci_enable_msix
 
