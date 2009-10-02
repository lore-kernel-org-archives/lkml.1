Return-Path: <linux-kernel-owner+w=401wt.eu-S1753823AbZJBOCg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753823AbZJBOCg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 10:02:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753683AbZJBOCf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 10:02:35 -0400
Received: from hera.kernel.org ([140.211.167.34]:47852 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753426AbZJBOCe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 10:02:34 -0400
Date: Fri, 2 Oct 2009 14:01:29 GMT
From: tip-bot for Borislav Petkov <borislav.petkov@amd.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       andi@firstfloor.org, torvalds@linux-foundation.org, tglx@linutronix.de,
       borislav.petkov@amd.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       andi@firstfloor.org, torvalds@linux-foundation.org, tglx@linutronix.de,
       borislav.petkov@amd.com, mingo@elte.hu
In-Reply-To: <20091002132321.GC28682@aftab>
References: <20091002132321.GC28682@aftab>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] initcalls: Add early_initcall() for modules
Message-ID: <tip-329bd4119c8a0afea95f9db6d6b402a2f2b40e84@git.kernel.org>
Git-Commit-ID: 329bd4119c8a0afea95f9db6d6b402a2f2b40e84
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 02 Oct 2009 14:01:30 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  329bd4119c8a0afea95f9db6d6b402a2f2b40e84
Gitweb:     http://git.kernel.org/tip/329bd4119c8a0afea95f9db6d6b402a2f2b40e84
Author:     Borislav Petkov <borislav.petkov@amd.com>
AuthorDate: Fri, 2 Oct 2009 15:23:21 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 2 Oct 2009 15:42:19 +0200

initcalls: Add early_initcall() for modules

Complete the early_initcall() API by making it available in modules
too. To be used by the EDAC/MCE code.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>
LKML-Reference: <20091002132321.GC28682@aftab>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 include/linux/init.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/init.h b/include/linux/init.h
index 400adbb..ff8bde5 100644
--- a/include/linux/init.h
+++ b/include/linux/init.h
@@ -271,6 +271,7 @@ void __init parse_early_options(char *cmdline);
 #else /* MODULE */
 
 /* Don't use these in modules, but some people do... */
+#define early_initcall(fn)		module_init(fn)
 #define core_initcall(fn)		module_init(fn)
 #define postcore_initcall(fn)		module_init(fn)
 #define arch_initcall(fn)		module_init(fn)
