Return-Path: <linux-kernel-owner+w=401wt.eu-S1752418AbZL3GXe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752418AbZL3GXe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 01:23:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752274AbZL3GXd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 01:23:33 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:51390 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752086AbZL3GXd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 01:23:33 -0500
Message-ID: <4B3AF1D7.5040400@cn.fujitsu.com>
Date: Wed, 30 Dec 2009 14:23:19 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 2/4] ksym_tracer: Fix to allow writing newline to ksym_trace_filter
References: <4B3AF19E.1010201@cn.fujitsu.com>
In-Reply-To: <4B3AF19E.1010201@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It used to work, but now doesn't:

 # echo > ksym_filter
 bash: echo: write error: Invalid argument

It's caused by d954fbf0ff6b5fdfb32350e85a2f15d3db976506
("tracing: Fix wrong usage of strstrip in trace_ksyms").

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/trace/trace_ksym.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_ksym.c b/kernel/trace/trace_ksym.c
index 340b6ff..160a8d8 100644
--- a/kernel/trace/trace_ksym.c
+++ b/kernel/trace/trace_ksym.c
@@ -299,8 +299,8 @@ static ssize_t ksym_trace_filter_write(struct file *file,
 	 * 2: echo 0 > ksym_trace_filter
 	 * 3: echo "*:---" > ksym_trace_filter
 	 */
-	if (!buf[0] || !strcmp(buf, "0") ||
-	    !strcmp(buf, "*:---")) {
+	if (!input_string[0] || !strcmp(input_string, "0") ||
+	    !strcmp(input_string, "*:---")) {
 		__ksym_trace_reset();
 		ret = 0;
 		goto out;
-- 
1.6.3

