Return-Path: <linux-kernel-owner+w=401wt.eu-S1753389AbZFBXyi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753389AbZFBXyi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 19:54:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751449AbZFBXyb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 19:54:31 -0400
Received: from mail-fx0-f216.google.com ([209.85.220.216]:55554 "EHLO
	mail-fx0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776AbZFBXyb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 19:54:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=vrV1zQE69PHxo1TBQzuzEyOrItC2Lubc96jhcmz1bD1H7jXj3zGNcR6BeDqC32Mrnd
         kMbWU6E1pGHR3yLqouGeCXj1pkriVeOnr3DDBelotXyvVll//OSwl1QJsp09G79qwhF4
         TCzg3pl6r0s0jRuLvZxPdpHc/sj3bo0g+uB4s=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>
Subject: [PATCH] hw-breakpoints: fix undeclared ksym_tracer_mutex
Date: Wed,  3 Jun 2009 01:54:29 +0200
Message-Id: <1243986869-21149-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

Here is a patch for a build error on hardware breakpoints.

Thanks.

Frederic Weisbecker (1):
  hw-breakpoints: fix undeclared ksym_tracer_mutex

 kernel/trace/trace_ksym.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

The following changes since commit 62edab9056a6cf0c9207339c8892c923a5217e45:
  K.Prasad (1):
        hw-breakpoints: reset bits in dr6 after the corresponding exception is handled

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git hw-breakpoints-2

Frederic Weisbecker (1):
      hw-breakpoints: fix undeclared ksym_tracer_mutex

 kernel/trace/trace_ksym.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)
---
>From 73874005cd8800440be4299bd095387fff4b90ac Mon Sep 17 00:00:00 2001
From: Frederic Weisbecker <fweisbec@gmail.com>
Date: Wed, 3 Jun 2009 01:43:38 +0200
Subject: [PATCH] hw-breakpoints: fix undeclared ksym_tracer_mutex
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

ksym_tracer_mutex is declared inside an #ifdef CONFIG_PROFILE_KSYM_TRACER
section. This makes it unavailable for the hardware breakpoint tracer if it is
configured without the breakpoint profiler.

This patch fixes the following build error:

kernel/trace/trace_ksym.c: In function ‘ksym_trace_filter_read’:
kernel/trace/trace_ksym.c:226: erreur: ‘ksym_tracer_mutex’ undeclared (first use in this function)
kernel/trace/trace_ksym.c:226: erreur: (Each undeclared identifier is reported only once
kernel/trace/trace_ksym.c:226: erreur: for each function it appears in.)
kernel/trace/trace_ksym.c: In function ‘ksym_trace_filter_write’:
kernel/trace/trace_ksym.c:273: erreur: ‘ksym_tracer_mutex’ undeclared (first use in this function)
kernel/trace/trace_ksym.c: In function ‘ksym_trace_reset’:
kernel/trace/trace_ksym.c:335: erreur: ‘ksym_tracer_mutex’ undeclared (first use in this function)
make[1]: *** [kernel/trace/trace_ksym.o] Erreur 1

[ Impact: fix a build error ]

Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/trace/trace_ksym.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_ksym.c b/kernel/trace/trace_ksym.c
index 11c74f6..eef97e7 100644
--- a/kernel/trace/trace_ksym.c
+++ b/kernel/trace/trace_ksym.c
@@ -44,12 +44,12 @@ static unsigned int ksym_tracing_enabled;
 
 static HLIST_HEAD(ksym_filter_head);
 
+static DEFINE_MUTEX(ksym_tracer_mutex);
+
 #ifdef CONFIG_PROFILE_KSYM_TRACER
 
 #define MAX_UL_INT 0xffffffff
 
-static DEFINE_MUTEX(ksym_tracer_mutex);
-
 void ksym_collect_stats(unsigned long hbp_hit_addr)
 {
 	struct hlist_node *node;
-- 
1.6.2.3

