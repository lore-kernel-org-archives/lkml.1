Return-Path: <linux-kernel-owner+w=401wt.eu-S1753912AbYJUKxe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753912AbYJUKxe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 06:53:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752584AbYJUKx0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 06:53:26 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:56594 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752169AbYJUKx0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 06:53:26 -0400
Date: Tue, 21 Oct 2008 12:52:29 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, oomichi@mxs.nes.nec.co.jp
Subject: [PATCH] Fix kexec compile error, undeclared 'vmlist'
Message-ID: <20081021105228.GC22217@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Current -git fails to compile, at least on ppc:

kernel/kexec.c: In function 'crash_save_vmcoreinfo_init':
kernel/kexec.c:1374: error: 'vmlist' undeclared (first use in this function)
kernel/kexec.c:1374: error: (Each undeclared identifier is reported only once
kernel/kexec.c:1374: error: for each function it appears in.)
kernel/kexec.c:1410: error: invalid use of undefined type 'struct vm_struct'

It's missing a vmalloc.h include, introduced by
acd99dbf54020f5c80b9aa2f2ea86f43cb285b02.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>

diff --git a/kernel/kexec.c b/kernel/kexec.c
index 777ac45..ac0fde7 100644
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -30,6 +30,7 @@
 #include <linux/pm.h>
 #include <linux/cpu.h>
 #include <linux/console.h>
+#include <linux/vmalloc.h>
 
 #include <asm/page.h>
 #include <asm/uaccess.h>

-- 
Jens Axboe

