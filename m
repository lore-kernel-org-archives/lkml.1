Return-Path: <linux-kernel-owner+w=401wt.eu-S1758651AbZGIInz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758651AbZGIInz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 04:43:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756942AbZGIInr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 04:43:47 -0400
Received: from cantor.suse.de ([195.135.220.2]:47527 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755725AbZGIInq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 04:43:46 -0400
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Products GmbH
To: Daniel Mack <daniel@caiaq.de>
Subject: [PATCH] cpufreq: Unbreak build for !SMP: symlinked cpus cannot happen for !SMP
Date: Thu, 9 Jul 2009 10:43:35 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.27.23-0.1-default; KDE/4.1.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>, rjw@sisk.pl,
       mingo@elte.hu, Shaohua Li <shaohua.li@intel.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Dave Young <hidave.darkstar@gmail.com>,
       Rusty Russell <rusty@rustcorp.com.au>, sven.wegener@stealer.net,
       cpufreq@vger.kernel.org, Dave Jones <davej@redhat.com>
References: <1247081067-21964-1-git-send-email-daniel@caiaq.de>
In-Reply-To: <1247081067-21964-1-git-send-email-daniel@caiaq.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907091043.39607.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Or like that:
Either all #ifdef CONFIG_SMP related conditionals to managed cpus
should vanish or all should be covered. This one takes the latter
approach.

---
'managed_policy' is used for the non-smp case in line 941.

Make the symlink code conditional to #ifdef CONFIG_SMP as already
done at other places.

Signed-off-by: Thomas Renninger <trenn@suse.de>

Index: cpufreq/drivers/cpufreq/cpufreq.c
===================================================================
--- cpufreq.orig/drivers/cpufreq/cpufreq.c
+++ cpufreq/drivers/cpufreq/cpufreq.c
@@ -930,6 +930,7 @@ static int cpufreq_add_dev(struct sys_de
 	}
 	spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
 
+#ifdef CONFIG_SMP
 	/* symlink affected CPUs */
 	for_each_cpu(j, policy->cpus) {
 		if (j == cpu)
@@ -947,6 +948,7 @@ static int cpufreq_add_dev(struct sys_de
 			goto err_out_unregister;
 		}
 	}
+#endif
 
 	policy->governor = NULL; /* to assure that the starting sequence is
 				  * run in cpufreq_set_policy */

