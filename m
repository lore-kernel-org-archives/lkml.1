Return-Path: <linux-kernel-owner+w=401wt.eu-S1759252AbXKGPFh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759252AbXKGPFh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 10:05:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754026AbXKGPF1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 10:05:27 -0500
Received: from crystal.sipsolutions.net ([195.210.38.204]:39022 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752273AbXKGPF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 10:05:27 -0500
Subject: [PATCH] powerpc swsusp: make altivec code depend on CONFIG_ALTIVEC
From: Johannes Berg <johannes@sipsolutions.net>
To: Paul Mackerras <paulus@samba.org>
Cc: Andy Whitcroft <apw@shadowen.org>, linux-kernel@vger.kernel.org,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>, linuxppc-dev@ozlabs.org,
       sam@ravnborg.org, David Miller <davem@davemloft.net>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
In-Reply-To: <1194428323.4055.3.camel@johannes.berg>
References: <47304343.2010709@linux.vnet.ibm.com>
	 <661de9470711060246s3040f68drf0a6310aeec4e1e8@mail.gmail.com>
	 <1194346486.4066.13.camel@johannes.berg>
	 <20071106.031001.189578769.davem@davemloft.net>
	 <47304FE5.2010309@linux.vnet.ibm.com> <47306E9C.4090202@linux.vnet.ibm.com>
	 <20071106154439.GK5080@shadowen.org>
	 <1194428323.4055.3.camel@johannes.berg>
Content-Type: text/plain
Date: Wed, 07 Nov 2007 13:59:44 +0100
Message-Id: <1194440384.4470.10.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This makes the altivec code in swsusp_32.S depend on CONFIG_ALTIVEC to
avoid build failures for systems that don't have altivec. I'm not sure
whether the code will actually work for other systems, but it was merged
for just ppc32 rather than powermac a very long time ago.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---

--- everything.orig/arch/powerpc/kernel/swsusp_32.S	2007-11-07 13:27:12.441517359 +0100
+++ everything/arch/powerpc/kernel/swsusp_32.S	2007-11-07 13:27:25.251519911 +0100
@@ -133,10 +133,12 @@ _GLOBAL(swsusp_arch_suspend)
 /* Resume code */
 _GLOBAL(swsusp_arch_resume)
 
+#ifdef CONFIG_ALTIVEC
 	/* Stop pending alitvec streams and memory accesses */
 BEGIN_FTR_SECTION
 	DSSALL
 END_FTR_SECTION_IFSET(CPU_FTR_ALTIVEC)
+#endif
  	sync
 
 	/* Disable MSR:DR to make sure we don't take a TLB or


