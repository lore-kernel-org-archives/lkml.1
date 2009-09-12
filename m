Return-Path: <linux-kernel-owner+w=401wt.eu-S1754068AbZILLEc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068AbZILLEc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Sep 2009 07:04:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753826AbZILLEM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Sep 2009 07:04:12 -0400
Received: from casper.infradead.org ([85.118.1.10]:43142 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752697AbZILLEH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Sep 2009 07:04:07 -0400
Date: Sat, 12 Sep 2009 13:04:40 +0200
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: Arjan van de Ven <arjan@infradead.org>, mingo@elte.hu, fweisbec@gmail.com,
       peterz@infradead.org
Subject: [PATCH 3/8] perf: Allow perf utilities to have "callback" options
 without arguments
Message-ID: <20090912130440.548666c1@infradead.org>
In-Reply-To: <20090912130306.5d0086ea@infradead.org>
References: <20090912130306.5d0086ea@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>From b37c714203e12c2104b2fae41c6f4ea4fa589528 Mon Sep 17 00:00:00 2001
From: Arjan van de Ven <arjan@linux.intel.com>
Date: Sat, 12 Sep 2009 07:52:54 +0200
Subject: [PATCH] perf: Allow perf utilities to have "callback" options without arguments

timechart needs to add a "callback" type command line argument that does
not take arguments.

This patch adds the parse-options.h infrastructure to make this possible.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 tools/perf/util/parse-options.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/parse-options.h b/tools/perf/util/parse-options.h
index 8aa3464..2ee248f 100644
--- a/tools/perf/util/parse-options.h
+++ b/tools/perf/util/parse-options.h
@@ -104,6 +104,8 @@ struct option {
 	{ .type = OPTION_CALLBACK, .short_name = (s), .long_name = (l), .value = (v), .argh = "time", .help = (h), .callback = parse_opt_approxidate_cb }
 #define OPT_CALLBACK(s, l, v, a, h, f) \
 	{ .type = OPTION_CALLBACK, .short_name = (s), .long_name = (l), .value = (v), (a), .help = (h), .callback = (f) }
+#define OPT_CALLBACK_NOOPT(s, l, v, a, h, f) \
+	{ .type = OPTION_CALLBACK, .short_name = (s), .long_name = (l), .value = (v), (a), .help = (h), .callback = (f), .flags = PARSE_OPT_NOARG }
 #define OPT_CALLBACK_DEFAULT(s, l, v, a, h, f, d) \
 	{ .type = OPTION_CALLBACK, .short_name = (s), .long_name = (l), .value = (v), (a), .help = (h), .callback = (f), .defval = (intptr_t)d, .flags = PARSE_OPT_LASTARG_DEFAULT }
 
-- 
1.6.0.6



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
