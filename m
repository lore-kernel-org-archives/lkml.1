Return-Path: <linux-kernel-owner+w=401wt.eu-S1763162AbXJQUFi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763162AbXJQUFi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 16:05:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759459AbXJQUFG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 16:05:06 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:55093 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757923AbXJQUFF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 16:05:05 -0400
Date: Wed, 17 Oct 2007 22:06:30 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Mike Galbraith <efault@gmx.de>, Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: delete vsyscall files during make clean
Message-ID: <20071017200630.GH11837@uranus.ravnborg.org>
References: <1192164538.10413.3.camel@Homer.simpson.net> <20071012213114.GA24016@uranus.ravnborg.org> <1192246457.7395.19.camel@Homer.simpson.net> <47105A39.9070406@debian.org> <20071013071626.GA28168@uranus.ravnborg.org> <1192260909.7369.20.camel@Homer.simpson.net> <20071013081759.GB28168@uranus.ravnborg.org> <1192608832.30373.5.camel@Homer.simpson.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1192608832.30373.5.camel@Homer.simpson.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

make clean failed to delete a few files in
x86/kernel. This is because kbuild does not
see the correct/full kernel/Makefile.

As a workaround until the Makefiles are merged specify
the files to be deleted in the common Makefile.

Reported by Mike Galbraith <efault@gmx.de>

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Mike Galbraith <efault@gmx.de>
---
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 45855c9..3857334 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -3,3 +3,7 @@ include ${srctree}/arch/x86/kernel/Makefile_32
 else
 include ${srctree}/arch/x86/kernel/Makefile_64
 endif
+
+# Workaround to delete .lds files with make clean
+# The problem is that we do not enter Makefile_32 with make clean.
+clean-files := vsyscall*.lds vsyscall*.so
