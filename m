Return-Path: <linux-kernel-owner+w=401wt.eu-S1752970AbYIXQtZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752970AbYIXQtZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 12:49:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752000AbYIXQsy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 12:48:54 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:50296 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166AbYIXQsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 12:48:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:user-agent:date:from:to:cc:subject:content-disposition
         :message-id;
        b=EOQvowaE9JbcrT0adEzQZ+XslJ/qEgZMHL/z3+KrNDpOq08SU08At4s8Uy7vIerHdZ
         gGlt0zIJK5NWKap967L9o+Mf5ZNOl+/C9TQQ0fnh6PB+rMfkwyf9k+Aj+dsbzawiNlLc
         gPTDrvJKK2BQpjxz2M8nLqau8jcqCP4msRO3Y=
References: <20080924164618.588609232@gmail.com>>
User-Agent: quilt/0.46-1
Date: Wed, 24 Sep 2008 20:46:20 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: mingo@elte.hu, macro@linux-mips.org, yhlu.kernel@gmail.com
Cc: linux-kernel@vger.kernel.org, Cyrill Gorcunov <gorcunov@gmail.com>
Subject: [patch 2/3] x86: apic - simplify lapic_get_maxlvt
Content-Disposition: inline; filename=x86-apic-lapic_get_maxlvt-cleanup
Message-ID: <48da6f73.0c07560a.1702.41f4@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lets use lapic_get_version helper and hide
register being read. Also it allow us to
make code a bit tighter.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

Index: linux-2.6.git/arch/x86/kernel/apic.c
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/apic.c	2008-09-24 19:17:20.000000000 +0400
+++ linux-2.6.git/arch/x86/kernel/apic.c	2008-09-24 19:33:31.000000000 +0400
@@ -309,14 +309,14 @@ int get_physical_broadcast(void)
  */
 int lapic_get_maxlvt(void)
 {
-	unsigned int v;
+	unsigned int ver;
 
-	v = apic_read(APIC_LVR);
+	ver = lapic_get_version();
 	/*
 	 * - we always have APIC integrated on 64bit mode
 	 * - 82489DXs do not report # of LVT entries
 	 */
-	return APIC_INTEGRATED(GET_APIC_VERSION(v)) ? GET_APIC_MAXLVT(v) : 2;
+	return APIC_INTEGRATED(ver) ? GET_APIC_MAXLVT(ver) : 2;
 }
 
 /*

-- 
