Return-Path: <linux-kernel-owner+w=401wt.eu-S1752534AbYLPFj7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752534AbYLPFj7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 00:39:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751045AbYLPFju
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 00:39:50 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:42929 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751035AbYLPFju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 00:39:50 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: akpm <akpm@linux-foundation.org>
Subject: Re: mmotm 2008-12-15-16-45 uploaded (build errors)
Cc: kosaki.motohiro@jp.fujitsu.com, Randy Dunlap <randy.dunlap@oracle.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20081216131105.DB9A.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <494726DE.6000100@oracle.com> <20081216131105.DB9A.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Message-Id: <20081216143853.DBA3.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Tue, 16 Dec 2008 14:39:46 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > akpm@linux-foundation.org wrote:
> > > The mm-of-the-moment snapshot 2008-12-15-16-45 has been uploaded to
> > > 
> > >    http://userweb.kernel.org/~akpm/mmotm/
> > > 
> > > It contains the following patches against 2.6.28-rc8:
> > 
> > 
> > Summary of build errors:
> > 
> > i386
> > =====
> > build-r7178.out:/local/linsrc/tmp/mmotm-2008-1215-1645/mm/vmscan.c:1397: error: too few arguments to function 'mem_cgroup_inactive_anon_is_low'
> > build-r7178.out:make[2]: *** [mm/vmscan.o] Error 1
> 
> I think my fault.
> I'll investigate soon.

fixing is here.


==========================================================
Applied after: memcg-fix-calclation-of-active_ratio.patch

==
Subject: [mmotm][PATCH] memcg: fix calclation of active_ratio build error fix

fix following build error

	  CC      mm/vmscan.o
	mm/vmscan.c: In function 'inactive_anon_is_low':
	mm/vmscan.c:1397: error: too few arguments to function 'mem_cgroup_inactive_anon_is_low'


Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 include/linux/memcontrol.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/include/linux/memcontrol.h
===================================================================
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -243,7 +243,7 @@ static inline bool mem_cgroup_oom_called
 }
 
 static inline int
-mem_cgroup_inactive_anon_is_low(struct mem_cgroup *memcg, struct zone *zone)
+mem_cgroup_inactive_anon_is_low(struct mem_cgroup *memcg)
 {
 	return 1;
 }



