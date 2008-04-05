Return-Path: <linux-kernel-owner+w=401wt.eu-S1754426AbYDENvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754426AbYDENvU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2008 09:51:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752483AbYDENu0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Apr 2008 09:50:26 -0400
Received: from hs-out-0708.google.com ([64.233.178.243]:46570 "EHLO
	hs-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753720AbYDENuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2008 09:50:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:user-agent:date:from:to:cc:subject:content-disposition:message-id;
        b=ABw/orwJwjNiB+Nm9/3yeNTxNQLTvR1qmi9UVX2gmTgF6kksDONQcysA873DHenPJxon47WG2ShHx4SvK3XnxhIqYs89uUIDkRFErQhqj50AcemSdepefDWuCs/qYY+CZ/NzD5RUyZxz/idVgiOU8KBMqDa8VGtqRz8CY3BvFVk=
References: <20080405133903.770639386@gmail.com>>
User-Agent: quilt/0.46-1
Date: Sat, 05 Apr 2008 22:39:07 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [patch 4/9] x86: remove unnecessary tmp local variable
Content-Disposition: inline; filename=x86-io-apic-kill-tmp-var.patch
Message-ID: <47f7839e.1ebd7e0a.2fbf.00e4@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no reason to use obscurer name.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 arch/x86/kernel/io_apic_32.c |    3 +--
 arch/x86/kernel/io_apic_64.c |    3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

Index: 2.6-git/arch/x86/kernel/io_apic_32.c
===================================================================
--- 2.6-git.orig/arch/x86/kernel/io_apic_32.c
+++ 2.6-git/arch/x86/kernel/io_apic_32.c
@@ -2028,8 +2028,7 @@ static inline void init_IO_APIC_traps(vo
 	 * 0x80, because int 0x80 is hm, kind of importantish. ;)
 	 */
 	for (irq = 0; irq < NR_IRQS ; irq++) {
-		int tmp = irq;
-		if (IO_APIC_IRQ(tmp) && !irq_vector[tmp]) {
+		if (IO_APIC_IRQ(irq) && !irq_vector[irq]) {
 			/*
 			 * Hmm.. We don't have an entry for this,
 			 * so default to an old-fashioned 8259
Index: 2.6-git/arch/x86/kernel/io_apic_64.c
===================================================================
--- 2.6-git.orig/arch/x86/kernel/io_apic_64.c
+++ 2.6-git/arch/x86/kernel/io_apic_64.c
@@ -1516,8 +1516,7 @@ static inline void init_IO_APIC_traps(vo
 	 * 0x80, because int 0x80 is hm, kind of importantish. ;)
 	 */
 	for (irq = 0; irq < NR_IRQS ; irq++) {
-		int tmp = irq;
-		if (IO_APIC_IRQ(tmp) && !irq_cfg[tmp].vector) {
+		if (IO_APIC_IRQ(irq) && !irq_cfg[irq].vector) {
 			/*
 			 * Hmm.. We don't have an entry for this,
 			 * so default to an old-fashioned 8259

-- 
