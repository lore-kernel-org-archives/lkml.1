Return-Path: <linux-kernel-owner+w=401wt.eu-S1756403AbZKCE2w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756403AbZKCE2w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 23:28:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756200AbZKCE2w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 23:28:52 -0500
Received: from ozlabs.org ([203.10.76.45]:39507 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755906AbZKCE2v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 23:28:51 -0500
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
From: Rusty Russell <rusty@rustcorp.com.au>
Message-Id: <200911031458.55187.rusty@rustcorp.com.au>
Date: Tue, 3 Nov 2009 14:58:55 +1030
CC: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 13/14] cpumask: avoid dereferencing struct cpumask
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

struct cpumask will be undefined soon with CONFIG_CPUMASK_OFFSTACK=y,
to avoid them being declared on the stack.

cpumask_bits() does what we want here (of course, this code is crap).

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
To: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/time/timer_list.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/time/timer_list.c b/kernel/time/timer_list.c
--- a/kernel/time/timer_list.c
+++ b/kernel/time/timer_list.c
@@ -232,10 +232,10 @@ static void timer_list_show_tickdevices(
 #ifdef CONFIG_GENERIC_CLOCKEVENTS_BROADCAST
 	print_tickdevice(m, tick_get_broadcast_device(), -1);
 	SEQ_printf(m, "tick_broadcast_mask: %08lx\n",
-		   tick_get_broadcast_mask()->bits[0]);
+		   cpumask_bits(tick_get_broadcast_mask())[0]);
 #ifdef CONFIG_TICK_ONESHOT
 	SEQ_printf(m, "tick_broadcast_oneshot_mask: %08lx\n",
-		   tick_get_broadcast_oneshot_mask()->bits[0]);
+		   cpumask_bits(tick_get_broadcast_oneshot_mask())[0]);
 #endif
 	SEQ_printf(m, "\n");
 #endif

