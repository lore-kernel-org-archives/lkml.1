Return-Path: <linux-kernel-owner+w=401wt.eu-S1751894AbXB1HkB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751894AbXB1HkB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 02:40:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751725AbXB1Hj2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 02:39:28 -0500
Received: from serv1.oss.ntt.co.jp ([222.151.198.98]:44429 "EHLO
	serv1.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033AbXB1HjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 02:39:25 -0500
Subject: [PATCH] affinity is not defined in non-smp kernels - x86_64
From: Fernando Luis =?ISO-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ebiederm@xmission.com, ak@suse.de, akpm@linux-foundation.org
In-Reply-To: <Pine.LNX.4.64.0702272105220.12485@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0702272105220.12485@woody.linux-foundation.org>
Content-Type: text/plain
Organization: =?UTF-8?Q?NTT=E3=82=AA=E3=83=BC=E3=83=97=E3=83=B3=E3=82=BD=E3=83=BC?=
	=?UTF-8?Q?=E3=82=B9=E3=82=BD=E3=83=95=E3=83=88=E3=82=A6=E3=82=A7?=
	=?UTF-8?Q?=E3=82=A2=E3=82=BB=E3=83=B3=E3=82=BF?=
Date: Wed, 28 Feb 2007 16:17:22 +0900
Message-Id: <1172647042.29709.21.camel@sebastian.intellilink.co.jp>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Initialize affinity only when building SMP kernels.

Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
---

--- linux-2.6.21-rc2-dtt/arch/x86_64/kernel/io_apic.c	2007-03-06 15:20:14.000000000 +0900
+++ linux-2.6.21-rc2-kdump/arch/x86_64/kernel/io_apic.c	2007-03-06 15:48:52.000000000 +0900
@@ -832,7 +832,9 @@ static void setup_IO_APIC_irq(int apic, 
 	ioapic_write_entry(apic, pin, entry);
 
 	spin_lock_irqsave(&ioapic_lock, flags);
+#ifdef CONFIG_SMP
 	irq_desc[irq].affinity = TARGET_CPUS;
+#endif
 	spin_unlock_irqrestore(&ioapic_lock, flags);
 }
 


