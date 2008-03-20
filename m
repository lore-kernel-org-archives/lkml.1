Return-Path: <linux-kernel-owner+w=401wt.eu-S1753695AbYCTHjz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753695AbYCTHjz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 03:39:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754587AbYCTHjn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 03:39:43 -0400
Received: from byss.tchmachines.com ([208.76.80.75]:47608 "EHLO
	byss.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754469AbYCTHjm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 03:39:42 -0400
Date: Thu, 20 Mar 2008 00:39:02 -0700
From: Ravikiran G Thirumalai <kiran@scalex86.org>
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Glauber de Oliveira Costa <gcosta@redhat.com>, Andi Kleen <ak@suse.de>,
       shai@scalex86.org
Subject: [patch 1/4] x86: vSMP: Fix is_vsmp_box()
Message-ID: <20080320073902.GB9414@localdomain>
References: <20080320073740.GA9414@localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080320073740.GA9414@localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - byss.tchmachines.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - scalex86.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

is_vsmp_box() currently does not work on vSMPowered systems,  as pci cfg
space is not read correctly -- This patch fixes it.

Signed-off-by: Ravikiran Thirumalai <kiran@scalex86.org>

Index: linux.git.trees/arch/x86/kernel/vsmp_64.c
===================================================================
--- linux.git.trees.orig/arch/x86/kernel/vsmp_64.c	2008-03-19 13:30:35.116766719 -0700
+++ linux.git.trees/arch/x86/kernel/vsmp_64.c	2008-03-19 13:39:20.074685590 -0700
@@ -84,8 +84,10 @@ int is_vsmp_box(void)
 		return vsmp;
 
 	/* Check if we are running on a ScaleMP vSMP box */
-	if (read_pci_config(0, 0x1f, 0, PCI_VENDOR_ID) ==
-	     (PCI_VENDOR_ID_SCALEMP || (PCI_DEVICE_ID_SCALEMP_VSMP_CTL << 16)))
+	if ((read_pci_config_16(0, 0x1f, 0, PCI_VENDOR_ID) ==
+	     PCI_VENDOR_ID_SCALEMP) &&
+	    (read_pci_config_16(0, 0x1f, 0, PCI_DEVICE_ID) ==
+	    PCI_DEVICE_ID_SCALEMP_VSMP_CTL))
 		vsmp = 1;
 
 	return vsmp;
