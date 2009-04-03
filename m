Return-Path: <linux-kernel-owner+w=401wt.eu-S1755447AbZDCOxx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755447AbZDCOxx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 10:53:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932745AbZDCOqW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 10:46:22 -0400
Received: from mga09.intel.com ([134.134.136.24]:46720 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932793AbZDCOqL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 10:46:11 -0400
Content-Type: multipart/mixed; boundary="===============1460837903=="
MIME-Version: 1.0
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.39,319,1235980800"; 
   d="scan'208";a="503328384"
Message-Id: <20090403144605.206510000@intel.com>
References: <20090403144332.799740000@intel.com>
User-Agent: quilt/0.46-1
Date: Fri, 03 Apr 2009 16:43:50 +0200
From: markus.t.metzger@intel.com
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com
Cc: markus.t.metzger@gmail.com, roland@redhat.com, eranian@googlemail.com,
       oleg@redhat.com, juan.villacis@intel.com, ak@linux.jf.intel.com,
       linux-kernel@vger.kernel.org,
       Markus Metzger <markus.t.metzger@intel.com>
Subject: [patch 18/20] x86, ds: fix bad ds_reset_pebs()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--===============1460837903==
MIME-Version: 1.0
Content-Disposition: inline; filename=tip.master.ds.reset_pebs.patch

Ds_reset_pebs() passed the wrong qualifier to a shared function resulting
in a reset of bts, rather than pebs.


Reported-by: Stephane Eranian <eranian@googlemail.com>
Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
---
 arch/x86/kernel/ds.c |    2 	1 +	1 -	0 !
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/arch/x86/kernel/ds.c
===================================================================
--- a/arch/x86/kernel/ds.c
+++ b/arch/x86/kernel/ds.c
@@ -1186,7 +1186,7 @@ int ds_reset_pebs(struct pebs_tracer *tr
 
 	tracer->trace.ds.top = tracer->trace.ds.begin;
 
-	ds_set(tracer->ds.context->ds, ds_bts, ds_index,
+	ds_set(tracer->ds.context->ds, ds_pebs, ds_index,
 	       (unsigned long)tracer->trace.ds.top);
 
 	return 0;

-- 

--===============1460837903==
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

--===============1460837903==--
