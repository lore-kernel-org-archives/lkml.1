Return-Path: <linux-kernel-owner+w=401wt.eu-S1755570AbYIQSws@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755570AbYIQSws (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 14:52:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755153AbYIQSwk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 14:52:40 -0400
Received: from mms3.broadcom.com ([216.31.210.19]:2735 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755138AbYIQSwk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 14:52:40 -0400
X-Server-Uuid: B55A25B1-5D7D-41F8-BC53-C57E7AD3C201
Subject: [PATCH] bnx2: Promote vector field in bnx2_irq structure from
 u16 to unsigned int
From: "Benjamin Li" <benli@broadcom.com>
Reply-to: 20080916190144.46f534b4@bree.surriel.com
To: "Rik van Riel" <riel@redhat.com>, "Michael Chan" <mchan@broadcom.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "David Miller" <davem@davemloft.net>
cc: "inux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 17 Sep 2008 11:52:10 -0700
Message-ID: <1221677530.4028.17.camel@localhost>
MIME-Version: 1.0
X-Mailer: Evolution 2.22.3.1
X-WSS-ID: 64CF8E6E4YK37282082-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From c455b36005a9b1b6a2b0036b7947d3f4bebb9f2d Mon Sep 17 00:00:00 2001
From: Benjamin Li <benli@broadcom.com>
Date: Tue, 16 Sep 2008 17:20:11 -0700
Subject: [PATCH] bnx2: Promote vector field in bnx2_irq structure from u16 to unsigned int

The bnx2 driver stores/uses the irq value from the pci_dev internally.
But when it stores the irq value, it has been performing an
integer demotion.  Because of the recent changes made to
arch/x86/kernel/io_apic.c, the new method in creating the irq value
(using build_irq_for_pci_dev()) has exposed this bug on x86 systems.

Because of this demotion when calling request_irq() from
bnx2_request_irq(), the driver would get a return code of -EINVAL.
This is because the kernel could not find the requested irq descriptor.
By storing the irq value properly, the kernel can find the correct
irq descriptor and the bnx2 driver can operate normally.

Signed-off-by: Benjamin Li <benli@broadcom.com>
Signed-off-by: Michael Chan <mchan@broadcom.com>

---
 drivers/net/bnx2.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/bnx2.h b/drivers/net/bnx2.h
index c3c579f..dfacd31 100644
--- a/drivers/net/bnx2.h
+++ b/drivers/net/bnx2.h
@@ -6597,7 +6597,7 @@ struct flash_spec {
 
 struct bnx2_irq {
 	irq_handler_t	handler;
-	u16		vector;
+	unsigned int	vector;
 	u8		requested;
 	char		name[16];
 };
-- 
1.5.5.1




