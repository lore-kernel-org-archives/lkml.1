Return-Path: <linux-kernel-owner+w=401wt.eu-S965537AbXA3OpF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965537AbXA3OpF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 09:45:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965535AbXA3OpE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 09:45:04 -0500
Received: from il.qumranet.com ([62.219.232.206]:52757 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965538AbXA3OpB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 09:45:01 -0500
Subject: [PATCH 9/11] KVM: VMX: Reload ds and es even in 64-bit mode
From: Avi Kivity <avi@qumranet.com>
Date: Tue, 30 Jan 2007 14:45:00 -0000
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org, mingo@elte.hu
References: <45BF57C9.7000103@qumranet.com>
In-Reply-To: <45BF57C9.7000103@qumranet.com>
Message-Id: <20070130144500.3CE2AA0014@il.qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Or 32-bit userspace will get confused.

Signed-off-by: Avi Kivity <avi@qumranet.com>

Index: linux-2.6/drivers/kvm/vmx.c
===================================================================
--- linux-2.6.orig/drivers/kvm/vmx.c
+++ linux-2.6/drivers/kvm/vmx.c
@@ -1863,9 +1863,7 @@ again:
 	fx_restore(vcpu->host_fx_image);
 	vcpu->interrupt_window_open = (vmcs_read32(GUEST_INTERRUPTIBILITY_INFO) & 3) == 0;
 
-#ifndef CONFIG_X86_64
 	asm ("mov %0, %%ds; mov %0, %%es" : : "r"(__USER_DS));
-#endif
 
 	/*
 	 * Profile KVM exit RIPs:
