Return-Path: <linux-kernel-owner+w=401wt.eu-S933745AbZDCOuZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933745AbZDCOuZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 10:50:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932803AbZDCOqN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 10:46:13 -0400
Received: from mga09.intel.com ([134.134.136.24]:14809 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932482AbZDCOqF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 10:46:05 -0400
Content-Type: multipart/mixed; boundary="===============1150151147=="
MIME-Version: 1.0
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.39,319,1235980800"; 
   d="scan'208";a="503328354"
Message-Id: <20090403144558.450027000@intel.com>
References: <20090403144332.799740000@intel.com>
User-Agent: quilt/0.46-1
Date: Fri, 03 Apr 2009 16:43:43 +0200
From: markus.t.metzger@intel.com
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com
Cc: markus.t.metzger@gmail.com, roland@redhat.com, eranian@googlemail.com,
       oleg@redhat.com, juan.villacis@intel.com, ak@linux.jf.intel.com,
       linux-kernel@vger.kernel.org,
       Markus Metzger <markus.t.metzger@intel.com>
Subject: [patch 11/20] x86, ds: fix bounds check in ds selftest
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--===============1150151147==
MIME-Version: 1.0
Content-Disposition: inline; filename=tip.master.ds_selftest.bounds_check.patch

Fix a bad bounds check in the debug store selftest.


Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
---
 arch/x86/kernel/ds_selftest.c |    7 	6 +	1 -	0 !
 1 file changed, 6 insertions(+), 1 deletion(-)

Index: b/arch/x86/kernel/ds_selftest.c
===================================================================
--- a/arch/x86/kernel/ds_selftest.c
+++ b/arch/x86/kernel/ds_selftest.c
@@ -47,8 +47,13 @@ static int ds_selftest_bts_consistency(c
 		printk(KERN_CONT "bad bts buffer setup...");
 		error = -1;
 	}
+	/*
+	 * We allow top in [begin; end], since its not clear when the
+	 * overflow adjustment happens: after the increment or before the
+	 * write.
+	 */
 	if ((trace->ds.top < trace->ds.begin) ||
-	    (trace->ds.end <= trace->ds.top)) {
+	    (trace->ds.end < trace->ds.top)) {
 		printk(KERN_CONT "bts top out of bounds...");
 		error = -1;
 	}

-- 

--===============1150151147==
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

--===============1150151147==--
