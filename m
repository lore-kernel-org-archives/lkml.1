Return-Path: <linux-kernel-owner+w=401wt.eu-S1763610AbXGVTXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763610AbXGVTXR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 15:23:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760203AbXGVTXG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 15:23:06 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:19246 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757951AbXGVTXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 15:23:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:content-type:content-transfer-encoding;
        b=Y/A5oYVHt8Fu3o+Rx5ZzQ1MQaLN5l51Ei1gs47opdgGhb2skCxWkXZlnCMLhdBAnc9HebiChYPJKjI55uHRCOVSRnwV2qbFqJjoUWpXlSzQD0hTmJn0o6mnTYFQbfyiDw7IY4iDjD62mKvhuK3AP2rMlBeacvYEmGzZBT8Z5uf8=
Message-ID: <46A3AE06.9030706@googlemail.com>
Date: Sun, 22 Jul 2007 21:20:38 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070721)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Ingo Molnar <mingo@redhat.com>
Subject: [PATCH] Fix arch/i386/kernel/nmi.c - 'unknown_nmi_panic_callback'
 declared 'static' but never defined warning
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I get this warning when CONFIG_SYSCTL is not set :

...

arch/i386/kernel/nmi.c:52: warning: 'unknown_nmi_panic_callback' declared 'static' but never defined

...

Signed-off-by: Gabriel Craciunescu <nix.or.die@googlemail.com>

---

diff --git a/arch/i386/kernel/nmi.c b/arch/i386/kernel/nmi.c
index 03b7f55..cf11121 100644
--- a/arch/i386/kernel/nmi.c
+++ b/arch/i386/kernel/nmi.c
@@ -49,8 +49,9 @@ static unsigned int nmi_hz = HZ;
 static DEFINE_PER_CPU(short, wd_enabled);
 
 /* local prototypes */
+#ifdef CONFIG_SYSCTL
 static int unknown_nmi_panic_callback(struct pt_regs *regs, int cpu);
-
+#endif
 static int endflag __initdata = 0;
 
 #ifdef CONFIG_SMP
