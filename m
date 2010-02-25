Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758880Ab0BYC6c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 21:58:32 -0500
Received: from mga10.intel.com ([192.55.52.92]:54597 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758840Ab0BYC6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 21:58:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,536,1262592000"; 
   d="scan'208";a="775710407"
Subject: Check the right return variable
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Thu, 25 Feb 2010 11:00:51 +0800
Message-Id: <1267066851.1726.9.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In function dso__split_kallsyms, curr_map saves the return value of
map__new2. So check it instead of var map after the calling returns.

Signed-off-by: Zhang Yanmin <yanmin_zhang@linux.intel.com>

---

diff -Nraup linux-2.6.33/tools/perf/util/symbol.c linux-2.6.33_perf/tools/perf/util/symbol.c
--- linux-2.6.33/tools/perf/util/symbol.c	2010-02-25 02:52:17.000000000 +0800
+++ linux-2.6.33_perf/tools/perf/util/symbol.c	2010-02-25 10:12:33.000000000 +0800
@@ -503,7 +503,7 @@ static int dso__split_kallsyms(struct ds
 				return -1;
 
 			curr_map = map__new2(pos->start, dso, map->type);
-			if (map == NULL) {
+			if (curr_map == NULL) {
 				dso__delete(dso);
 				return -1;
 			}


