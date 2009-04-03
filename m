Return-Path: <linux-kernel-owner+w=401wt.eu-S933762AbZDCOwf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933762AbZDCOwf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 10:52:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765968AbZDCOqT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 10:46:19 -0400
Received: from mga09.intel.com ([134.134.136.24]:2422 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932672AbZDCOqI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 10:46:08 -0400
Content-Type: multipart/mixed; boundary="===============2093286272=="
MIME-Version: 1.0
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.39,319,1235980800"; 
   d="scan'208";a="503328372"
Message-Id: <20090403144602.191165000@intel.com>
References: <20090403144332.799740000@intel.com>
User-Agent: quilt/0.46-1
Date: Fri, 03 Apr 2009 16:43:47 +0200
From: markus.t.metzger@intel.com
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com
Cc: markus.t.metzger@gmail.com, roland@redhat.com, eranian@googlemail.com,
       oleg@redhat.com, juan.villacis@intel.com, ak@linux.jf.intel.com,
       linux-kernel@vger.kernel.org,
       Markus Metzger <markus.t.metzger@intel.com>
Subject: [patch 15/20] x86, ds: use single debug store cpu configuration
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--===============2093286272==
MIME-Version: 1.0
Content-Disposition: inline; filename=tip.master.ds.single_configuration.patch

Use a single configuration for all cpus.


Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
---
 arch/x86/kernel/ds.c |    7 	5 +	2 -	0 !
 1 file changed, 5 insertions(+), 2 deletions(-)

Index: b/arch/x86/kernel/ds.c
===================================================================
--- a/arch/x86/kernel/ds.c
+++ b/arch/x86/kernel/ds.c
@@ -47,9 +47,8 @@ struct ds_configuration {
 	/* Control bit-masks indexed by enum ds_feature: */
 	unsigned long		ctl[dsf_ctl_max];
 };
-static DEFINE_PER_CPU(struct ds_configuration, ds_cfg_array);
+static struct ds_configuration ds_cfg __read_mostly;
 
-#define ds_cfg per_cpu(ds_cfg_array, smp_processor_id())
 
 /* Maximal size of a DS configuration: */
 #define MAX_SIZEOF_DS		(12 * 8)
@@ -1268,6 +1267,10 @@ ds_configure(const struct ds_configurati
 
 void __cpuinit ds_init_intel(struct cpuinfo_x86 *c)
 {
+	/* Only configure the first cpu. Others are identical. */
+	if (ds_cfg.name)
+		return;
+
 	switch (c->x86) {
 	case 0x6:
 		switch (c->x86_model) {

-- 

--===============2093286272==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

---------------------------------------------------------------------
Intel GmbH
Dornacher Strasse 1
85622 Feldkirchen/Muenchen Germany
Sitz der Gesellschaft: Feldkirchen bei Muenchen
Geschaeftsfuehrer: Douglas Lusk, Peter Gleissner, Hannes Schwaderer
Registergericht: Muenchen HRB 47456 Ust.-IdNr.
VAT Registration No.: DE129385895
Citibank Frankfurt (BLZ 502 109 00) 600119052

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

--===============2093286272==--
