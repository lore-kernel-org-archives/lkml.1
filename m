Return-Path: <linux-kernel-owner+w=401wt.eu-S1761282AbZDIIyw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761282AbZDIIyw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 04:54:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756079AbZDIIyY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 04:54:24 -0400
Received: from casper.infradead.org ([85.118.1.10]:34732 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754882AbZDIIyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 04:54:22 -0400
Message-Id: <20090409085524.601794134@chello.nl>
References: <20090409085342.799915215@chello.nl>
User-Agent: quilt/0.46-1
Date: Thu, 09 Apr 2009 10:53:46 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 4/4] perf_counter: log full path names
Content-Disposition: inline; filename=perf_counter-fix-pathnames.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dentry_path() only provide path-names up to the mount root, which is
unsuited for out purpose, use d_path() instead.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/perf_counter.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/kernel/perf_counter.c
===================================================================
--- linux-2.6.orig/kernel/perf_counter.c
+++ linux-2.6/kernel/perf_counter.c
@@ -2111,7 +2111,7 @@ static void perf_counter_mmap_event(stru
 			name = strncpy(tmp, "//enomem", sizeof(tmp));
 			goto got_name;
 		}
-		name = dentry_path(file->f_dentry, buf, PATH_MAX);
+		name = d_path(&file->f_path, buf, PATH_MAX);
 		if (IS_ERR(name)) {
 			name = strncpy(tmp, "//toolong", sizeof(tmp));
 			goto got_name;

-- 

