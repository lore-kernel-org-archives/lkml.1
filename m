Return-Path: <linux-kernel-owner+w=401wt.eu-S2992581AbXDDEJz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992581AbXDDEJz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 00:09:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934066AbXDDEBm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 00:01:42 -0400
Received: from ozlabs.org ([203.10.76.45]:49610 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934058AbXDDEBj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 00:01:39 -0400
To: Andrew Morton <akpm@linux-foundation.org>
CC: <linux-arch@vger.kernel.org>, Linux Memory Management <linux-mm@kvack.org>,
       <linux-kernel@vger.kernel.org>
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Wed, 04 Apr 2007 14:01:27 +1000
Subject: [PATCH 2/14] get_unmapped_area handles MAP_FIXED on alpha
In-Reply-To: <1175659285.929428.835270667964.qpush@grosgo>
Message-Id: <20070404040138.19B43DDE3D@ozlabs.org>
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
