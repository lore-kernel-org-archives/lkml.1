Return-Path: <linux-kernel-owner+w=401wt.eu-S1753696AbZHZGWx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753696AbZHZGWx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 02:22:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753280AbZHZGWv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 02:22:51 -0400
Received: from hera.kernel.org ([140.211.167.34]:50912 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750950AbZHZGWs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 02:22:48 -0400
Date: Wed, 26 Aug 2009 06:22:17 GMT
From: tip-bot for Cyrill Gorcunov <gorcunov@openvz.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       gorcunov@openvz.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       gorcunov@openvz.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090824175550.927946757@openvz.org>
References: <20090824175550.927946757@openvz.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, ioapic: Define IO_APIC_DEFAULT_PHYS_BASE constant
Message-ID: <tip-8f3e1df48baf728bbb0f242c9dff9c9d7108218a@git.kernel.org>
Git-Commit-ID: 8f3e1df48baf728bbb0f242c9dff9c9d7108218a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 26 Aug 2009 06:22:17 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8f3e1df48baf728bbb0f242c9dff9c9d7108218a
Gitweb:     http://git.kernel.org/tip/8f3e1df48baf728bbb0f242c9dff9c9d7108218a
Author:     Cyrill Gorcunov <gorcunov@openvz.org>
AuthorDate: Mon, 24 Aug 2009 21:53:36 +0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 26 Aug 2009 08:16:38 +0200

x86, ioapic: Define IO_APIC_DEFAULT_PHYS_BASE constant

We already have APIC_DEFAULT_PHYS_BASE so just to be
consistent.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
LKML-Reference: <20090824175550.927946757@openvz.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/include/asm/apicdef.h |    3 ++-
 arch/x86/kernel/mpparse.c      |   10 +++++-----
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/apicdef.h b/arch/x86/include/asm/apicdef.h
index 7ddb36a..7386bfa 100644
--- a/arch/x86/include/asm/apicdef.h
+++ b/arch/x86/include/asm/apicdef.h
@@ -8,7 +8,8 @@
  * Ingo Molnar <mingo@redhat.com>, 1999, 2000
  */
 
-#define	APIC_DEFAULT_PHYS_BASE	0xfee00000
+#define IO_APIC_DEFAULT_PHYS_BASE	0xfec00000
+#define	APIC_DEFAULT_PHYS_BASE		0xfee00000
 
 #define	APIC_ID		0x20
 
diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index 651c93b..fcd513b 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -482,11 +482,11 @@ static void __init construct_ioapic_table(int mpc_default_type)
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
