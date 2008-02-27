Return-Path: <linux-kernel-owner+w=401wt.eu-S1762474AbYB0Hlr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762474AbYB0Hlr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 02:41:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750964AbYB0Hlj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 02:41:39 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:49655 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750919AbYB0Hli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 02:41:38 -0500
Date: Wed, 27 Feb 2008 01:41:35 -0600
From: Paul Jackson <pj@sgi.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Paul Menage <menage@google.com>
Subject: Re: [PATCH] cpuset: fix return value of cpuset_populate()
Message-Id: <20080227014135.0c361ab3.pj@sgi.com>
In-Reply-To: <47C5131A.80508@cn.fujitsu.com>
References: <47C5131A.80508@cn.fujitsu.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Resending a patch that Li Zefan just sent, adding the other Paul (Menage)
 to the CC list.  -pj]

- no need to check err == 0
- the last return value of cgroup_add_file() is ignored

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/cpuset.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 3e296ed..1c5b2d2 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -1482,10 +1482,10 @@ static int cpuset_populate(struct cgroup_subsys *ss, struct cgroup *cont)
 	if ((err = cgroup_add_file(cont, ss, &cft_spread_slab)) < 0)
 		return err;
 	/* memory_pressure_enabled is in root cpuset only */
-	if (err == 0 && !cont->parent)
+	if (!cont->parent)
 		err = cgroup_add_file(cont, ss,
 					 &cft_memory_pressure_enabled);
-	return 0;
+	return err;
 }
 
 /*
-- 
1.5.4.rc3


-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
