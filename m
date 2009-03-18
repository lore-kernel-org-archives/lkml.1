Return-Path: <linux-kernel-owner+w=401wt.eu-S1761447AbZCRWAm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761447AbZCRWAm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 18:00:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759799AbZCRWAH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 18:00:07 -0400
Received: from gw03.mail.saunalahti.fi ([195.197.172.111]:42965 "EHLO
	gw03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761356AbZCRWAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 18:00:05 -0400
From: Dmitri Vorobiev <dmitri.vorobiev@movial.com>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Dmitri Vorobiev <dmitri.vorobiev@movial.com>
Subject: [PATCH 2/3] Restrict definition of a label in kernel/module.c
Date: Wed, 18 Mar 2009 23:49:26 +0200
Message-Id: <1237412967-20754-2-git-send-email-dmitri.vorobiev@movial.com>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1237412967-20754-1-git-send-email-dmitri.vorobiev@movial.com>
References: <1237412967-20754-1-git-send-email-dmitri.vorobiev@movial.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In function 'load_module' in kernel/module.c, the label 'free_init'
is used if and only if both CONFIG_MODULE_UNLOAD and CONFIG_SMP are
defined. However, the label itself is defined unconditionally,
which may produce the following warning:

kernel/module.c:2291: warning: label 'free_init' defined but not used

This patch fixes the warning by moving the label definition under an
appropriate preprocessor construct.

Signed-off-by: Dmitri Vorobiev <dmitri.vorobiev@movial.com>
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
1.5.6.3

