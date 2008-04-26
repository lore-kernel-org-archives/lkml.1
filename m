Return-Path: <linux-kernel-owner+w=401wt.eu-S1756442AbYDZJhm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756442AbYDZJhm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 05:37:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753267AbYDZJhe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 05:37:34 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45764 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753183AbYDZJhd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 05:37:33 -0400
Date: Sat, 26 Apr 2008 11:36:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Jason Baron <jbaron@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Adrian Bunk <bunk@stusta.de>, Andi Kleen <andi@firstfloor.org>,
       Christoph Hellwig <hch@infradead.org>, akpm@osdl.org
Subject: Re: [patch 13/37] Immediate Values - Architecture Independent Code
Message-ID: <20080426093641.GA10060@elte.hu>
References: <20080424150324.802695381@polymtl.ca> <20080424151357.576697846@polymtl.ca> <20080425145552.GA20351@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080425145552.GA20351@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> randconfig testing in sched-devel caught a build bug - fixed by the 
> patch below.

found another build failure - the better fix is the one below.

	Ingo

------------------------->
Subject: markers: fix2
From: Ingo Molnar <mingo@elte.hu>
Date: Sat Apr 26 11:19:00 CEST 2008

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/module.h |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

Index: linux/include/linux/module.h
===================================================================
--- linux.orig/include/linux/module.h
+++ linux/include/linux/module.h
@@ -472,9 +472,6 @@ extern void print_modules(void);
 
 extern void module_update_markers(void);
 
-extern void _module_imv_update(void);
-extern void module_imv_update(void);
-
 #else /* !CONFIG_MODULES... */
 #define EXPORT_SYMBOL(sym)
 #define EXPORT_SYMBOL_GPL(sym)
@@ -579,15 +576,19 @@ static inline void module_update_markers
 {
 }
 
+#endif /* CONFIG_MODULES */
+
+#if defined(MODULES) && defined(CONFIG_IMMEDIATE)
+extern void _module_imv_update(void);
+extern void module_imv_update(void);
+#else
 static inline void _module_imv_update(void)
 {
 }
-
 static inline void module_imv_update(void)
 {
 }
-
-#endif /* CONFIG_MODULES */
+#endif
 
 struct device_driver;
 #ifdef CONFIG_SYSFS
