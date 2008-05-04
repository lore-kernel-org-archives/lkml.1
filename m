Return-Path: <linux-kernel-owner+w=401wt.eu-S1753962AbYEDHaM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753962AbYEDHaM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 03:30:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750940AbYEDH36
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 03:29:58 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48074 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750698AbYEDH36 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 03:29:58 -0400
Date: Sun, 4 May 2008 09:29:43 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch] sysfs: build fix
Message-ID: <20080504072943.GA13168@elte.hu>
References: <alpine.LFD.1.10.0805031205330.2971@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0805031205330.2971@woody.linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


x86.git testing found the following build failure on v2.6.26-rc1:

  In file included from include/linux/kobject.h:22,
                   from include/linux/module.h:17,
                   from include/linux/crypto.h:22,
                   from arch/x86/kernel/asm-offsets_32.c:8,
                   from arch/x86/kernel/asm-offsets.c:3:
  include/linux/sysfs.h:201: error: redefinition of 'sysfs_update_group'
  include/linux/sysfs.h:195: error: previous definition of 'sysfs_update_group' was here
  make[1]: *** [arch/x86/kernel/asm-offsets.s] Error 1
  make: *** [prepare0] Error 2

with the following config:

    http://redhat.com/~mingo/misc/config-Sun_May__4_07_09_30_CEST_2008.bad

the reason for the build failure is the duplicate definition of the 
sysfs_update_group() inline function in include/linux/sysfs.h.

The duplication was a merge error: it was added via -mm by commit 
v2.6.25-7262-g2850699, "sysfs: sysfs_update_group stub for 
CONFIG_SYSFS=n" a day before v2.6.26-rc1, but a day before that the same 
commit was already merged upstream via the sysfs tree, with commit 
v2.6.25-7211-g1cbfb7a.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/sysfs.h |    6 ------
 1 file changed, 6 deletions(-)

Index: linux/include/linux/sysfs.h
===================================================================
--- linux.orig/include/linux/sysfs.h
+++ linux/include/linux/sysfs.h
@@ -196,12 +196,6 @@ static inline int sysfs_update_group(str
 	return 0;
 }
 
-static inline int sysfs_update_group(struct kobject *kobj,
-				const struct attribute_group *grp)
-{
-	return 0;
-}
-
 static inline void sysfs_remove_group(struct kobject *kobj,
 				      const struct attribute_group *grp)
 {
