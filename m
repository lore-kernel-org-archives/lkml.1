Return-Path: <linux-kernel-owner+w=401wt.eu-S1757554AbYLPOx0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757554AbYLPOx0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 09:53:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755509AbYLPOxQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 09:53:16 -0500
Received: from mga09.intel.com ([134.134.136.24]:29780 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755422AbYLPOxQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 09:53:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.36,231,1228118400"; 
   d="scan'208";a="371331195"
Date: Tue, 16 Dec 2008 15:53:11 +0100
From: Markus Metzger <markus.t.metzger@intel.com>
To: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       hpa@zytor.com
Cc: markus.t.metzger@intel.com, markus.t.metzger@gmail.com, roland@redhat.com,
       eranian@googlemail.com
Subject: [patch 3/3] x86, bts: correctly report invalid bts records
Message-ID: <20081216155311.A30159@sedona.ch.intel.com>
Mime-Version: 1.0
Content-Disposition: inline
User-Agent: Mutt/1.2.5i
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correctly report a cleared BTS record as invalid. Used to be reported
as branch from 0 to 0.


Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
---

Index: ftrace/arch/x86/kernel/ds.c
===================================================================
--- ftrace.orig/arch/x86/kernel/ds.c	2008-12-15 09:29:05.000000000 +0100
+++ ftrace/arch/x86/kernel/ds.c	2008-12-15 11:32:04.000000000 +0100
@@ -484,6 +484,9 @@
 		out->qualifier = bts_branch;
 		out->variant.lbr.from = bts_get(at, bts_from);
 		out->variant.lbr.to   = bts_get(at, bts_to);
+
+		if (!out->variant.lbr.from && !out->variant.lbr.to)
+			out->qualifier = bts_invalid;
 	}
 
 	return ds_cfg.sizeof_rec[ds_bts];
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

