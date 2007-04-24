Return-Path: <linux-kernel-owner+w=401wt.eu-S1161639AbXDXFe0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161639AbXDXFe0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 01:34:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161630AbXDXFdk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 01:33:40 -0400
Received: from ozlabs.org ([203.10.76.45]:35015 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161626AbXDXFdi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 01:33:38 -0400
To: Andrew Morton <akpm@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>,
       Linux Memory Management <linux-mm@kvack.org>
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Tue, 24 Apr 2007 15:33:34 +1000
Subject: [PATCH 2/12] get_unmapped_area handles MAP_FIXED on alpha
In-Reply-To: <1177392813.924664.32930750763.qpush@grosgo>
Message-Id: <20070424053337.49089DDF07@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Handle MAP_FIXED in alpha's arch_get_unmapped_area(), simple case, just
return the address as passed in

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

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
