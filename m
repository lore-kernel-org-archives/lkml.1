Return-Path: <linux-kernel-owner+w=401wt.eu-S1755905AbYHNSrJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755905AbYHNSrJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 14:47:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753806AbYHNSqw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 14:46:52 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:57044 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753676AbYHNSqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 14:46:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:references:user-agent:date:from:to:cc:subject
         :content-disposition;
        b=F0UVdLXGk4tM8aVAXEblDDCUsSmmxYcNQeO21IhFZa5wcWcao/x0KqCZ04E9c6Mi/Q
         Dpx+rhopoiAYQxv9RTUeYhkM+wo8ijczlOUuXWPcG0Eu9LYd6NQ5h29bTkS/2FlTSpgQ
         V2YPi05NUjO0lOB71Vi6YCAVYBnGMWedLG/0k=
Message-Id: <20080814184651.294623640@gmail.com>
References: <20080814183428.550709025@gmail.com>
User-Agent: quilt/0.46-1
Date: Thu, 01 Jan 1970 03:00:01 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: macro@linux-mips.org, mingo@elte.hu, tglx@linutronix.de
Cc: hpa@zytor.com, yhlu.kernel@gmail.com, linux-kernel@vger.kernel.org,
       Cyrill Gorcunov <gorcunov@gmail.com>
Subject: [patch 1/8] x86: apic - use SET_APIC_DEST_FIELD instead of hardcoded shift
Content-Disposition: inline; filename=x86-apic-use-SET_APIC_DEST_FIELD-instead-of-hardc.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

Index: linux-2.6.git/arch/x86/kernel/apic_64.c
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/apic_64.c	2008-08-14 21:59:24.000000000 +0400
+++ linux-2.6.git/arch/x86/kernel/apic_64.c	2008-08-14 22:01:24.000000000 +0400
@@ -150,7 +150,7 @@ u32 safe_xapic_wait_icr_idle(void)
 
 void xapic_icr_write(u32 low, u32 id)
 {
-	apic_write(APIC_ICR2, id << 24);
+	apic_write(APIC_ICR2, SET_APIC_DEST_FIELD(id));
 	apic_write(APIC_ICR, low);
 }
 

-- 
