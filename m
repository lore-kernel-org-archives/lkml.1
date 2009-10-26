Return-Path: <linux-kernel-owner+w=401wt.eu-S1754744AbZJZFkE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754744AbZJZFkE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 01:40:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754712AbZJZFkD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 01:40:03 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:57209 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754706AbZJZFkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 01:40:03 -0400
Date: Mon, 26 Oct 2009 14:40:01 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] perf tools: Kill off -Wcast-align
Message-ID: <20091026054000.GA13517@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The present use of -Wcast-align causes the build to blow up on SH due to
generating a "cast increases required alignment of target type" error on
each invocation of list_for_each_entry().

It seems that this was previously reported and killed off in the ia64
support patch, but nothing seems to have happened with that. Presumably
the same problem still remains there, too.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>

---

 tools/perf/Makefile |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 88c51b8..39a84be 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -177,8 +177,7 @@ endif
 # Include saner warnings here, which can catch bugs:
 #
 
-EXTRA_WARNINGS := -Wcast-align
-EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wformat
+EXTRA_WARNINGS := -Wformat
 EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wformat-security
 EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wformat-y2k
 EXTRA_WARNINGS := $(EXTRA_WARNINGS) -Wshadow
