Return-Path: <linux-kernel-owner+w=401wt.eu-S1762585AbXLMG5b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762585AbXLMG5b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 01:57:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760733AbXLMGzk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 01:55:40 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:55004 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760680AbXLMGzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 01:55:39 -0500
Date: Wed, 12 Dec 2007 22:51:15 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Zou Nan hai <nanhai.zou@intel.com>, Ingo Molnar <mingo@elte.hu>
Subject: [patch 05/60] sched: some proc entries are missed in sched_domain
	sys_ctl debug code
Message-ID: <20071213065115.GF6867@kroah.com>
References: <20071213064518.328162328@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="sched-some-proc-entries-are-missed-in-sched_domain-sys_ctl-debug-code.patch"
In-Reply-To: <20071213065039.GA6867@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.23-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Zou Nan hai <nanhai.zou@intel.com>

patch ace8b3d633f93da8535921bf3e3679db3c619578 in mainline.

cache_nice_tries and flags entry do not appear in proc fs sched_domain
directory, because ctl_table entry is skipped.

This patch fixes the issue.

Signed-off-by: Zou Nan hai <nanhai.zou@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/sched.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -5306,7 +5306,7 @@ set_table_entry(struct ctl_table *entry,
 static struct ctl_table *
 sd_alloc_ctl_domain_table(struct sched_domain *sd)
 {
-	struct ctl_table *table = sd_alloc_ctl_entry(14);
+	struct ctl_table *table = sd_alloc_ctl_entry(12);
 
 	set_table_entry(&table[0], "min_interval", &sd->min_interval,
 		sizeof(long), 0644, proc_doulongvec_minmax);
@@ -5326,10 +5326,10 @@ sd_alloc_ctl_domain_table(struct sched_d
 		sizeof(int), 0644, proc_dointvec_minmax);
 	set_table_entry(&table[8], "imbalance_pct", &sd->imbalance_pct,
 		sizeof(int), 0644, proc_dointvec_minmax);
-	set_table_entry(&table[10], "cache_nice_tries",
+	set_table_entry(&table[9], "cache_nice_tries",
 		&sd->cache_nice_tries,
 		sizeof(int), 0644, proc_dointvec_minmax);
-	set_table_entry(&table[12], "flags", &sd->flags,
+	set_table_entry(&table[10], "flags", &sd->flags,
 		sizeof(int), 0644, proc_dointvec_minmax);
 
 	return table;

-- 
