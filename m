Return-Path: <linux-kernel-owner+w=401wt.eu-S1753164AbZHXRzy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753164AbZHXRzy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 13:55:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753075AbZHXRzw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 13:55:52 -0400
Received: from mail-ew0-f207.google.com ([209.85.219.207]:55681 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752154AbZHXRzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 13:55:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:user-agent:date:from:to:cc:subject:references
         :content-disposition;
        b=iITf05/c6lonSS1BMV9jWAHVRc2ouo1xcEJGYQ0Z23Nzm+1z0gM5YDGiNaC0/R2OLm
         kfq44kkPdUcvZBmsvZyWR6Vc5dKN86vDzvFDSDFNb5/XTKQdoQe87700nD+TEb8fwz3e
         twLU9T/lgdEcTnaOthFicVwUVOIQsvof6rRfs=
Message-Id: <20090824175550.927946757@openvz.org>
User-Agent: quilt/0.47-1
Date: Mon, 24 Aug 2009 21:53:36 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Cyrill Gorcunov <gorcunov@openvz.org>
Subject: [rfc -tip 1/4] x86,ioapic: define IO_APIC_DEFAULT_PHYS_BASE constant
References: <20090824175335.186713800@openvz.org>
Content-Disposition: inline; filename=x86-io-apic-def-base
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We already have APIC_DEFAULT_PHYS_BASE so just to
be consistent.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
 arch/x86/include/asm/apicdef.h |    3 ++-
 arch/x86/kernel/mpparse.c      |   10 +++++-----
 2 files changed, 7 insertions(+), 6 deletions(-)

Index: linux-2.6.git/arch/x86/include/asm/apicdef.h
=====================================================================
--- linux-2.6.git.orig/arch/x86/include/asm/apicdef.h
+++ linux-2.6.git/arch/x86/include/asm/apicdef.h
@@ -8,7 +8,8 @@
  * Ingo Molnar <mingo@redhat.com>, 1999, 2000
  */
 
-#define	APIC_DEFAULT_PHYS_BASE	0xfee00000
+#define IO_APIC_DEFAULT_PHYS_BASE	0xfec00000
+#define	APIC_DEFAULT_PHYS_BASE		0xfee00000
 
 #define	APIC_ID		0x20
 
Index: linux-2.6.git/arch/x86/kernel/mpparse.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/mpparse.c
+++ linux-2.6.git/arch/x86/kernel/mpparse.c
@@ -482,11 +482,11 @@ static void __init construct_ioapic_tabl
 		MP_bus_info(&bus);
 	}
 
-	ioapic.type = MP_IOAPIC;
-	ioapic.apicid = 2;
-	ioapic.apicver = mpc_default_type > 4 ? 0x10 : 0x01;
-	ioapic.flags = MPC_APIC_USABLE;
-	ioapic.apicaddr = 0xFEC00000;
+	ioapic.type	= MP_IOAPIC;
+	ioapic.apicid	= 2;
+	ioapic.apicver	= mpc_default_type > 4 ? 0x10 : 0x01;
+	ioapic.flags	= MPC_APIC_USABLE;
+	ioapic.apicaddr	= IO_APIC_DEFAULT_PHYS_BASE;
 	MP_ioapic_info(&ioapic);
 
 	/*

