Return-Path: <linux-kernel-owner+w=401wt.eu-S1753915AbXJXH2l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753915AbXJXH2l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 03:28:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751068AbXJXH2d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 03:28:33 -0400
Received: from havoc.gtf.org ([69.61.125.42]:55905 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750836AbXJXH2d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 03:28:33 -0400
Date: Wed, 24 Oct 2007 03:28:32 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 2.6.24-rc1] lguest: build fix
Message-ID: <20071024072832.GA26606@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Fix this error (i386 !SMP build)

arch/x86/lguest/boot.c: In function ‘lguest_init’:
arch/x86/lguest/boot.c:1059: error: ‘pm_power_off’ undeclared (first use in this function)

by including linux/pm.h.

Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
---
Gee, lguest appears to be unmaintained, according to MAINTAINERS :)

diff --git a/arch/x86/lguest/boot.c b/arch/x86/lguest/boot.c
index d2235db..8f13562 100644
--- a/arch/x86/lguest/boot.c
+++ b/arch/x86/lguest/boot.c
@@ -56,6 +56,7 @@
 #include <linux/lguest.h>
 #include <linux/lguest_launcher.h>
 #include <linux/virtio_console.h>
+#include <linux/pm.h>
 #include <asm/paravirt.h>
 #include <asm/param.h>
 #include <asm/page.h>
