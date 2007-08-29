Return-Path: <linux-kernel-owner+w=401wt.eu-S1756488AbXH2X34@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756488AbXH2X34 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 19:29:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759654AbXH2X3d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 19:29:33 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:37922 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759522AbXH2X3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 19:29:32 -0400
Date: Thu, 30 Aug 2007 01:29:33 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Jan Dittmer <jdi@l4x.org>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Christian Zankel <chris@zankel.net>
Subject: [2.6.23 patch] xtensa process.c must #include <linux/fs.h>
Message-ID: <20070829232933.GZ26410@stusta.de>
References: <46D5902C.1040905@googlemail.com> <46D5B544.4030708@l4x.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <46D5B544.4030708@l4x.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 29, 2007 at 08:04:52PM +0200, Jan Dittmer wrote:
> Michal Piotrowski wrote:
> > Subject         : 2.6.23-rc2 cross compile regressions (alpha,xtensa)
> > References      : http://lkml.org/lkml/2007/8/6/43 
> > Last known good : alpha: 2.6.22-git8 xtensa: 2.6.22-git6
> > Submitter       : Jan Dittmer <jdi@l4x.org>
> > Caused-By       : ?
> > Handled-By      : xtensa: Christian Zankel <chris@zankel.net>
> > Status          : unknown
> 
> Status: Unfixed
>...
> xtensa: http://l4x.org/k/?d=33728
>   CC      arch/xtensa/kernel/process.o
> arch/xtensa/kernel/process.c:50: error: `INR_OPEN' undeclared here (not in a function)
> arch/xtensa/kernel/process.c:50: error: initializer element is not constant
> arch/xtensa/kernel/process.c:50: error: (near initialization for `init_signals.rlim[7].rlim_cur')
>...

Patch below.

> Jan

cu
Adrian


<--  snip  -->


Another fallout from the removal of #include <linux/fs.h> from mm.h

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
6a0031b0f3f40238fc604bba264981776a155dbf 
diff --git a/arch/xtensa/kernel/process.c b/arch/xtensa/kernel/process.c
index ce758ba..dd498f1 100644
--- a/arch/xtensa/kernel/process.c
+++ b/arch/xtensa/kernel/process.c
@@ -30,6 +30,7 @@
 #include <linux/init_task.h>
 #include <linux/module.h>
 #include <linux/mqueue.h>
+#include <linux/fs.h>
 
 #include <asm/pgtable.h>
 #include <asm/uaccess.h>

