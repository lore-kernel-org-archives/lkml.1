Return-Path: <linux-kernel-owner+w=401wt.eu-S1758527AbZD0PpM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758527AbZD0PpM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 11:45:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758100AbZD0PoT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 11:44:19 -0400
Received: from one.firstfloor.org ([213.235.205.2]:54084 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757970AbZD0PoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 11:44:17 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20090427544.130860995@firstfloor.org>
In-Reply-To: <20090427544.130860995@firstfloor.org>
To: oprofile-list@lists.sf.net, robert.richter@amd.com,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [3/3] oprofile: add support for Core i7 and Atom
Message-Id: <20090427154413.2DE2B1D0232@basil.firstfloor.org>
Date: Mon, 27 Apr 2009 17:44:13 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The registers are about the same as other Family 6 CPUs 
so we only need to add detection.

I'm not completely happy with calling Nehalem Core i7 because
there will be undoubtedly other Nehalem based CPUs
in the future with different marketing names, but it's
the best we got for now.

Requires updated oprofile userland for the new event files.

If you don't want to update right now you can also use 
oprofile.force_arch_perfmon=1 (added in the next patch) with 0.9.4

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/x86/oprofile/nmi_int.c |    7 +++++++
 1 file changed, 7 insertions(+)

Index: linux-2.6.30-rc3-ak/arch/x86/oprofile/nmi_int.c
===================================================================
--- linux-2.6.30-rc3-ak.orig/arch/x86/oprofile/nmi_int.c	2009-04-27 13:25:08.000000000 +0200
+++ linux-2.6.30-rc3-ak/arch/x86/oprofile/nmi_int.c	2009-04-27 15:36:22.000000000 +0200
@@ -417,6 +417,13 @@
 	case 15: case 23:
 		*cpu_type = "i386/core_2";
 		break;
+	case 26:
+		arch_perfmon_setup_counters();
+		*cpu_type = "i386/core_i7";
+		break;
+	case 28:
+		*cpu_type = "i386/atom";
+		break;
 	default:
 		/* Unknown */
 		return 0;
