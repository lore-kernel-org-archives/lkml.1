Return-Path: <linux-kernel-owner+w=401wt.eu-S1756046AbXD0QSp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756046AbXD0QSp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 12:18:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756048AbXD0QSp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 12:18:45 -0400
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:42122 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756046AbXD0QSo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 12:18:44 -0400
To: jdike@addtoit.com
CC: linux-kernel@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net
Subject: [patch] uml: fix cmpxchg warnings in -mm
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Message-Id: <E1HhT90-0001dW-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 27 Apr 2007 18:18:02 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Miklos Szeredi <mszeredi@suse.cz>

I get lot's of these on i386:

In file included from include/asm/atomic.h:10,
                 from include/linux/file.h:9,
                 from mm/fadvise.c:12:
include/asm/arch/atomic.h: In function ‘atomic_add_unless’:
include/asm/arch/atomic.h:240: warning: implicit declaration of function ‘cmpxchg’
[...]

The problem seems to be that <asm-i386/atomic.h> assumes that
<asm/processor.h> pulls in <asm/system.h>.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---

Index: linux/include/asm-um/processor-i386.h
===================================================================
--- linux.orig/include/asm-um/processor-i386.h	2007-04-26 15:16:47.000000000 +0200
+++ linux/include/asm-um/processor-i386.h	2007-04-27 17:58:25.000000000 +0200
@@ -9,6 +9,7 @@
 #include "linux/string.h"
 #include "asm/host_ldt.h"
 #include "asm/segment.h"
+#include "asm/system.h"
 
 extern int host_has_xmm;
 extern int host_has_cmov;
