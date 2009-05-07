Return-Path: <linux-kernel-owner+w=401wt.eu-S1762588AbZEGJaj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762588AbZEGJaj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 05:30:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761889AbZEGJZ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 05:25:28 -0400
Received: from hera.kernel.org ([140.211.167.34]:45094 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761869AbZEGJZ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 05:25:26 -0400
Date: Thu, 7 May 2009 09:24:43 GMT
From: tip-bot for Markus Metzger <markus.t.metzger@intel.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       eranian@googlemail.com, markus.t.metzger@intel.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       eranian@googlemail.com, markus.t.metzger@intel.com, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <20090403144605.206510000@intel.com>
References: <20090403144605.206510000@intel.com>
Subject: [tip:tracing/core] x86, ds: fix bad ds_reset_pebs()
Message-ID: <tip-608780a9048efa3e85fbc4d8649b26805cc588aa@git.kernel.org>
Git-Commit-ID: 608780a9048efa3e85fbc4d8649b26805cc588aa
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 07 May 2009 09:24:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  608780a9048efa3e85fbc4d8649b26805cc588aa
Gitweb:     http://git.kernel.org/tip/608780a9048efa3e85fbc4d8649b26805cc588aa
Author:     Markus Metzger <markus.t.metzger@intel.com>
AuthorDate: Fri, 3 Apr 2009 16:43:50 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 7 Apr 2009 13:36:34 +0200

x86, ds: fix bad ds_reset_pebs()

Ds_reset_pebs() passed the wrong qualifier to a shared function resulting
in a reset of bts, rather than pebs.

Reported-by: Stephane Eranian <eranian@googlemail.com>
Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
Cc: roland@redhat.com
Cc: eranian@googlemail.com
Cc: oleg@redhat.com
Cc: juan.villacis@intel.com
Cc: ak@linux.jf.intel.com
LKML-Reference: <20090403144605.206510000@intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/ds.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/ds.c b/arch/x86/kernel/ds.c
index cab2832..ebfb0fd 100644
--- a/arch/x86/kernel/ds.c
+++ b/arch/x86/kernel/ds.c
@@ -1186,7 +1186,7 @@ int ds_reset_pebs(struct pebs_tracer *tracer)
 
 	tracer->trace.ds.top = tracer->trace.ds.begin;
 
-	ds_set(tracer->ds.context->ds, ds_bts, ds_index,
+	ds_set(tracer->ds.context->ds, ds_pebs, ds_index,
 	       (unsigned long)tracer->trace.ds.top);
 
 	return 0;
