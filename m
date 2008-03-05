Return-Path: <linux-kernel-owner+w=401wt.eu-S1761360AbYCEIew@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761360AbYCEIew (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 03:34:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753947AbYCEIeo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 03:34:44 -0500
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:10524
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752762AbYCEIeo convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 03:34:44 -0500
Message-Id: <47CE6952.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 Beta 
Date: Wed, 05 Mar 2008 08:35:14 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] i386: fix merge mistake in i387.c
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

convert_fxsr_to_user() in 2.6.24's i387_32.c did this, and
convert_to_fxsr() also does the inverse, so I assume it's an oversight
that it is no longer being done.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 arch/x86/kernel/i387.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.25-rc4/arch/x86/kernel/i387.c	2008-03-05 09:26:15.000000000 +0100
+++ 2.6.25-rc4-i386-fpu-fop/arch/x86/kernel/i387.c	2008-03-04 09:03:19.000000000 +0100
@@ -261,7 +261,7 @@ static void convert_from_fxsr(struct use
 	}
 #else
 	env->fip = fxsave->fip;
-	env->fcs = fxsave->fcs;
+	env->fcs = (u16) fxsave->fcs | ((u32) fxsave->fop << 16);
 	env->foo = fxsave->foo;
 	env->fos = fxsave->fos;
 #endif



