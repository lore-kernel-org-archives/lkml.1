Return-Path: <linux-kernel-owner+w=401wt.eu-S932167AbZHYVAt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932167AbZHYVAt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 17:00:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932148AbZHYVAs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 17:00:48 -0400
Received: from server1.wserver.cz ([82.113.45.157]:60652 "EHLO
	server1.wserver.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932155AbZHYVAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 17:00:43 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: jeremy@xensource.com
Cc: chrisw@sous-sol.org, virtualization@lists.osdl.org,
       xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 1/1] XEN: enlighten, use uninitialized_var(cx)
Date: Tue, 25 Aug 2009 23:00:44 +0200
Message-Id: <1251234044-6943-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To avoid a wrong compiler warning, use unitialized_var(cx) in
xen_init_cpuid_mask.

cx needn't be initialized for cpuid when ax is 1.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Chris Wright <chrisw@sous-sol.org>
---
 arch/x86/xen/enlighten.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index e90540a..5ab75e2 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -202,7 +202,7 @@ static void xen_cpuid(unsigned int *ax, unsigned int *bx,
 
 static __init void xen_init_cpuid_mask(void)
 {
-	unsigned int ax, bx, cx, dx;
+	unsigned int ax, bx, uninitialized_var(cx), dx;
 
 	cpuid_leaf1_edx_mask =
 		~((1 << X86_FEATURE_MCE)  |  /* disable MCE */
-- 
1.6.3.3

