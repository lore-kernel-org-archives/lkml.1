Return-Path: <linux-kernel-owner+w=401wt.eu-S932102AbZEGJ0s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932102AbZEGJ0s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 05:26:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761506AbZEGJX5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 05:23:57 -0400
Received: from hera.kernel.org ([140.211.167.34]:40485 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761499AbZEGJXz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 05:23:55 -0400
Date: Thu, 7 May 2009 09:23:26 GMT
From: tip-bot for Markus Metzger <markus.t.metzger@intel.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       markus.t.metzger@intel.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       markus.t.metzger@intel.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090403144558.450027000@intel.com>
References: <20090403144558.450027000@intel.com>
Subject: [tip:tracing/core] x86, ds: fix bounds check in ds selftest
Message-ID: <tip-84f201139245c30777ff858e71b8d7e134b8c3ed@git.kernel.org>
Git-Commit-ID: 84f201139245c30777ff858e71b8d7e134b8c3ed
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 07 May 2009 09:23:28 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  84f201139245c30777ff858e71b8d7e134b8c3ed
Gitweb:     http://git.kernel.org/tip/84f201139245c30777ff858e71b8d7e134b8c3ed
Author:     Markus Metzger <markus.t.metzger@intel.com>
AuthorDate: Fri, 3 Apr 2009 16:43:43 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 7 Apr 2009 13:36:24 +0200

x86, ds: fix bounds check in ds selftest

Fix a bad bounds check in the debug store selftest.

Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
Cc: roland@redhat.com
Cc: eranian@googlemail.com
Cc: oleg@redhat.com
Cc: juan.villacis@intel.com
Cc: ak@linux.jf.intel.com
LKML-Reference: <20090403144558.450027000@intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/ds_selftest.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/ds_selftest.c b/arch/x86/kernel/ds_selftest.c
index e1ba510..cccc19a 100644
--- a/arch/x86/kernel/ds_selftest.c
+++ b/arch/x86/kernel/ds_selftest.c
@@ -47,8 +47,13 @@ static int ds_selftest_bts_consistency(const struct bts_trace *trace)
 		printk(KERN_CONT "bad bts buffer setup...");
 		error = -1;
 	}
+	/*
+	 * We allow top in [begin; end], since its not clear when the
+	 * overflow adjustment happens: after the increment or before the
+	 * write.
+	 */
 	if ((trace->ds.top < trace->ds.begin) ||
-	    (trace->ds.end <= trace->ds.top)) {
+	    (trace->ds.end < trace->ds.top)) {
 		printk(KERN_CONT "bts top out of bounds...");
 		error = -1;
 	}
