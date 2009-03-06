Return-Path: <linux-kernel-owner+w=401wt.eu-S1755794AbZCFPQf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755794AbZCFPQf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 10:16:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755226AbZCFPQP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 10:16:15 -0500
Received: from hera.kernel.org ([140.211.167.34]:39355 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755113AbZCFPQO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 10:16:14 -0500
Date: Fri, 6 Mar 2009 15:15:36 GMT
From: Markus Metzger <markus.t.metzger@intel.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       eranian@googlemail.com, markus.t.metzger@intel.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       eranian@googlemail.com, markus.t.metzger@intel.com, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20090305085721.A22550@sedona.ch.intel.com>
References: <20090305085721.A22550@sedona.ch.intel.com>
Subject: [tip:x86/urgent] x86, pebs: correct qualifier passed to ds_write_config() from ds_request_pebs()
Message-ID: <tip-73bf1b62f561fc8ecb00e2810efe4fe769f4933e@git.kernel.org>
Git-Commit-ID: 73bf1b62f561fc8ecb00e2810efe4fe769f4933e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 06 Mar 2009 15:15:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  73bf1b62f561fc8ecb00e2810efe4fe769f4933e
Gitweb:     http://git.kernel.org/tip/73bf1b62f561fc8ecb00e2810efe4fe769f4933e
Author:     "Markus Metzger" <markus.t.metzger@intel.com>
AuthorDate: Thu, 5 Mar 2009 08:57:21 +0100
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 6 Mar 2009 16:13:15 +0100

x86, pebs: correct qualifier passed to ds_write_config() from ds_request_pebs()

ds_write_config() can write the BTS as well as the PEBS part of
the DS config. ds_request_pebs() passes the wrong qualifier, which
results in the wrong configuration to be written.

Reported-by: Stephane Eranian <eranian@googlemail.com>
Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
LKML-Reference: <20090305085721.A22550@sedona.ch.intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/ds.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/ds.c b/arch/x86/kernel/ds.c
index de7cdbd..87b67e3 100644
--- a/arch/x86/kernel/ds.c
+++ b/arch/x86/kernel/ds.c
@@ -729,7 +729,7 @@ struct pebs_tracer *ds_request_pebs(struct task_struct *task,
 
 	spin_unlock_irqrestore(&ds_lock, irq);
 
-	ds_write_config(tracer->ds.context, &tracer->trace.ds, ds_bts);
+	ds_write_config(tracer->ds.context, &tracer->trace.ds, ds_pebs);
 	ds_resume_pebs(tracer);
 
 	return tracer;
