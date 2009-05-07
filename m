Return-Path: <linux-kernel-owner+w=401wt.eu-S1762129AbZEGJ1O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762129AbZEGJ1O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 05:27:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761219AbZEGJX7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 05:23:59 -0400
Received: from hera.kernel.org ([140.211.167.34]:40489 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761511AbZEGJX5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 05:23:57 -0400
Date: Thu, 7 May 2009 09:23:15 GMT
From: tip-bot for Markus Metzger <markus.t.metzger@intel.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       markus.t.metzger@intel.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       markus.t.metzger@intel.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090403144557.523964000@intel.com>
References: <20090403144557.523964000@intel.com>
Subject: [tip:tracing/core] x86, ds: fix compiler warning
Message-ID: <tip-353afeea24cc51aafc0ff21a72ec740b6f0af50c@git.kernel.org>
Git-Commit-ID: 353afeea24cc51aafc0ff21a72ec740b6f0af50c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 07 May 2009 09:23:17 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  353afeea24cc51aafc0ff21a72ec740b6f0af50c
Gitweb:     http://git.kernel.org/tip/353afeea24cc51aafc0ff21a72ec740b6f0af50c
Author:     Markus Metzger <markus.t.metzger@intel.com>
AuthorDate: Fri, 3 Apr 2009 16:43:42 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 7 Apr 2009 13:36:23 +0200

x86, ds: fix compiler warning

Size_t is defined differently on i386 and x86_64.
Change type to avoid compiler warning.

Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
Cc: roland@redhat.com
Cc: eranian@googlemail.com
Cc: oleg@redhat.com
Cc: juan.villacis@intel.com
Cc: ak@linux.jf.intel.com
LKML-Reference: <20090403144557.523964000@intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/ds_selftest.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/ds_selftest.c b/arch/x86/kernel/ds_selftest.c
index e5a263c..e1ba510 100644
--- a/arch/x86/kernel/ds_selftest.c
+++ b/arch/x86/kernel/ds_selftest.c
@@ -87,7 +87,7 @@ static int ds_selftest_bts_read(struct bts_tracer *tracer,
 	/* Now to the test itself. */
 	for (at = from; (void *)at < to; at += trace->ds.size) {
 		struct bts_struct bts;
-		size_t index;
+		unsigned long index;
 		int error;
 
 		if (((void *)at - trace->ds.begin) % trace->ds.size) {
