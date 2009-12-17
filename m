Return-Path: <linux-kernel-owner+w=401wt.eu-S1763452AbZLQAhT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763452AbZLQAhT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 19:37:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762867AbZLQAhQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 19:37:16 -0500
Received: from hera.kernel.org ([140.211.167.34]:45864 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758163AbZLQAhO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 19:37:14 -0500
Date: Thu, 17 Dec 2009 00:36:40 GMT
From: tip-bot for Simon Horman <horms@verge.net.au>
Cc: linux-kernel@vger.kernel.org, horms@verge.net.au, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, horms@verge.net.au,
       linux-kernel@vger.kernel.org, tglx@linutronix.de
In-Reply-To: <20091217001542.GD25317@verge.net.au>
References: <20091217001542.GD25317@verge.net.au>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/urgent] timers: Remove duplicate setting of new_base in __mod_timer()
Message-ID: <tip-cf1e367ee84e02ac349ad0858eb65e8a6a511c8b@git.kernel.org>
Git-Commit-ID: cf1e367ee84e02ac349ad0858eb65e8a6a511c8b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cf1e367ee84e02ac349ad0858eb65e8a6a511c8b
Gitweb:     http://git.kernel.org/tip/cf1e367ee84e02ac349ad0858eb65e8a6a511c8b
Author:     Simon Horman <horms@verge.net.au>
AuthorDate: Thu, 17 Dec 2009 11:15:42 +1100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 17 Dec 2009 01:30:49 +0100

timers: Remove duplicate setting of new_base in __mod_timer()

new_base is set using per_cpu(tvec_bases, cpu) after selecting the
desired value of cpu immediately below so this line is a unnecessary.

Signed-off-by: Simon Horman <horms@verge.net.au>
LKML-Reference: <20091217001542.GD25317@verge.net.au>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 kernel/timer.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/kernel/timer.c b/kernel/timer.c
index 5db5a8d..15533b7 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -656,8 +656,6 @@ __mod_timer(struct timer_list *timer, unsigned long expires,
 
 	debug_activate(timer, expires);
 
-	new_base = __get_cpu_var(tvec_bases);
-
 	cpu = smp_processor_id();
 
 #if defined(CONFIG_NO_HZ) && defined(CONFIG_SMP)
