Return-Path: <linux-kernel-owner+w=401wt.eu-S1757142AbZINUTp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757142AbZINUTp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 16:19:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933546AbZINUTV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 16:19:21 -0400
Received: from one.firstfloor.org ([213.235.205.2]:42022 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757128AbZINUSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 16:18:07 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <200909141018.915641783@firstfloor.org>
In-Reply-To: <200909141018.915641783@firstfloor.org>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, sam@ravnborg.org
Subject: [PATCH] [4/5] kbuild: Fail build if recordmcount.pl fails
Message-Id: <20090914201810.029B9B1757@basil.firstfloor.org>
Date: Mon, 14 Sep 2009 22:18:10 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When this script fails the build should fail too. Otherwise there
are mysterious build failures later.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 scripts/Makefile.build |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.31-rc1-ak/scripts/Makefile.build
===================================================================
--- linux-2.6.31-rc1-ak.orig/scripts/Makefile.build
+++ linux-2.6.31-rc1-ak/scripts/Makefile.build
@@ -206,7 +206,7 @@ cmd_modversions =							\
 endif
 
 ifdef CONFIG_FTRACE_MCOUNT_RECORD
-cmd_record_mcount = perl $(srctree)/scripts/recordmcount.pl "$(ARCH)" \
+cmd_record_mcount = set -e ; perl $(srctree)/scripts/recordmcount.pl "$(ARCH)" \
 	"$(if $(CONFIG_64BIT),64,32)" \
 	"$(OBJDUMP)" "$(OBJCOPY)" "$(CC)" "$(LD)" "$(NM)" "$(RM)" "$(MV)" \
 	"$(if $(part-of-module),1,0)" "$(@)";
