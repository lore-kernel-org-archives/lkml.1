Return-Path: <linux-kernel-owner+w=401wt.eu-S1752588AbYKPIxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752588AbYKPIxU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 03:53:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751366AbYKPIxM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 03:53:12 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:52606 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751274AbYKPIxL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 03:53:11 -0500
Date: Sun, 16 Nov 2008 09:52:54 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH] markers/tracpoints: fix non-modular build
Message-ID: <20081116085254.GA25657@elte.hu>
References: <20081114224733.364965865@polymtl.ca> <20081114224947.972705093@polymtl.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081114224947.972705093@polymtl.ca>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> Use module notifiers instead of adding a hook in module.c.
> 
> Impact: cleanup.
> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> CC: 'Ingo Molnar' <mingo@elte.hu>
> CC: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
>  kernel/marker.c |   29 +++++++++++++++++++++++++++++
>  kernel/module.c |    4 ----
>  2 files changed, 29 insertions(+), 4 deletions(-)

>From 227a837567e339c74d9d4243d03a29bd943a018c Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Sun, 16 Nov 2008 09:50:34 +0100
Subject: [PATCH] markers/tracpoints: fix non-modular build

fix:

 kernel/marker.c: In function 'marker_module_notify':
 kernel/marker.c:905: error: 'MODULE_STATE_COMING' undeclared (first use in this function)
 [...]

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/marker.c     |    4 ++++
 kernel/tracepoint.c |    4 ++++
 2 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/kernel/marker.c b/kernel/marker.c
index c14ec26..ea54f26 100644
--- a/kernel/marker.c
+++ b/kernel/marker.c
@@ -896,6 +896,8 @@ void *marker_get_private_data(const char *name, marker_probe_func *probe,
 }
 EXPORT_SYMBOL_GPL(marker_get_private_data);
 
+#ifdef CONFIG_MODULES
+
 int marker_module_notify(struct notifier_block *self,
 			 unsigned long val, void *data)
 {
@@ -924,3 +926,5 @@ static int init_markers(void)
 	return register_module_notifier(&marker_module_nb);
 }
 __initcall(init_markers);
+
+#endif /* CONFIG_MODULES */
diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
index 94ac4e3..7960274 100644
--- a/kernel/tracepoint.c
+++ b/kernel/tracepoint.c
@@ -542,6 +542,8 @@ void tracepoint_iter_reset(struct tracepoint_iter *iter)
 }
 EXPORT_SYMBOL_GPL(tracepoint_iter_reset);
 
+#ifdef CONFIG_MODULES
+
 int tracepoint_module_notify(struct notifier_block *self,
 			     unsigned long val, void *data)
 {
@@ -570,3 +572,5 @@ static int init_tracepoints(void)
 	return register_module_notifier(&tracepoint_module_nb);
 }
 __initcall(init_tracepoints);
+
+#endif /* CONFIG_MODULES */
