Return-Path: <linux-kernel-owner+w=401wt.eu-S1755962AbYKKLEa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755962AbYKKLEa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 06:04:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755371AbYKKLEV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 06:04:21 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:41651 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755361AbYKKLEV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 06:04:21 -0500
Date: Tue, 11 Nov 2008 12:04:13 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] tracing: function return tracer, build fix
Message-ID: <20081111110413.GA20368@elte.hu>
References: <49191C31.1050402@gmail.com> <20081111094312.GA16496@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081111094312.GA16496@elte.hu>
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


another small fixlet.

------------->
>From 19b3e9671c5a219b8c34da2cc66e0ce7c3a501ae Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Tue, 11 Nov 2008 11:57:02 +0100
Subject: [PATCH] tracing: function return tracer, build fix

fix:

 arch/x86/kernel/ftrace.c: In function 'ftrace_return_to_handler':
 arch/x86/kernel/ftrace.c:112: error: implicit declaration of function 'cpu_clock'

cpu_clock() is implicitly included via a number of ways, but its real
location is sched.h. (Build failure is triggerable if enough other
kernel components are turned off.)

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/ftrace.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 9b2325a..16a571d 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -14,6 +14,7 @@
 #include <linux/uaccess.h>
 #include <linux/ftrace.h>
 #include <linux/percpu.h>
+#include <linux/sched.h>
 #include <linux/init.h>
 #include <linux/list.h>
 

