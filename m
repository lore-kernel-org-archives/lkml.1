Return-Path: <linux-kernel-owner+w=401wt.eu-S1946252AbXBIJUM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946252AbXBIJUM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 04:20:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946250AbXBIJUL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 04:20:11 -0500
Received: from ozlabs.org ([203.10.76.45]:39331 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946253AbXBIJUJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 04:20:09 -0500
Subject: [PATCH 5/10] Make hvc_console.c compile on non-PowerPC
From: Rusty Russell <rusty@rustcorp.com.au>
To: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@osdl.org>, Andi Kleen <ak@muc.de>,
       virtualization <virtualization@lists.osdl.org>,
       Paul Mackerras <paulus@samba.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>
In-Reply-To: <1171012693.2718.37.camel@localhost.localdomain>
References: <1171012296.2718.26.camel@localhost.localdomain>
	 <1171012458.2718.30.camel@localhost.localdomain>
	 <1171012693.2718.37.camel@localhost.localdomain>
Content-Type: text/plain
Date: Fri, 09 Feb 2007 20:19:20 +1100
Message-Id: <1171012761.2718.40.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

There's a really nice console helper (esp. for virtual console
drivers) in drivers/char/hvc_console.c.  It has only ever been used
for PowerPC, though, so it uses NO_IRQ which is only defined there.

Let's fix that so it's more widely useful.  By, say, lguest.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

===================================================================
--- a/drivers/char/hvc_console.c
+++ b/drivers/char/hvc_console.c
@@ -48,6 +48,10 @@
 #define HVC_MINOR	0
 
 #define TIMEOUT		(10)
+
+#ifndef NO_IRQ
+#define NO_IRQ 0
+#endif
 
 /*
  * Wait this long per iteration while trying to push buffered data to the


