Return-Path: <linux-kernel-owner+w=401wt.eu-S1757173AbZCYTn1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757173AbZCYTn1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 15:43:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750940AbZCYTnQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 15:43:16 -0400
Received: from jacques.telenet-ops.be ([195.130.132.50]:55639 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738AbZCYTnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 15:43:15 -0400
Date: Wed, 25 Mar 2009 20:43:06 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Masami Hiramatsu <mhiramat@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>
cc: Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [PATCH] module: Kill warning: label 'free_init' defined but not used
Message-ID: <Pine.LNX.4.64.0903252041190.14101@anakin>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On m68k (which doesn't do SMP), I get:

| kernel/module.c:2291: warning: label 'free_init' defined but not used

which was introduced by commit 6e2b75740bed35df98b8113300579e13ed2ce848
("module: fix refptr allocation and release order").
Move the label inside the #ifdef, as the goto is protected by the same #ifdef.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 kernel/module.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index 1196f5d..df00a1b 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2288,8 +2288,8 @@ static noinline struct module *load_module(void __user *umod,
 	ftrace_release(mod->module_core, mod->core_size);
  free_unload:
 	module_unload_free(mod);
- free_init:
 #if defined(CONFIG_MODULE_UNLOAD) && defined(CONFIG_SMP)
+ free_init:
 	percpu_modfree(mod->refptr);
 #endif
 	module_free(mod, mod->module_init);
-- 
1.6.2


Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
