Return-Path: <linux-kernel-owner+w=401wt.eu-S1759547AbYHNSsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759547AbYHNSsS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 14:48:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755209AbYHNSq4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 14:46:56 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:57044 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754417AbYHNSqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 14:46:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:references:user-agent:date:from:to:cc:subject
         :content-disposition;
        b=VSyGebNsp67s5UkDYU5jZPBi+gXCE0GVkZkV64a+j9llC/6TwzWwXsQ0ewkuKN2hp9
         DiYKdyDH1iN93T6KWlhmgpdkgpjocgwefpqXceIyJTtntn/bqMX3SfbFJX6nLxu4fs1W
         zjBcFAfG26i7YhdHLyETl/1Ns9ZFXA63aBJGw=
Message-Id: <20080814184652.179229281@gmail.com>
References: <20080814183428.550709025@gmail.com>
User-Agent: quilt/0.46-1
Date: Thu, 01 Jan 1970 03:00:06 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: macro@linux-mips.org, mingo@elte.hu, tglx@linutronix.de
Cc: hpa@zytor.com, yhlu.kernel@gmail.com, linux-kernel@vger.kernel.org,
       Cyrill Gorcunov <gorcunov@gmail.com>
Subject: [patch 6/8] x86: apic - unify verify_local_APIC
Content-Disposition: inline; filename=0010-x86-apic-unify-verify_local_APIC.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

Index: linux-2.6.git/arch/x86/kernel/apic_32.c
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/apic_32.c	2008-08-14 22:18:00.000000000 +0400
+++ linux-2.6.git/arch/x86/kernel/apic_32.c	2008-08-14 22:21:49.000000000 +0400
@@ -882,6 +882,12 @@ int __init verify_local_APIC(void)
 	 */
 	reg0 = apic_read(APIC_ID);
 	apic_printk(APIC_DEBUG, "Getting ID: %x\n", reg0);
+	apic_write(APIC_ID, reg0 ^ APIC_ID_MASK);
+	reg1 = apic_read(APIC_ID);
+	apic_printk(APIC_DEBUG, "Getting ID: %x\n", reg1);
+	apic_write(APIC_ID, reg0);
+	if (reg1 != (reg0 ^ APIC_ID_MASK))
+		return 0;
 
 	/*
 	 * The next two are just to see if we have sane values.

-- 
