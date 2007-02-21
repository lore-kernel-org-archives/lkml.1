Return-Path: <linux-kernel-owner+w=401wt.eu-S1161235AbXBUNhu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161235AbXBUNhu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 08:37:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161234AbXBUNht
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 08:37:49 -0500
Received: from hp3.statik.TU-Cottbus.De ([141.43.120.68]:40902 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161235AbXBUNhs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 08:37:48 -0500
Message-ID: <45DC4B28.1000804@s5r6.in-berlin.de>
Date: Wed, 21 Feb 2007 14:37:44 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.0.8) Gecko/20061030 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Adrian Bunk <bunk@stusta.de>, Jan Beulich <jbeulich@novell.com>,
       Andi Kleen <ak@muc.de>, linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       David Moore <dcm@mit.edu>
Subject: Re: [patch 00/21] 2.6.19-stable review
References: <20070221013619.GA30227@kroah.com> <45DC4AE8.7050704@s5r6.in-berlin.de>
In-Reply-To: <45DC4AE8.7050704@s5r6.in-berlin.de>
Content-Type: multipart/mixed;
 boundary="------------010805010309080800050404"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010805010309080800050404
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

I wrote:
> I hope you can extract the patch from this MIME attachment.

Probably not unless I attach it for real.
-- 
Stefan Richter
-=====-=-=== --=- =-=-=
http://arcgraph.de/sr/

--------------010805010309080800050404
Content-Type: text/plain;
 name*0="stable__missing-critical-phys_to_virt-in-lib-swiotlb-c.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="stable__missing-critical-phys_to_virt-in-lib-swiotlb-c.patch"

Subject: [PATCH] Missing critical phys_to_virt in lib/swiotlb.c
From: David Moore <dcm@MIT.EDU>
Date: Sun, 04 Feb 2007 13:39:40 -0500

From: David Moore <dcm@acm.org>

Adds missing call to phys_to_virt() in the
lib/swiotlb.c:swiotlb_sync_sg() function.  Without this change, a kernel
panic will always occur whenever a SWIOTLB bounce buffer from a
scatter-gather list gets synced.

Signed-off-by: David Moore <dcm@acm.org>
Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---

This is a fraction of patch "[IA64] swiotlb bug fixes" in 2.6.20-git#,
commit cde14bbfb3aa79b479db35bd29e6c083513d8614. Unlike its heading
suggests, it is also important for EM64T.

Example crashes caused by swiotlb_sync_sg:
http://lists.opensuse.org/opensuse-bugs/2006-12/msg02943.html
http://qa.mandriva.com/show_bug.cgi?id=28224
http://www.pchdtv.com/forum/viewtopic.php?t=2063&sid=a959a14a4c2db0eebaab7b0df56103ce

--- linux-2.6.19.x86_64/lib/swiotlb.c.orig	2007-02-04 13:18:41.000000000 -0500
+++ linux-2.6.19.x86_64/lib/swiotlb.c	2007-02-04 13:19:43.000000000 -0500
@@ -750,7 +750,7 @@ swiotlb_sync_sg(struct device *hwdev, st
 
 	for (i = 0; i < nelems; i++, sg++)
 		if (sg->dma_address != SG_ENT_PHYS_ADDRESS(sg))
-			sync_single(hwdev, (void *) sg->dma_address,
+			sync_single(hwdev, phys_to_virt(sg->dma_address),
 				    sg->dma_length, dir, target);
 }
 




--------------010805010309080800050404--
