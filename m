Return-Path: <linux-kernel-owner+w=401wt.eu-S1756779AbYGXLoj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756779AbYGXLoj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 07:44:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756236AbYGXLoK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 07:44:10 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:28742 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756209AbYGXLoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 07:44:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:references:user-agent:date:from:to:cc:subject
         :content-disposition;
        b=BQsEdYbfqdSFXgzdAzCFk2eJTBC72ODpyXueRLFAEvztG0AR39JcsYnGBrIFtNDTfF
         O2VjCtltREe9ZeD8IIJz5mdRabq7hCbBIPr/q2AxFSjBKelCJDFldWDiV1zLp+rZrGkW
         47k86IKC6mbtn3PfEVn7vHc8ahPG/1UhqQ5eU=
Message-Id: <20080724114350.444031862@gmail.com>
References: <20080724114302.028278487@gmail.com>
User-Agent: quilt/0.46-1
Date: Thu, 01 Jan 1970 03:00:01 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: mingo@elte.hu, linux-kernel@vger.kernel.org, macro@linux-mips.org
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Subject: [patch 1/2] x86: apic unification - merge down lapic_get_maxlvt
Content-Disposition: inline; filename=x86-apic-merge-lapic_get_maxlvt
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

No code change on binary level.

Index: linux-2.6.git/arch/x86/kernel/apic_32.c
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/apic_32.c	2008-07-24 13:40:58.000000000 +0400
+++ linux-2.6.git/arch/x86/kernel/apic_32.c	2008-07-24 13:48:52.000000000 +0400
@@ -226,9 +226,13 @@ int get_physical_broadcast(void)
  */
 int lapic_get_maxlvt(void)
 {
-	unsigned int v = apic_read(APIC_LVR);
+	unsigned int v;
 
-	/* 82489DXs do not report # of LVT entries. */
+	v = apic_read(APIC_LVR);
+	/*
+	 * - we always have APIC integrated on 64bit mode
+	 * - 82489DXs do not report # of LVT entries
+	 */
 	return APIC_INTEGRATED(GET_APIC_VERSION(v)) ? GET_APIC_MAXLVT(v) : 2;
 }
 
Index: linux-2.6.git/arch/x86/kernel/apic_64.c
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/apic_64.c	2008-07-24 13:40:58.000000000 +0400
+++ linux-2.6.git/arch/x86/kernel/apic_64.c	2008-07-24 13:48:38.000000000 +0400
@@ -228,11 +228,14 @@ void __cpuinit enable_NMI_through_LVT0(v
  */
 int lapic_get_maxlvt(void)
 {
-	unsigned int v, maxlvt;
+	unsigned int v;
 
 	v = apic_read(APIC_LVR);
-	maxlvt = GET_APIC_MAXLVT(v);
-	return maxlvt;
+	/*
+	 * - we always have APIC integrated on 64bit mode
+	 * - 82489DXs do not report # of LVT entries
+	 */
+	return APIC_INTEGRATED(GET_APIC_VERSION(v)) ? GET_APIC_MAXLVT(v) : 2;
 }
 
 /*

-- 
