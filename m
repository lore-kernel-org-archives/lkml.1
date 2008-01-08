Return-Path: <linux-kernel-owner+w=401wt.eu-S1759430AbYAHLYB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759430AbYAHLYB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 06:24:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758153AbYAHLXu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 06:23:50 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:33372 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758011AbYAHLXt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 06:23:49 -0500
Date: Tue, 8 Jan 2008 12:23:31 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       ak@suse.de
Subject: Re: [patch 2/2] track and print last unloaded module in the oops
	trace
Message-ID: <20080108112331.GA1162@elte.hu>
References: <20080106151946.50c3d8cc@laptopd505.fenrus.org> <200801071225.37707.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801071225.37707.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Rusty Russell <rusty@rustcorp.com.au> wrote:

> > Right now, only the last 1 module is tracked; I expect that this is 
> > enough for the vast majority of cases where this information 
> > matters; if it turns out that tracking more is important, we can 
> > always extend it to that.
> >
> > Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
> 
> Thanks, applied.

needs the fix below.

	Ingo

-------------->
Subject: track and print last unloaded module in the oops trace, fix
From: Ingo Molnar <mingo@elte.hu>

fix:

kernel/module.c: In function 'print_modules':
kernel/module.c:2508: error: 'last_unloaded_module' undeclared (first use in this function)
kernel/module.c:2508: error: (Each undeclared identifier is reported only once
kernel/module.c:2508: error: for each function it appears in.)

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/module.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux/kernel/module.c
===================================================================
--- linux.orig/kernel/module.c
+++ linux/kernel/module.c
@@ -498,6 +498,8 @@ static struct module_attribute modinfo_#
 MODINFO_ATTR(version);
 MODINFO_ATTR(srcversion);
 
+static char last_unloaded_module[MODULE_NAME_LEN+1];
+
 #ifdef CONFIG_MODULE_UNLOAD
 /* Init the unload section of the module. */
 static void module_unload_init(struct module *mod)
@@ -655,8 +657,6 @@ static void wait_for_zero_refcount(struc
 	mutex_lock(&module_mutex);
 }
 
-static char last_unloaded_module[MODULE_NAME_LEN+1];
-
 asmlinkage long
 sys_delete_module(const char __user *name_user, unsigned int flags)
 {
