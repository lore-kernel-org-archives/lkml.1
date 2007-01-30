Return-Path: <linux-kernel-owner+w=401wt.eu-S965513AbXA3OiE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965513AbXA3OiE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 09:38:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965521AbXA3OiE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 09:38:04 -0500
Received: from il.qumranet.com ([62.219.232.206]:39358 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965513AbXA3OiB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 09:38:01 -0500
Subject: [PATCH 2/11] KVM: Fix asm constraint for lldt instruction
From: Avi Kivity <avi@qumranet.com>
Date: Tue, 30 Jan 2007 14:38:00 -0000
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org, mingo@elte.hu
References: <45BF57C9.7000103@qumranet.com>
In-Reply-To: <45BF57C9.7000103@qumranet.com>
Message-Id: <20070130143800.10C1DA0014@il.qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: S.Çağlar Onur <caglar@pardus.org.tr>

lldt does not accept immediate operands, which "g" allows.

Signed-off-by: S.Çağlar Onur <caglar@pardus.org.tr>
Signed-off-by: Avi Kivity <avi@qumranet.com>

Index: linux-2.6/drivers/kvm/kvm.h
===================================================================
--- linux-2.6.orig/drivers/kvm/kvm.h
+++ linux-2.6/drivers/kvm/kvm.h
@@ -558,7 +558,7 @@ static inline void load_gs(u16 sel)
 #ifndef load_ldt
 static inline void load_ldt(u16 sel)
 {
-	asm ("lldt %0" : : "g"(sel));
+	asm ("lldt %0" : : "rm"(sel));
 }
 #endif
 
