Return-Path: <linux-kernel-owner+w=401wt.eu-S1756024AbYIIGTf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756024AbYIIGTf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 02:19:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755745AbYIIGTZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 02:19:25 -0400
Received: from rn-out-0910.google.com ([64.233.170.190]:54862 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754194AbYIIGTZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 02:19:25 -0400
From: Steven Noonan <steven@uplinklabs.net>
To: linux-kernel@vger.kernel.org
Cc: mingo@elite.hu, steven@uplinklabs.net
Subject: [PATCH] x86: fix HPET compiler error when not using CONFIG_PCI_MSI
Date: Mon,  8 Sep 2008 16:19:09 -0700
Message-Id: <1220915951-11434-1-git-send-email-steven@uplinklabs.net>
X-Mailer: git-send-email 1.6.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added dummy function for hpet_setup_msi_irq().

Signed-off-by: Steven Noonan <steven@uplinklabs.net>
---
 arch/x86/kernel/hpet.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index 01005ae..422c577 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -635,6 +635,10 @@ static int hpet_cpuhp_notify(struct notifier_block *n,
 }
 #else
 
+static int hpet_setup_msi_irq(unsigned int irq)
+{
+	return 0;
+}
 void hpet_msi_capability_lookup(unsigned int start_timer)
 {
 	return;
-- 
1.6.0.1

