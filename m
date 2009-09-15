Return-Path: <linux-kernel-owner+w=401wt.eu-S1758187AbZIOIWA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758187AbZIOIWA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 04:22:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755816AbZIOIVv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 04:21:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19388 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758106AbZIOIVu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 04:21:50 -0400
Date: Tue, 15 Sep 2009 04:17:34 -0400
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>, Tejun Heo <tj@kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Mike Travis <travis@sgi.com>,
       Thomas Gleixner <tglx@linutronix.de>, Amerigo Wang <amwang@redhat.com>,
       Yinghai Lu <yinghai@kernel.org>, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>
Message-Id: <20090915082005.4701.86110.sendpatchset@localhost.localdomain>
Subject: [Patch] x86: export cpu_llc_id for edac drivers
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When I compiled today's Linus tree, I got a link error from
drivers/edac/edac_mce_amd.c:408, it complained about not finding
symbol 'per_cpu__cpu_llc_id'. This is due to we don't export
'cpu_llc_id'.

This patch fixes it.

Signed-off-by: WANG Cong <amwang@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Tejun Heo <tj@kernel.org>
Cc: Mike Travis <travis@sgi.com>

---
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index c36cc14..3241773 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -99,6 +99,7 @@ EXPORT_SYMBOL(smp_num_siblings);
 
 /* Last level cache ID of each logical CPU */
 DEFINE_PER_CPU(u16, cpu_llc_id) = BAD_APICID;
+EXPORT_PER_CPU_SYMBOL(cpu_llc_id);
 
 /* representing HT siblings of each logical CPU */
 DEFINE_PER_CPU(cpumask_var_t, cpu_sibling_map);
