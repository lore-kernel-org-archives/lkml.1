Return-Path: <linux-kernel-owner+w=401wt.eu-S1762375AbZANM2Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762375AbZANM2Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 07:28:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753425AbZANM2R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 07:28:17 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:52772 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605AbZANM2Q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 07:28:16 -0500
Message-Id: <496DE893.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Wed, 14 Jan 2009 12:28:51 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: avoid early crash in disable_local_APIC()
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

E.g. when called due to an early panic.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 arch/x86/kernel/apic.c |    4 ++++
 1 file changed, 4 insertions(+)

--- linux-2.6.29-rc1/arch/x86/kernel/apic.c	2009-01-14 11:36:05.000000000 +0100
+++ 2.6.29-rc1-x86-early-disable-lapic/arch/x86/kernel/apic.c	2009-01-06 16:51:35.000000000 +0100
@@ -894,6 +894,10 @@ void disable_local_APIC(void)
 {
 	unsigned int value;
 
+	/* APIC hasn't been mapped yet */
+	if (!apic_phys)
+		return;
+
 	clear_local_APIC();
 
 	/*



