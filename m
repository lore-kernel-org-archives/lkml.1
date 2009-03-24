Return-Path: <linux-kernel-owner+w=401wt.eu-S1756501AbZCXQNZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756501AbZCXQNZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 12:13:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758844AbZCXQGy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 12:06:54 -0400
Received: from ti-out-0910.google.com ([209.85.142.186]:41080 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762204AbZCXQGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 12:06:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=goQBGrz3fXjY4wx9qJ5NVZpdQZw1Uv5k6Y469cvdwlhBye/buY4+vD3f2e6gC1QrRt
         eFbmbLbxTweBUIExbihLVGn6jBf0xaUI0+xS1U9XMPr/OcuFrJfym/MgU0fr8P9i5La6
         es7zP4xd48LAqVTwIUsS9Q64wJsizYLItKh2o=
Date: Wed, 25 Mar 2009 00:07:19 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Andrew Morton <akpm@osdl.org>
Subject: [Patch] kernel/module.c: fix an unused goto label
Message-ID: <20090324160719.GE9686@hack>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Label 'free_init' is only used when defined(CONFIG_MODULE_UNLOAD) &&
defined(CONFIG_SMP), so move it inside to shut up gcc.

Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>

---
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

 
