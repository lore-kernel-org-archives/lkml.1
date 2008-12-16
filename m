Return-Path: <linux-kernel-owner+w=401wt.eu-S1756208AbYLPLhZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756208AbYLPLhZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 06:37:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752765AbYLPLhK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 06:37:10 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:39394 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752858AbYLPLhI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 06:37:08 -0500
Message-Id: <4947A108.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Tue, 16 Dec 2008 11:37:28 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Cc: <mingo@elte.hu>, <tglx@linutronix.de>, <linux-kernel@vger.kernel.org>,
       <hpa@zytor.com>
Subject: [PATCH] x86-64: fix HYPERVISOR_update_descriptor()
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 arch/x86/include/asm/xen/hypercall.h |    2 ++
 1 file changed, 2 insertions(+)

--- linux-2.6.28-rc8/arch/x86/include/asm/xen/hypercall.h	2008-12-11 14:45:37.000000000 +0100
+++ 2.6.28-rc8-x86_64-xen-update-descr/arch/x86/include/asm/xen/hypercall.h	2008-12-12 10:25:55.000000000 +0100
@@ -290,6 +290,8 @@ HYPERVISOR_get_debugreg(int reg)
 static inline int
 HYPERVISOR_update_descriptor(u64 ma, u64 desc)
 {
+	if (sizeof(u64) == sizeof(long))
+		return _hypercall2(int, update_descriptor, ma, desc);
 	return _hypercall4(int, update_descriptor, ma, ma>>32, desc, desc>>32);
 }
 



