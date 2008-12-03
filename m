Return-Path: <linux-kernel-owner+w=401wt.eu-S1753646AbYLCQcz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753646AbYLCQcz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 11:32:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752635AbYLCQc3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 11:32:29 -0500
Received: from mx2.redhat.com ([66.187.237.31]:60390 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754189AbYLCQc1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 11:32:27 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 2/3] [PATCH] param: Stop gcc from inlining empty weak functions
To: rusty@rustcorp.com.au
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org
Date: Wed, 03 Dec 2008 16:32:12 +0000
Message-ID: <20081203163212.13965.80352.stgit@warthog.procyon.org.uk>
In-Reply-To: <20081203163207.13965.56517.stgit@warthog.procyon.org.uk>
References: <20081203163207.13965.56517.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stop gcc from inlining empty weak functions by making them non-empty.  The gcc
I have for FRV (4.1.2) will inline empty weak functions that are in the same
file, even if those functions are marked 'noinline'.

Without this patch, the default arch_get_boot_command_line() is rolled into
start_kernel(), and the arch specific one is not called, thus making the
kernel unbootable.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 init/main.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)


diff --git a/init/main.c b/init/main.c
index 92ad2fe..665993b 100644
--- a/init/main.c
+++ b/init/main.c
@@ -522,15 +522,18 @@ static void __init boot_cpu_init(void)
 
 void __init __weak smp_setup_processor_id(void)
 {
+	barrier();
 }
 
 void __init __weak thread_info_cache_init(void)
 {
+	barrier();
 }
 
 /* If the arch already sets boot_command_line, we need do nothing. */
 void __init __weak arch_get_boot_command_line(void)
 {
+	barrier();
 }
 
 /* Ideally, this would take a 'const char *cmdline' param. */

