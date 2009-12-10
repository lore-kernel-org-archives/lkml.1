Return-Path: <linux-kernel-owner+w=401wt.eu-S1760590AbZLJHWh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760590AbZLJHWh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 02:22:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760579AbZLJHWc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 02:22:32 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:56111 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1760578AbZLJHWb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 02:22:31 -0500
Message-ID: <4B20A1A9.3040104@cn.fujitsu.com>
Date: Thu, 10 Dec 2009 15:22:17 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Pekka Enberg <penberg@cs.helsinki.fi>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] perf tools: Align long options which have no short forms
References: <4B20A195.8030106@cn.fujitsu.com>
In-Reply-To: <4B20A195.8030106@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before:

$ ./perf kmem
...
    -l, --line <num>      show n lines
    --raw-ip              show raw ip instead of symbol

After:

$ ./perf kmem
...
    -l, --line <num>      show n lines
        --raw-ip          show raw ip instead of symbol

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 tools/perf/util/parse-options.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/parse-options.c b/tools/perf/util/parse-options.c
index 6d8af48..efebd5b 100644
--- a/tools/perf/util/parse-options.c
+++ b/tools/perf/util/parse-options.c
@@ -430,6 +430,9 @@ int usage_with_options_internal(const char * const *usagestr,
 		pos = fprintf(stderr, "    ");
 		if (opts->short_name)
 			pos += fprintf(stderr, "-%c", opts->short_name);
+		else
+			pos += fprintf(stderr, "    ");
+
 		if (opts->long_name && opts->short_name)
 			pos += fprintf(stderr, ", ");
 		if (opts->long_name)
-- 
1.6.3
