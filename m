Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758145Ab0BDMsV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 07:48:21 -0500
Received: from cantor.suse.de ([195.135.220.2]:44181 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756508Ab0BDMsU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 07:48:20 -0500
From: Nikanth Karthikesan <knikanth@suse.de>
Organization: suse.de
To: Tejun Heo <tj@kernel.org>
Subject: [PATCH] define percpu_counter_batch when CONFIG_SMP is not set
Date: Thu, 4 Feb 2010 18:19:22 +0530
User-Agent: KMail/1.12.2 (Linux/2.6.31.8-0.1-desktop; KDE/4.3.1; x86_64; ; )
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
       Suresh Jayaraman <sjayaraman@suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201002041819.22985.knikanth@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

percpu_counter_batch is not defined if CONFIG_SMP is not set.

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>

---

diff --git a/include/linux/percpu_counter.h b/include/linux/percpu_counter.h
index a7684a5..ff57cef 100644
--- a/include/linux/percpu_counter.h
+++ b/include/linux/percpu_counter.h
@@ -83,6 +83,8 @@ struct percpu_counter {
 	s64 count;
 };
 
+#define percpu_counter_batch 2
+
 static inline int percpu_counter_init(struct percpu_counter *fbc, s64 amount)
 {
 	fbc->count = amount;
