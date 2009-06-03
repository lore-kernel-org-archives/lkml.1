Return-Path: <linux-kernel-owner+w=401wt.eu-S1756537AbZFCXuW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756537AbZFCXuW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 19:50:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751825AbZFCXuL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 19:50:11 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:43096 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751783AbZFCXuL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 19:50:11 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18983.3111.770392.800486@cargo.ozlabs.ibm.com>
Date: Thu, 4 Jun 2009 09:49:59 +1000
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: perf_counter: powerpc: Use new identifier names in powerpc-specific code
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit b23f3325 ("perf_counter: Rename various fields") fixed up
most of the uses of the renamed fields, but missed one instance
of "record_type" in powerpc-specific code which needs to be changed
to "sample_type", and a "PERF_RECORD_ADDR" in the same statement that
needs to be changed to "PERF_SAMPLE_ADDR", causing compilation
errors on powerpc.  This fixes it.

Signed-off-by: Paul Mackerras <paulus@samba.org>
---
 arch/powerpc/kernel/perf_counter.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/kernel/perf_counter.c b/arch/powerpc/kernel/perf_counter.c
index 4cc4ac5..232b00a 100644
--- a/arch/powerpc/kernel/perf_counter.c
+++ b/arch/powerpc/kernel/perf_counter.c
@@ -1002,7 +1002,7 @@ static void record_and_restart(struct perf_counter *counter, long val,
 	 */
 	if (record) {
 		addr = 0;
-		if (counter->attr.record_type & PERF_RECORD_ADDR) {
+		if (counter->attr.sample_type & PERF_SAMPLE_ADDR) {
 			/*
 			 * The user wants a data address recorded.
 			 * If we're not doing instruction sampling,
-- 
1.6.0.4

