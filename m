Return-Path: <linux-kernel-owner+w=401wt.eu-S1753218AbYHAO4P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753218AbYHAO4P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 10:56:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751064AbYHAOz7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 10:55:59 -0400
Received: from qb-out-0506.google.com ([72.14.204.228]:54140 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751106AbYHAOz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 10:55:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=resent-from:resent-date:resent-message-id:resent-to:date:from:to:cc
         :subject:message-id:mime-version:content-type:content-disposition
         :user-agent;
        b=JxDXRDgellOkAfSM23cMId2bgYcmpKbd8dlAVCJ+rCjA0eDJcg3VPhB2jI31C5sT7J
         uXuLco9IBz7oMH0gY4HsrNppaO4fLk9TYYYnRTCRDTOf6+dYC0l16AjpEEfhl/j7rX4A
         ueiwFPDafTnuz4euyARwpZ0eolwjG6ueykmhE=
Date: Wed, 30 Jul 2008 19:50:23 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: [PATCH -tip] x86: apic - use SET_APIC_DEST_FIELD macro
Message-ID: <20080730155023.GA8226@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use predefined macro instead of hardcoded bit shifting

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

I'm on really sloooow gprs connection so fetching replies not
that often and if there is some inconvenience with this patch
i'll not answer fast, sorry.

Index: linux-2.6.git/arch/x86/kernel/apic_64.c
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/apic_64.c	2008-07-24 23:16:04.000000000 +0400
+++ linux-2.6.git/arch/x86/kernel/apic_64.c	2008-07-24 23:20:56.000000000 +0400
@@ -150,7 +150,7 @@ u32 safe_xapic_wait_icr_idle(void)
 
 void xapic_icr_write(u32 low, u32 id)
 {
-	apic_write(APIC_ICR2, id << 24);
+	apic_write(APIC_ICR2, SET_APIC_DEST_FIELD(id));
 	apic_write(APIC_ICR, low);
 }
 
