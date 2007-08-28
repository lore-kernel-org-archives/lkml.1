Return-Path: <linux-kernel-owner+w=401wt.eu-S1762405AbXH1Vjg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762405AbXH1Vjg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 17:39:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754527AbXH1ViQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 17:38:16 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:64979 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753343AbXH1ViM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 17:38:12 -0400
Message-Id: <20070828213801.391940192@mvista.com>
References: <20070828213748.790253419@mvista.com>
User-Agent: quilt/0.46-1
Date: Tue, 28 Aug 2007 14:37:54 -0700
From: Daniel Walker <dwalker@mvista.com>
To: mingo@elte.hu
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org
Content-Disposition: inline; filename=add-preempt-max-latency-for-all-timing-modes.patch
Subject: [PATCH -rt 6/8] preempt_max_latency in all modes
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This enables the /proc/preempt_max_latency facility for timing modes,
even if event tracing is disabled. Wakeup latency was the only one
that had this feature in the past.

Signed-off-by: Daniel Walker <dwalker@mvista.com>

---
 kernel/sysctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.22/kernel/sysctl.c
===================================================================
--- linux-2.6.22.orig/kernel/sysctl.c
+++ linux-2.6.22/kernel/sysctl.c
@@ -392,7 +392,7 @@ static ctl_table kern_table[] = {
 		.proc_handler	= &proc_dointvec,
 	},
 #endif
-#if defined(CONFIG_WAKEUP_TIMING) || defined(CONFIG_EVENT_TRACE)
+#if defined(CONFIG_CRITICAL_TIMING)
 	{
 		.ctl_name	= CTL_UNNUMBERED,
 		.procname	= "preempt_max_latency",

-- 
