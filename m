Return-Path: <linux-kernel-owner+w=401wt.eu-S965790AbXCVGC3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965790AbXCVGC3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 02:02:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965793AbXCVGC2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 02:02:28 -0400
Received: from ozlabs.org ([203.10.76.45]:41767 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965770AbXCVGCE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 02:02:04 -0400
To: Linux Memory Management <linux-mm@kvack.org>
CC: <linux-kernel@vger.kernel.org>
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Thu, 22 Mar 2007 17:00:25 +1100
Subject: [RFC/PATCH 2/15] get_unmapped_area handles MAP_FIXED on alpha
In-Reply-To: <1174543217.531981.572863804039.qpush@grosgo>
Message-Id: <20070322060203.CA35ADDF2F@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---

 arch/alpha/kernel/osf_sys.c |    3 +++
 1 file changed, 3 insertions(+)

Index: linux-cell/arch/alpha/kernel/osf_sys.c
===================================================================
--- linux-cell.orig/arch/alpha/kernel/osf_sys.c	2007-03-22 14:58:33.000000000 +1100
+++ linux-cell/arch/alpha/kernel/osf_sys.c	2007-03-22 14:58:44.000000000 +1100
@@ -1267,6 +1267,9 @@ arch_get_unmapped_area(struct file *filp
 	if (len > limit)
 		return -ENOMEM;
 
+	if (flags & MAP_FIXED)
+		return addr;
+
 	/* First, see if the given suggestion fits.
 
 	   The OSF/1 loader (/sbin/loader) relies on us returning an
