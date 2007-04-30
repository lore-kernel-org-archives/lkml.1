Return-Path: <linux-kernel-owner+w=401wt.eu-S1423319AbXD3Ofg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423319AbXD3Ofg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 10:35:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423317AbXD3Off
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 10:35:35 -0400
Received: from smtp-out.google.com ([216.239.45.13]:45517 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423304AbXD3Oex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 10:34:53 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:message-id:
	mime-version:content-type;
	b=SZz3Aqfh11oYyJ1BRVSFL8NGLEKu7455micjE6blxIOjqQjXvaywMFVRuY5x5rf0E
	9DVYNADtu2pQcYqYj00aw==
Date: Mon, 30 Apr 2007 07:34:37 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Dave Jones <davej@codemonkey.org.uk>
cc: linux-kernel@vger.kernel.org
Subject: [patch] cpufreq: do not declare undefined functions
Message-ID: <Pine.LNX.4.64.0704291657060.1822@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

fill_powernow_table_pstate() and fill_powernow_table_fidvid() are only
defined and used for X86_POWERNOW_K8_ACPI.

Cc: Dave Jones <davej@codemonkey.org.uk>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 arch/i386/kernel/cpu/cpufreq/powernow-k8.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/i386/kernel/cpu/cpufreq/powernow-k8.h b/arch/i386/kernel/cpu/cpufreq/powernow-k8.h
--- a/arch/i386/kernel/cpu/cpufreq/powernow-k8.h
+++ b/arch/i386/kernel/cpu/cpufreq/powernow-k8.h
@@ -215,8 +215,10 @@ static int core_frequency_transition(struct powernow_k8_data *data, u32 reqfid);
 
 static void powernow_k8_acpi_pst_values(struct powernow_k8_data *data, unsigned int index);
 
+#ifdef CONFIG_X86_POWERNOW_K8_ACPI
 static int fill_powernow_table_pstate(struct powernow_k8_data *data, struct cpufreq_frequency_table *powernow_table);
 static int fill_powernow_table_fidvid(struct powernow_k8_data *data, struct cpufreq_frequency_table *powernow_table);
+#endif
 
 #ifdef CONFIG_SMP
 static inline void define_siblings(int cpu, cpumask_t cpu_sharedcore_mask[])
