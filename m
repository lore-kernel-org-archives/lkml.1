Return-Path: <linux-kernel-owner+w=401wt.eu-S1757612AbXG1UxK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757612AbXG1UxK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 16:53:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756242AbXG1Uw5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 16:52:57 -0400
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:55975 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756055AbXG1Uw4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 16:52:56 -0400
Date: Sat, 28 Jul 2007 23:52:54 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: Sam Ravnborg <sam@ravnborg.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Richard Henderson <rth@twiddle.net>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Jay Estabrook <jay.estabrook@hp.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: [PATCH] add a missing LIB_Y to arch/alpha/boot Makefile
In-Reply-To: <20070728202012.GB25619@uranus.ravnborg.org>
Message-ID: <Pine.SOC.4.64.0707282338580.22996@math.ut.ee>
References: <Pine.SOC.4.64.0706041419470.7370@math>
 <20070605231712.ff1df46f.akpm@linux-foundation.org>
 <Pine.SOC.4.64.0707281950340.20474@math.ut.ee> <20070728200450.GA25619@uranus.ravnborg.org>
 <20070728202012.GB25619@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> kasprintf pulls in kmalloc which proved to be fatal for at least
> bootimage target on alpha.
> Move it to a separate file so only users of kasprintf are exposed
> to the dependency on kmalloc.

Withe the addition of missing $(LIB_Y) it really seems to compile now. 
Can not boot test before some time next week.

Add $(LIBS_Y) to get lib/lib.a so srm_printk is present.

Signed-off-by: Meelis Roos <mroos@linux.ee>

diff --git a/arch/alpha/boot/Makefile b/arch/alpha/boot/Makefile
index e1ae14c..cd14388 100644
--- a/arch/alpha/boot/Makefile
+++ b/arch/alpha/boot/Makefile
@@ -104,7 +104,7 @@ OBJ_bootlx   := $(obj)/head.o $(obj)/main.o
 OBJ_bootph   := $(obj)/head.o $(obj)/bootp.o
 OBJ_bootpzh  := $(obj)/head.o $(obj)/bootpz.o $(obj)/misc.o
 
-$(obj)/bootloader: $(obj)/bootloader.lds $(OBJ_bootlx) FORCE
+$(obj)/bootloader: $(obj)/bootloader.lds $(OBJ_bootlx) $(LIBS_Y) FORCE
 	$(call if_changed,ld)
 
 $(obj)/bootpheader: $(obj)/bootloader.lds $(OBJ_bootph) $(LIBS_Y) FORCE

-- 
Meelis Roos (mroos@linux.ee)
