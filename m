Return-Path: <linux-kernel-owner+w=401wt.eu-S1762182AbYDSPG6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762182AbYDSPG6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 11:06:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762288AbYDSPGh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 11:06:37 -0400
Received: from rv-out-0708.google.com ([209.85.198.246]:51686 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762277AbYDSPGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 11:06:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:user-agent:date:from:to:cc:subject:content-disposition:message-id;
        b=dKzJYaAq6hEhaV9laZuQEALoIIKu5qlK4Mzpr+tWP4DW7CwoxxKDfwwQVY2joRLaZTblPC9sDMx1vlykRcc7IGfZ4MD43kV19gyBVld8hyp2lK4fEVOQc6+7R4dJP7/qPqlHB1q6iQR9z6H81AQOGeS4n+7NAYoJzOaJayPcuic=
References: <20080419145510.150338641@gmail.com>>
User-Agent: quilt/0.46-1
Date: Sat, 19 Apr 2008 23:55:12 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [patch 02/10] x86: use MP_intsrc_info()
Content-Disposition: inline; filename=x86-use-MP_intsrc_info.patch
Message-ID: <480a0a7b.1f538c0a.7e66.3ade@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove duplicate code by using MP_intsrc_info() in mpparse.c

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 arch/x86/kernel/mpparse.c |   19 ++-----------------
 1 file changed, 2 insertions(+), 17 deletions(-)

Index: 2.6-git/arch/x86/kernel/mpparse.c
===================================================================
--- 2.6-git.orig/arch/x86/kernel/mpparse.c
+++ 2.6-git/arch/x86/kernel/mpparse.c
@@ -907,14 +907,7 @@ void __init mp_override_legacy_irq(u8 bu
 	intsrc.mpc_dstapic = mp_ioapics[ioapic].mpc_apicid;	/* APIC ID */
 	intsrc.mpc_dstirq = pin;	/* INTIN# */
 
-	Dprintk("Int: type %d, pol %d, trig %d, bus %d, irq %d, %d-%d\n",
-		intsrc.mpc_irqtype, intsrc.mpc_irqflag & 3,
-		(intsrc.mpc_irqflag >> 2) & 3, intsrc.mpc_srcbus,
-		intsrc.mpc_srcbusirq, intsrc.mpc_dstapic, intsrc.mpc_dstirq);
-
-	mp_irqs[mp_irq_entries] = intsrc;
-	if (++mp_irq_entries == MAX_IRQ_SOURCES)
-		panic("Max # of irq sources exceeded!\n");
+	MP_intsrc_info(&intsrc);
 }
 
 int es7000_plat;
@@ -983,15 +976,7 @@ void __init mp_config_acpi_legacy_irqs(v
 		intsrc.mpc_srcbusirq = i;	/* Identity mapped */
 		intsrc.mpc_dstirq = i;
 
-		Dprintk("Int: type %d, pol %d, trig %d, bus %d, irq %d, "
-			"%d-%d\n", intsrc.mpc_irqtype, intsrc.mpc_irqflag & 3,
-			(intsrc.mpc_irqflag >> 2) & 3, intsrc.mpc_srcbus,
-			intsrc.mpc_srcbusirq, intsrc.mpc_dstapic,
-			intsrc.mpc_dstirq);
-
-		mp_irqs[mp_irq_entries] = intsrc;
-		if (++mp_irq_entries == MAX_IRQ_SOURCES)
-			panic("Max # of irq sources exceeded!\n");
+		MP_intsrc_info(&intsrc);
 	}
 }
 

-- 
