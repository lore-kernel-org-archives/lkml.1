Return-Path: <linux-kernel-owner+w=401wt.eu-S1759335AbYGPJEB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759335AbYGPJEB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 05:04:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755436AbYGPJDu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 05:03:50 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59453 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751754AbYGPJDu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 05:03:50 -0400
Message-ID: <487DB907.7060403@cn.fujitsu.com>
Date: Wed, 16 Jul 2008 17:01:59 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Linux-Kernel <linux-kernel@vger.kernel.org>, Paul Jackson <pj@sgi.com>,
       Paul Menage <menage@google.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: [PATCH] cpusets: fix wrong domain attr updates
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fix wrong domain attr updates, or we will always update the first sched domain
attr.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
Cc: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>

---
 kernel/cpuset.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 459d601..d2cc67d 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -679,7 +679,9 @@ restart:
 				if (apn == b->pn) {
 					cpus_or(*dp, *dp, b->cpus_allowed);
 					b->pn = -1;
-					update_domain_attr(dattr, b);
+					if (dattr)
+						update_domain_attr(dattr
+								   + nslot, b);
 				}
 			}
 			nslot++;
-- 
1.5.4.rc3



