Return-Path: <linux-kernel-owner+w=401wt.eu-S933232AbZDJMj0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933232AbZDJMj0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 08:39:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936754AbZDJMit
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 08:38:49 -0400
Received: from hera.kernel.org ([140.211.167.34]:45861 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S938203AbZDJMis (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 08:38:48 -0400
Date: Fri, 10 Apr 2009 12:36:45 GMT
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       akpm@linux-foundation.org, andreas.herrmann3@amd.com,
       mark.langsdorf@amd.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       andreas.herrmann3@amd.com, akpm@linux-foundation.org,
       mark.langsdorf@amd.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090409130729.GH31527@alberich.amd.com>
References: <20090409130729.GH31527@alberich.amd.com>
Subject: [tip:x86/cpu] x86: cacheinfo: correct return value when cache_disable feature is not active
Message-ID: <tip-845d8c761ec763871936c62b837c4a9ea6d0fbdb@git.kernel.org>
Git-Commit-ID: 845d8c761ec763871936c62b837c4a9ea6d0fbdb
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 10 Apr 2009 12:36:47 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  845d8c761ec763871936c62b837c4a9ea6d0fbdb
Gitweb:     http://git.kernel.org/tip/845d8c761ec763871936c62b837c4a9ea6d0fbdb
Author:     Andreas Herrmann <andreas.herrmann3@amd.com>
AuthorDate: Thu, 9 Apr 2009 15:07:29 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 10 Apr 2009 14:21:42 +0200

x86: cacheinfo: correct return value when cache_disable feature is not active

Impact: bug fix

If user writes to "cache_disable" attribute on a CPU that does not support
this feature, the process hangs due to an invalid return value in
store_cache_disable().

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Mark Langsdorf <mark.langsdorf@amd.com>
LKML-Reference: <20090409130729.GH31527@alberich.amd.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/cpu/intel_cacheinfo.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index 7240126..1ab46e0 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -771,7 +771,7 @@ store_cache_disable(struct _cpuid4_info *this_leaf, const char *buf,
 	unsigned int ret, index, val;
 
 	if (!this_leaf->can_disable)
-		return 0;
+		return -EINVAL;
 
 	if (strlen(buf) > 15)
 		return -EINVAL;
