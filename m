Return-Path: <linux-kernel-owner+w=401wt.eu-S1760429AbYFQWdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760429AbYFQWdU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 18:33:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760226AbYFQWbw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 18:31:52 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:46788 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760215AbYFQWbu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 18:31:50 -0400
Date: Wed, 18 Jun 2008 01:30:24 +0300
From: Adrian Bunk <bunk@kernel.org>
To: lethal@linux-sh.org
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] sh: export get_cpu_subtype
Message-ID: <20080617223023.GH25911@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following build error:

<--  snip  -->

...
  MODPOST 1837 modules
ERROR: "get_cpu_subtype" [arch/sh/oprofile/oprofile.ko] undefined!
...
make[2]: *** [__modpost] Error 1

<--  snip  -->

Reported-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
3b4d9e75cf4e2d0eb47bc9e8867a9a60dbd1d8c2 diff --git a/arch/sh/kernel/setup.c b/arch/sh/kernel/setup.c
index bca2bbc..9324cb9 100644
--- a/arch/sh/kernel/setup.c
+++ b/arch/sh/kernel/setup.c
@@ -398,6 +398,7 @@ const char *get_cpu_subtype(struct sh_cpuinfo *c)
 {
 	return cpu_name[c->type];
 }
+EXPORT_SYMBOL(get_cpu_subtype);
 
 #ifdef CONFIG_PROC_FS
 /* Symbolic CPU flags, keep in sync with asm/cpu-features.h */

