Return-Path: <linux-kernel-owner+w=401wt.eu-S933700AbZLFOHb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933700AbZLFOHb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 09:07:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932334AbZLFOHa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 09:07:30 -0500
Received: from one.firstfloor.org ([213.235.205.2]:59668 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932268AbZLFOH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 09:07:29 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <20091206307.542816612@firstfloor.org>
In-Reply-To: <20091206307.542816612@firstfloor.org>
To: a.p.zijlstra@chello.nl, mingo@elte.hu, fweisbec@gmail.com,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [2/2] perf: allow installing as perf-versionnumber
Message-Id: <20091206140731.93F1AB1839@basil.firstfloor.org>
Date: Sun,  6 Dec 2009 15:07:31 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Right now installing a given perf binary as perf-versionnumber doesn't 
work because perf internally tries to dispatch a "versionnumber" command.
Add a special case to not dispatch commands starting with a digit.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 tools/perf/perf.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

Index: linux-2.6.32-ak/tools/perf/perf.c
===================================================================
--- linux-2.6.32-ak.orig/tools/perf/perf.c
+++ linux-2.6.32-ak/tools/perf/perf.c
@@ -441,8 +441,11 @@ int main(int argc, const char **argv)
 	 *
 	 * So we just directly call the internal command handler, and
 	 * die if that one cannot handle it.
+	 *
+ 	 * A special case is a digit option: this might be perf-versionnumber
+	 * Just ignore that.
 	 */
-	if (!prefixcmp(cmd, "perf-")) {
+	if (!prefixcmp(cmd, "perf-") && !isdigit(cmd[5])) {
 		cmd += 5;
 		argv[0] = cmd;
 		handle_internal_command(argc, argv);
