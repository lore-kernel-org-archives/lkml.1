Return-Path: <linux-kernel-owner+w=401wt.eu-S1752044AbYHREN1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752044AbYHREN1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 00:13:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750732AbYHRENT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 00:13:19 -0400
Received: from rv-out-0506.google.com ([209.85.198.236]:30694 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720AbYHRENS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 00:13:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=hEiS1FE+QHAefekHYB2lacz9ZJdlhjAfjfddqB2wzGdqMTzR/tMXIhc+YJ97O7/pwO
         fGu7KOsVxYLzT6QThYXFfoXEOxJ9i4KbYqJj0yTnLrYZqYOdS65huVjrO0/vmlja5mnA
         1f67Z/2S8R0RBm1eSHfN2UCRxpfxHIyfYPUy0=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH] x86: apic - unify lapic_resume - fix
Date: Sun, 17 Aug 2008 21:12:27 -0700
Message-Id: <1219032749-9312-1-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <no>
References: <no>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

diff --git a/arch/x86/kernel/apic_64.c b/arch/x86/kernel/apic_64.c
index 1b0baf5..7fb7dca 100644
--- a/arch/x86/kernel/apic_64.c
+++ b/arch/x86/kernel/apic_64.c
@@ -1448,6 +1448,7 @@ static int lapic_resume(struct sys_device *dev)
 		enable_x2apic();
 	else
 #endif
+	{
 		/*
 		 * Make sure the APICBASE points to the right address
 		 *
@@ -1458,6 +1459,7 @@ static int lapic_resume(struct sys_device *dev)
 		l &= ~MSR_IA32_APICBASE_BASE;
 		l |= MSR_IA32_APICBASE_ENABLE | mp_lapic_addr;
 		wrmsr(MSR_IA32_APICBASE, l, h);
+	}
 
 	apic_write(APIC_LVTERR, ERROR_APIC_VECTOR | APIC_LVT_MASKED);
 	apic_write(APIC_ID, apic_pm_state.apic_id);
