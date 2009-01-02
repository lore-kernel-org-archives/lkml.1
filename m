Return-Path: <linux-kernel-owner+w=401wt.eu-S1757314AbZABId7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757314AbZABId7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 03:33:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751756AbZABIdt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 03:33:49 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:18320 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141AbZABIds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 03:33:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:user-agent:date:from:to:cc:subject:content-disposition
         :message-id;
        b=BsWlFxmugbN+h9GqUdR25y8BZPQN+LrkRr+jeO6AWrH/ZISzTjUysOkczs3FsJzNrU
         qsBGnORA6+EyxlPoYIEBLA2SBhZOBSGvjnjFFWAW9j1zUC4AiW+MRJ16lA6iH4Mw5557
         WB/rQGF7Q+OPtXG6D2Tz2KJBz3vRZ+f1hybUc=
References: <20090102082717.810810508@gmail.com>>
User-Agent: quilt/0.46-1
Date: Fri, 02 Jan 2009 11:27:19 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: mingo@elte.hu, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de
Cc: gorcunov@gmail.com, Cyrill Gorcunov <gorcunov@openvz.org>,
       William Irwin <wli@holomorphy.com>
Subject: [patch 2/3] mm: hugetlb -- get rid of redundant if operation
Content-Disposition: inline; filename=mm-hugetlb
Message-ID: <495dd169.0405560a.0ebf.ffff938c@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At this point we already know that 'addr' is not NULL
so get rid of redundant 'if'. Probably gcc eliminate it
by optimization pass.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
CC: William Irwin <wli@holomorphy.com>
---
 mm/hugetlb.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

Index: linux-2.6.git/mm/hugetlb.c
===================================================================
--- linux-2.6.git.orig/mm/hugetlb.c
+++ linux-2.6.git/mm/hugetlb.c
@@ -991,8 +991,7 @@ __attribute__((weak)) int alloc_bootmem_
 			 * puts them into the mem_map).
 			 */
 			m = addr;
-			if (m)
-				goto found;
+			goto found;
 		}
 		hstate_next_node(h);
 		nr_nodes--;

-- 
