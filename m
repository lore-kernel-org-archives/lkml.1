Return-Path: <linux-kernel-owner+w=401wt.eu-S1760790AbYFQWdu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760790AbYFQWdu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 18:33:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760157AbYFQWcV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 18:32:21 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:50762 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759576AbYFQWcT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 18:32:19 -0400
Date: Wed, 18 Jun 2008 01:30:53 +0300
From: Adrian Bunk <bunk@kernel.org>
To: lethal@linux-sh.org
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] move arch/sh/lib/io.o to obj-y
Message-ID: <20080617223053.GJ25911@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

EXPORT_SYMBOL's in lib-y considered harmful:

<--  snip  -->

...
  MODPOST 1837 modules
ERROR: "__raw_readsl" [drivers/ssb/ssb.ko] undefined!
ERROR: "__raw_writesl" [drivers/ssb/ssb.ko] undefined!
ERROR: "__raw_writesl" [drivers/net/smc91x.ko] undefined!
ERROR: "__raw_readsl" [drivers/net/smc91x.ko] undefined!
ERROR: "__raw_writesl" [drivers/net/3c59x.ko] undefined!
ERROR: "__raw_readsl" [drivers/net/3c59x.ko] undefined!
...
make[2]: *** [__modpost] Error 1

<--  snip  -->

Reported-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

b4dec4046b4e491c0ad2cb1046699f22d635fcab diff --git a/arch/sh/lib/Makefile b/arch/sh/lib/Makefile
index 3424b90..265aca0 100644
--- a/arch/sh/lib/Makefile
+++ b/arch/sh/lib/Makefile
@@ -2,9 +2,11 @@
 # Makefile for SuperH-specific library files..
 #
 
-lib-y  = delay.o io.o memset.o memmove.o memchr.o \
+lib-y  = delay.o memset.o memmove.o memchr.o \
 	 checksum.o strlen.o div64.o div64-generic.o
 
+obj-y				+= io.o
+
 memcpy-y			:= memcpy.o
 memcpy-$(CONFIG_CPU_SH4)	:= memcpy-sh4.o
 
