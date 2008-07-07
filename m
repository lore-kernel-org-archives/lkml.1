Return-Path: <linux-kernel-owner+w=401wt.eu-S1756687AbYGGT1V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756687AbYGGT1V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 15:27:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754724AbYGGT1N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 15:27:13 -0400
Received: from 166.sub-75-208-119.myvzw.com ([75.208.119.166]:55587 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754706AbYGGT1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 15:27:12 -0400
Message-Id: <20080707190838.607667440@goop.org>
References: <20080707190749.299430659@goop.org>
User-Agent: quilt/0.46-1
Date: Mon, 07 Jul 2008 12:07:52 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Jens Axboe <axboe@kernel.dk>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Lameter <clameter@linux-foundation.org>,
       Petr Tesarik <ptesarik@suse.cz>,
       Virtualization <virtualization@lists.linux-foundation.org>,
       Xen devel <xen-devel@lists.xensource.com>,
       Thomas Friebel <thomas.friebel@amd.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH RFC 3/4] xen: use lock-byte spinlock implementation
Content-Disposition: inline; filename=xen-use-byte-locks.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Switch to using the lock-byte spinlock implementation, to avoid the
worst of the performance hit from ticket locks.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Thomas Friebel <thomas.friebel@amd.com>
---
 arch/x86/xen/smp.c |    1 +
 1 file changed, 1 insertion(+)

===================================================================
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -430,4 +430,5 @@
 {
 	smp_ops = xen_smp_ops;
 	xen_fill_possible_map();
+	paravirt_use_bytelocks();
 }

-- 

