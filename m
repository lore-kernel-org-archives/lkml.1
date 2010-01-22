Return-Path: <linux-kernel-owner+w=401wt.eu-S1755443Ab0AVBxr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755443Ab0AVBxr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 20:53:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752517Ab0AVBxp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 20:53:45 -0500
Received: from mga05.intel.com ([192.55.52.89]:35143 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932156Ab0AVBxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 20:53:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,321,1262592000"; 
   d="scan'208";a="533465484"
Date: Fri, 22 Jan 2010 09:47:50 +0800
From: Yong Wang <yong.y.wang@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
       Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, austin.zhang@intel.com
Subject: [PATCH -tip] perf report: Fix segmentation fault when running with
	'-g none'
Message-ID: <20100122014750.GA4111@ywang-moblin2.bj.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Segmentation fault occurs when running perf report with '-g none':

Starting program: /root/perf report -g none

Program received signal SIGSEGV, Segmentation fault.
0x00000000 in ?? ()
(gdb) bt
#0  0x00000000 in ?? ()
#1  0x0808fbb9 in perf_session__insert_output_hist_entry (
    min_callchain_hits=<value optimized out>, he=<value optimized out>,
    root=<value optimized out>) at util/hist.c:169
#2  perf_session__output_resort (min_callchain_hits=<value optimized out>,
    he=<value optimized out>, root=<value optimized out>) at util/hist.c:204
#3  0x080575e9 in __cmd_report () at builtin-report.c:228
#4  cmd_report () at builtin-report.c:385
#5  0x0804b528 in run_builtin (p=0x8146b88, argc=3, argv=0xbffff818)
    at perf.c:263
#6  0x0804bd0b in handle_internal_command (argv=<value optimized out>,
    argc=<value optimized out>) at perf.c:328
#7  run_argv (argv=<value optimized out>, argc=<value optimized out>)
    at perf.c:372
#8  main (argv=<value optimized out>, argc=<value optimized out>) at perf.c:456

Reported-by: Austin Zhang <austin.zhang@intel.com>
Signed-off-by: Yong Wang <yong.y.wang@intel.com>

---
 tools/perfbuiltin-report.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 4c3d699..cfc655d 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -279,7 +279,7 @@ parse_callchain_opt(const struct option *opt __used, const char *arg,
 
 	else if (!strncmp(tok, "none", strlen(arg))) {
 		callchain_param.mode = CHAIN_NONE;
-		symbol_conf.use_callchain = true;
+		symbol_conf.use_callchain = false;
 
 		return 0;
 	}
