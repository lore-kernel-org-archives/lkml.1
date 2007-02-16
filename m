Return-Path: <linux-kernel-owner+w=401wt.eu-S1422643AbXBPPJp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422643AbXBPPJp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 10:09:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422640AbXBPPJp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 10:09:45 -0500
Received: from outbound-blu.frontbridge.com ([65.55.251.16]:16904 "EHLO
	outbound6-blu-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1945904AbXBPPJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 10:09:43 -0500
X-BigFish: VP
X-Server-Uuid: 89466532-923C-4A88-82C1-66ACAA0041DF
Date: Fri, 16 Feb 2007 16:09:29 +0100
From: "Joerg Roedel" <joerg.roedel@amd.com>
To: "Avi Kivity" <avi@qumranet.com>
cc: "kvm-devel" <kvm-devel@lists.sourceforge.net>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] KVM SVM: intercept SMI to handle it at host level
Message-ID: <20070216150929.GA27093@amd.com>
MIME-Version: 1.0
User-Agent: mutt-ng/devel-r804 (Linux)
X-OriginalArrivalTime: 16 Feb 2007 15:09:29.0972 (UTC)
 FILETIME=[74ED6B40:01C751DC]
X-WSS-ID: 69CB16A62EG842945-01-01
Content-Type: multipart/mixed;
 boundary=WIyZ46R2i8wDzkSu
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--WIyZ46R2i8wDzkSu
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

From: Joerg Roedel <joerg.roedel@amd.com>

This patch changes the SVM code to intercept SMIs and handle it
outside the guest.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>

-- 
Joerg Roedel
Operating System Research Center
AMD Saxony LLC & Co. KG

--WIyZ46R2i8wDzkSu
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: attachment;
 filename=kvm-smi.patch
Content-Transfer-Encoding: 7bit

diff --git a/drivers/kvm/svm.c b/drivers/kvm/svm.c
index 83da4ea..f3ec1cb 100644
--- a/drivers/kvm/svm.c
+++ b/drivers/kvm/svm.c
@@ -485,6 +485,7 @@ static void init_vmcb(struct vmcb *vmcb)
 
 	control->intercept = 	(1ULL << INTERCEPT_INTR) |
 				(1ULL << INTERCEPT_NMI) |
+				(1ULL << INTERCEPT_SMI) |
 		/*
 		 * selective cr0 intercept bug?
 		 *    	0:   0f 22 d8                mov    %eax,%cr3

--WIyZ46R2i8wDzkSu--


