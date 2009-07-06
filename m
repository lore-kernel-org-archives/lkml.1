Return-Path: <linux-kernel-owner+w=401wt.eu-S1754762AbZGFMDs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762AbZGFMDs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 08:03:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752824AbZGFMDi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 08:03:38 -0400
Received: from ozlabs.org ([203.10.76.45]:48985 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752093AbZGFMDi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 08:03:38 -0400
Date: Mon, 6 Jul 2009 22:01:31 +1000
From: Anton Blanchard <anton@samba.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Roland Dreier <rdreier@cisco.com>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] perf_counter tools: Rename cache events to remove $
Message-ID: <20090706120131.GB4391@kryten>
References: <1245760130.3776.6.camel@localhost.localdomain> <20090623195656.GC8777@elte.hu> <1245876060.3038.7.camel@localhost.localdomain> <20090625093346.GD23547@elte.hu> <1245934522.5308.39.camel@hpdv5.satnam> <ada3a9ol58t.fsf@cisco.com> <20090705002536.GA28060@kryten> <20090705003239.GB28564@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090705003239.GB28564@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The cache events contain '$' which will hit shell variable expansion. To
avoid confusion change this to 'cache', ie L1-d$-loads becomes L1-dcache-loads.

Signed-off-by: Anton Blanchard <anton@samba.org>
---

Index: linux.trees.git/tools/perf/util/parse-events.c
===================================================================
--- linux.trees.git.orig/tools/perf/util/parse-events.c	2009-07-06 21:50:53.000000000 +1000
+++ linux.trees.git/tools/perf/util/parse-events.c	2009-07-06 21:51:12.000000000 +1000
@@ -71,8 +71,8 @@
 #define MAX_ALIASES 8
 
 static char *hw_cache[][MAX_ALIASES] = {
- { "L1-d$",	"l1-d",		"l1d",		"L1-data",		},
- { "L1-i$",	"l1-i",		"l1i",		"L1-instruction",	},
+ { "L1-dcache",	"l1-d",		"l1d",		"L1-data",		},
+ { "L1-icache",	"l1-i",		"l1i",		"L1-instruction",	},
  { "LLC",	"L2"							},
  { "dTLB",	"d-tlb",	"Data-TLB",				},
  { "iTLB",	"i-tlb",	"Instruction-TLB",			},
