Return-Path: <linux-kernel-owner+w=401wt.eu-S1752856AbZHEVwA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752856AbZHEVwA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 17:52:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752822AbZHEVv7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 17:51:59 -0400
Received: from one.firstfloor.org ([213.235.205.2]:42941 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752759AbZHEVva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 17:51:30 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <200908051151.557035535@firstfloor.org>
In-Reply-To: <200908051151.557035535@firstfloor.org>
To: sam@ravnborg.org, linux-kbuild@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [4/5] kbuild: Fail build if recordmcount.pl fails
Message-Id: <20090805215130.BAEB1B15D8@basil.firstfloor.org>
Date: Wed,  5 Aug 2009 23:51:30 +0200 (CEST)
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
