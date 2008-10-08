Return-Path: <linux-kernel-owner+w=401wt.eu-S1756685AbYJHV5X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756685AbYJHV5X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 17:57:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754354AbYJHV5P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 17:57:15 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:55233 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754285AbYJHV5P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 17:57:15 -0400
To: linux-kernel@vger.kernel.org
Subject: [PATCH] UV: cosmetic fix to interrupt handler definition
Cc: mingo@elte.hu
Message-Id: <E1Knh2A-0000HU-WA@eag09.americas.sgi.com>
From: Cliff Wickman <cpw@sgi.com>
Date: Wed, 08 Oct 2008 16:57:30 -0500
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cliff Wickman <cpw@sgi.com>

The UV Broadcast Assist Unit (BAU) interrupt handler is erroneously
declared with a hardcoded vector 220 (that was used during testing).
It should be declared with the vector that is reserved for it.

The interrupt handler does not use the 220 that is pushed onto its
stack, so this error had no runtime effect.

Diffed against 2.6.27-rc8

Signed-off-by: Cliff Wickman <cpw@sgi.com>
---
 arch/x86/kernel/entry_64.S |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: 081002.linus/arch/x86/kernel/entry_64.S
===================================================================
--- 081002.linus.orig/arch/x86/kernel/entry_64.S
+++ 081002.linus/arch/x86/kernel/entry_64.S
@@ -878,7 +878,7 @@ ENTRY(apic_timer_interrupt)
 END(apic_timer_interrupt)
 
 ENTRY(uv_bau_message_intr1)
-	apicinterrupt 220,uv_bau_message_interrupt
+	apicinterrupt UV_BAU_MESSAGE,uv_bau_message_interrupt
 END(uv_bau_message_intr1)
 
 ENTRY(error_interrupt)
