Return-Path: <linux-kernel-owner+w=401wt.eu-S1757369AbYIDSoO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757369AbYIDSoO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 14:44:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757865AbYIDSjo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 14:39:44 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:13154 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757671AbYIDSjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 14:39:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:user-agent:date:from:to:cc:subject:content-disposition
         :message-id;
        b=OgVd29GS/GV4p8icqrAKimlJn1y3rFam5BBRRyQ6hOmhuvIBci630wirjZjhe+fmlL
         P+UuvSom9mKk5c2yxNGt3dGi5Ss2pDENcbEuRJ9iZTzUO0jzsfF1bNJXW8xNClQiYloj
         ZjhHdUlrj/G6GJdUBUSrz0YR7pJQV18kFLd+o=
References: <20080904183748.950151853@gmail.com>>
User-Agent: quilt/0.46-1
Date: Thu, 04 Sep 2008 22:37:50 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: mingo@elte.hu
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, tglx@linutronix.de,
       yhlu.kernel@gmail.com, macro@linux-mips.org,
       Cyrill Gorcunov <gorcunov@gmail.com>
Subject: [patch 2/3] x86: io-apic - declare irq_cfg_lock for SPARSE_IRQ only
Content-Disposition: inline; filename=x86-apic-irq_cfg_lock
Message-ID: <48c02b69.0407560a.0a50.7f99@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We use irq_cfg_lock lock in SPARSE_IRQ only context so
move it under #ifdef and compiler will be happy.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

Index: linux-2.6.git/arch/x86/kernel/io_apic.c
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/io_apic.c	2008-09-04 22:06:37.000000000 +0400
+++ linux-2.6.git/arch/x86/kernel/io_apic.c	2008-09-04 22:08:06.000000000 +0400
@@ -147,14 +147,15 @@ static void init_one_irq_cfg(struct irq_
 
 static struct irq_cfg *irq_cfgx;
 
+#ifdef CONFIG_HAVE_SPARSE_IRQ
 /*
  * Protect the irq_cfgx_free freelist:
  */
 static DEFINE_SPINLOCK(irq_cfg_lock);
 
-#ifdef CONFIG_HAVE_SPARSE_IRQ
 static struct irq_cfg *irq_cfgx_free;
 #endif
+
 static void __init init_work(void *data)
 {
 	struct dyn_array *da = data;

-- 
