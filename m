Return-Path: <linux-kernel-owner+w=401wt.eu-S1761408AbZCXT1g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761408AbZCXT1g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 15:27:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755694AbZCXT1M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 15:27:12 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59940 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753096AbZCXT1L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 15:27:11 -0400
Date: Tue, 24 Mar 2009 20:26:47 +0100
From: Ingo Molnar <mingo@elte.hu>
To: =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [Patch] kernel/module.c: fix an unused goto label
Message-ID: <20090324192647.GA26930@elte.hu>
References: <20090324160719.GE9686@hack>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090324160719.GE9686@hack>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Américo Wang <xiyou.wangcong@gmail.com> wrote:

> Label 'free_init' is only used when defined(CONFIG_MODULE_UNLOAD) &&
> defined(CONFIG_SMP), so move it inside to shut up gcc.
> 
> Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
> Cc: Rusty Russell <rusty@rustcorp.com.au>

was already sent a week ago - see below.

	Ingo

------------->
>From 67f5ca081c6ace125e8ccc76b8a7d99b091abaa7 Mon Sep 17 00:00:00 2001
From: Dmitri Vorobiev <dmitri.vorobiev@movial.com>
Date: Wed, 18 Mar 2009 23:49:26 +0200
Subject: [PATCH] modules: Restrict definition of a label in kernel/module.c

Impact: cleanup

In function 'load_module' in kernel/module.c, the label 'free_init'
is used if and only if both CONFIG_MODULE_UNLOAD and CONFIG_SMP are
defined. However, the label itself is defined unconditionally,
which may produce the following warning:

kernel/module.c:2291: warning: label 'free_init' defined but not used

This patch fixes the warning by moving the label definition under an
appropriate preprocessor construct.

Signed-off-by: Dmitri Vorobiev <dmitri.vorobiev@movial.com>
Cc: akpm@linux-foundation.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
