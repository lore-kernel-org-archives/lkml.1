Return-Path: <linux-kernel-owner+w=401wt.eu-S1753562AbYIXQtF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753562AbYIXQtF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 12:49:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751681AbYIXQsx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 12:48:53 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:50050 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991AbYIXQsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 12:48:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:user-agent:date:from:to:cc:subject:content-disposition
         :message-id;
        b=i+U2CGVjwvWy68sG9DIvrAzhM/Is6j+zQPEQE4LAOTDb9KPGsWQX8hS3ZXdau9IIzr
         w/Bq3ieSfGtxX/myXYAxKfHrTSHORyNDfnQWnCu89vYH1CZm03cDTZvxd+F6ZCvhlXs7
         ppO0/nqsCVDHz4u21I66mqcc15a4aSeNidnOw=
References: <20080924164618.588609232@gmail.com>>
User-Agent: quilt/0.46-1
Date: Wed, 24 Sep 2008 20:46:21 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: mingo@elte.hu, macro@linux-mips.org, yhlu.kernel@gmail.com
Cc: linux-kernel@vger.kernel.org, Cyrill Gorcunov <gorcunov@gmail.com>
Subject: [patch 3/3] x86: apic - remove dead ifdef from lapic_is_integrated
Content-Disposition: inline; filename=x86-apic-lapic_is_integrated-cleanup
Message-ID: <48da6f73.0637560a.586e.4ec0@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We already have #ifdef in apicdef.h which depends
on cpu type so no need to re-introduce it.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

Index: linux-2.6.git/arch/x86/kernel/apic.c
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/apic.c	2008-09-24 19:33:31.000000000 +0400
+++ linux-2.6.git/arch/x86/kernel/apic.c	2008-09-24 20:25:05.000000000 +0400
@@ -167,11 +167,7 @@ static unsigned long apic_phys;
  */
 static inline int lapic_is_integrated(void)
 {
-#ifdef CONFIG_X86_64
-	return 1;
-#else
 	return APIC_INTEGRATED(lapic_get_version());
-#endif
 }
 
 /*

-- 
