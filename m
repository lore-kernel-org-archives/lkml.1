Return-Path: <linux-kernel-owner+w=401wt.eu-S1752018AbZISRBe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752018AbZISRBe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 13:01:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751620AbZISRBd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 13:01:33 -0400
Received: from hera.kernel.org ([140.211.167.34]:36528 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751596AbZISRBc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 13:01:32 -0400
Date: Sat, 19 Sep 2009 17:01:07 GMT
From: tip-bot for Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, arjan@infradead.org,
       hpa@zytor.com, mingo@redhat.com, arjan@linux.intel.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, arjan@infradead.org,
       paulus@samba.org, linux-kernel@vger.kernel.org, arjan@linux.intel.com,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090919133507.7374ef8b@infradead.org>
References: <20090919133507.7374ef8b@infradead.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perfcounters/core] perf utils: Be consistent about minimum text size in the svghelper
Message-ID: <tip-964a0b3d2b1b1cac1d01e29b635831b3d92a3fdd@git.kernel.org>
Git-Commit-ID: 964a0b3d2b1b1cac1d01e29b635831b3d92a3fdd
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 19 Sep 2009 17:01:07 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  964a0b3d2b1b1cac1d01e29b635831b3d92a3fdd
Gitweb:     http://git.kernel.org/tip/964a0b3d2b1b1cac1d01e29b635831b3d92a3fdd
Author:     Arjan van de Ven <arjan@infradead.org>
AuthorDate: Sat, 19 Sep 2009 13:35:07 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 19 Sep 2009 18:57:52 +0200

perf utils: Be consistent about minimum text size in the svghelper

Be more consistent in the svghelper about the minimum text size
by having a global #define for this.

There needs to be a minimum text size in order to keep the size
of the SVG file within the reach of what current SVG viewers can
cope with.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
Cc: fweisbec@gmail.com
Cc: peterz@infradead.org
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arjan van de Ven <arjan@infradead.org>
LKML-Reference: <20090919133507.7374ef8b@infradead.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 tools/perf/util/svghelper.c |   24 +++++++++++++-----------
 1 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/tools/perf/util/svghelper.c b/tools/perf/util/svghelper.c
index c7a29af..b0fcecd 100644
--- a/tools/perf/util/svghelper.c
+++ b/tools/perf/util/svghelper.c
@@ -27,6 +27,8 @@ static u64 turbo_frequency, max_freq;
 #define SLOT_HEIGHT 25.0
 #define WIDTH 1000.0
 
+#define MIN_TEXT_SIZE 0.001
+
 static u64 total_height;
 static FILE *svgfile;
 
@@ -104,8 +106,8 @@ void svg_sample(int Yslot, int cpu, u64 start, u64 end, const char *type)
 		text_size = text_size/2;
 	if (text_size > 1.25)
 		text_size = 1.25;
-	if (text_size > 0.0001)
-		fprintf(svgfile, "<text transform=\"translate(%1.6f,%1.6f)\" font-size=\"%1.6fpt\">%i</text>\n",
+	if (text_size > MIN_TEXT_SIZE)
+		fprintf(svgfile, "<text transform=\"translate(%1.8f,%1.8f)\" font-size=\"%1.6fpt\">%i</text>\n",
 			time2pixels(start), Yslot *  SLOT_MULT + SLOT_HEIGHT - 1, text_size,  cpu + 1);
 
 }
@@ -146,10 +148,10 @@ void svg_cpu_box(int cpu, u64 __max_freq, u64 __turbo_freq)
 		cpu2y(cpu), SLOT_MULT+SLOT_HEIGHT);
 
 	sprintf(cpu_string, "CPU %i", (int)cpu+1);
-	fprintf(svgfile, "<text transform=\"translate(%4.1f,%4.1f)\">%s</text>\n",
+	fprintf(svgfile, "<text transform=\"translate(%4.8f,%4.8f)\">%s</text>\n",
 		10+time2pixels(first_time), cpu2y(cpu) + SLOT_HEIGHT/2, cpu_string);
 
-	fprintf(svgfile, "<text transform=\"translate(%4.1f,%4.1f)\" font-size=\"1.25pt\">%s</text>\n",
+	fprintf(svgfile, "<text transform=\"translate(%4.8f,%4.8f)\" font-size=\"1.25pt\">%s</text>\n",
 		10+time2pixels(first_time), cpu2y(cpu) + SLOT_MULT + SLOT_HEIGHT - 4, cpu_model());
 }
 
@@ -166,8 +168,8 @@ void svg_process(int cpu, u64 start, u64 end, const char *type, const char *name
 	if (width > 6)
 		width = 6;
 
-	if (width > 0.001)
-		fprintf(svgfile, "<text  transform=\"translate(%4.5f,%4.5f) rotate(90)\" font-size=\"%3.4fpt\">%s</text>\n",
+	if (width > MIN_TEXT_SIZE)
+		fprintf(svgfile, "<text  transform=\"translate(%4.8f,%4.8f) rotate(90)\" font-size=\"%3.4fpt\">%s</text>\n",
 			time2pixels(start), cpu2y(cpu), width, name);
 }
 
@@ -193,8 +195,8 @@ void svg_cstate(int cpu, u64 start, u64 end, int type)
 	if (width > 6)
 		width = 6;
 
-	if (width > 0.05)
-		fprintf(svgfile, "<text  transform=\"translate(%4.5f,%4.5f) rotate(90)\" font-size=\"%3.4fpt\">C%i</text>\n",
+	if (width > MIN_TEXT_SIZE)
+		fprintf(svgfile, "<text  transform=\"translate(%4.8f,%4.8f) rotate(90)\" font-size=\"%3.4fpt\">C%i</text>\n",
 			time2pixels(start), cpu2y(cpu), width, type);
 }
 
@@ -234,7 +236,7 @@ void svg_pstate(int cpu, u64 start, u64 end, u64 freq)
 	height = 1 + cpu2y(cpu) + SLOT_MULT + SLOT_HEIGHT - height;
 	fprintf(svgfile, "<line x1=\"%4.8f\" x2=\"%4.8f\" y1=\"%4.1f\" y2=\"%4.1f\" class=\"pstate\"/>\n",
 		time2pixels(start), time2pixels(end), height, height);
-	fprintf(svgfile, "<text transform=\"translate(%4.1f,%4.1f)\" font-size=\"0.25pt\">%s</text>\n",
+	fprintf(svgfile, "<text transform=\"translate(%4.8f,%4.8f)\" font-size=\"0.25pt\">%s</text>\n",
 		time2pixels(start), height+0.9, HzToHuman(freq));
 
 }
@@ -311,7 +313,7 @@ void svg_text(int Yslot, u64 start, const char *text)
 	if (!svgfile)
 		return;
 
-	fprintf(svgfile, "<text transform=\"translate(%4.1f,%4.1f)\">%s</text>\n",
+	fprintf(svgfile, "<text transform=\"translate(%4.8f,%4.8f)\">%s</text>\n",
 		time2pixels(start), Yslot * SLOT_MULT+SLOT_HEIGHT/2, text);
 }
 
@@ -322,7 +324,7 @@ static void svg_legenda_box(int X, const char *text, const char *style)
 
 	fprintf(svgfile, "<rect x=\"%i\" width=\"%4.8f\" y=\"0\" height=\"%4.1f\" class=\"%s\"/>\n",
 		X, boxsize, boxsize, style);
-	fprintf(svgfile, "<text transform=\"translate(%4.1f, %4.1f)\" font-size=\"%4.4fpt\">%s</text>\n",
+	fprintf(svgfile, "<text transform=\"translate(%4.8f, %4.8f)\" font-size=\"%4.4fpt\">%s</text>\n",
 		X + boxsize + 5, boxsize, 0.8 * boxsize, text);
 }
 
