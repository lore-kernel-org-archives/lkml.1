Return-Path: <linux-kernel-owner+w=401wt.eu-S1758963AbZAUNuy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758963AbZAUNuy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 08:50:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753482AbZAUNum
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 08:50:42 -0500
Received: from mtagate5.uk.ibm.com ([195.212.29.138]:39601 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753466AbZAUNul (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 08:50:41 -0500
Subject: [PATCH] sysrq: include interrupt.h instead of irq.h
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
       Andrew Morton <akpm@linux-foundation.org>, Mike Travis <travis@sgi.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
In-Reply-To: <20090121150249.a87aca09.sfr@canb.auug.org.au>
References: <20090121150249.a87aca09.sfr@canb.auug.org.au>
Content-Type: text/plain
Date: Wed, 21 Jan 2009 14:49:18 +0100
Message-Id: <1232545758.31303.2.camel@osiris.boeblingen.de.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

With "cpumask: update irq_desc to use cpumask_var_t" in linux-next
we get this compile bug on s390:

  CC      drivers/char/sysrq.o
In file included from drivers/char/sysrq.c:38:
include/linux/irq.h: In function 'init_alloc_desc_masks':
include/linux/irq.h:442: error: dereferencing pointer to incomplete type

drivers/char/sysrq.c should include interrupt.h instead of irq.h.

Cc: Mike Travis <travis@sgi.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 drivers/char/sysrq.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-next/drivers/char/sysrq.c
===================================================================
--- linux-next.orig/drivers/char/sysrq.c
+++ linux-next/drivers/char/sysrq.c
@@ -35,7 +35,7 @@
 #include <linux/vt_kern.h>
 #include <linux/workqueue.h>
 #include <linux/kexec.h>
-#include <linux/irq.h>
+#include <linux/interrupt.h>
 #include <linux/hrtimer.h>
 #include <linux/oom.h>
 


