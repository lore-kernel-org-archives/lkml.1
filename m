Return-Path: <linux-kernel-owner+w=401wt.eu-S1756512AbZCLK4c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756512AbZCLK4c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 06:56:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755600AbZCLK4V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 06:56:21 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:33100 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754811AbZCLK4U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 06:56:20 -0400
Message-Id: <49B8F3D4.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Thu, 12 Mar 2009 10:36:52 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <jeremy.fitzhardinge@citrix.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86-64: fix HYPERVISOR_update_descriptor()
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Acked-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

---
 arch/x86/include/asm/xen/hypercall.h |    2 ++
 1 file changed, 2 insertions(+)

--- linux-2.6.29-rc7/arch/x86/include/asm/xen/hypercall.h	2009-03-11 17:52:10.000000000 +0100
+++ 2.6.29-rc7-x86_64-xen-update-descr/arch/x86/include/asm/xen/hypercall.h	2009-02-13 11:41:39.000000000 +0100
@@ -296,6 +296,8 @@ HYPERVISOR_get_debugreg(int reg)
 static inline int
 HYPERVISOR_update_descriptor(u64 ma, u64 desc)
 {
+	if (sizeof(u64) == sizeof(long))
+		return _hypercall2(int, update_descriptor, ma, desc);
 	return _hypercall4(int, update_descriptor, ma, ma>>32, desc, desc>>32);
 }
 



