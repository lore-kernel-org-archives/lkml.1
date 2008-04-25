Return-Path: <linux-kernel-owner+w=401wt.eu-S1758212AbYDYO4v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758212AbYDYO4v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 10:56:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752120AbYDYO4p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 10:56:45 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36311 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752105AbYDYO4o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 10:56:44 -0400
Date: Fri, 25 Apr 2008 16:55:52 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Jason Baron <jbaron@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Adrian Bunk <bunk@stusta.de>, Andi Kleen <andi@firstfloor.org>,
       Christoph Hellwig <hch@infradead.org>, akpm@osdl.org
Subject: Re: [patch 13/37] Immediate Values - Architecture Independent Code
Message-ID: <20080425145552.GA20351@elte.hu>
References: <20080424150324.802695381@polymtl.ca> <20080424151357.576697846@polymtl.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080424151357.576697846@polymtl.ca>
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


randconfig testing in sched-devel caught a build bug - fixed by the 
patch below.

	Ingo

-------------->
Subject: markers: build fix
From: Ingo Molnar <mingo@elte.hu>
Date: Fri Apr 25 16:36:15 CEST 2008

fix:

 include/linux/module.h:587: error: redefinition of 'module_imv_update'
 include/linux/immediate.h:74: error: previous definition of 'module_imv_update' was here

the prototype was unnecessary.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/immediate.h |    1 -
 1 file changed, 1 deletion(-)

Index: linux/include/linux/immediate.h
===================================================================
--- linux.orig/include/linux/immediate.h
+++ linux/include/linux/immediate.h
@@ -71,7 +71,6 @@ extern void imv_unref(struct __imv *begi
 #define imv_set(name, i)		(name##__imv = (i))
 
 static inline void core_imv_update(void) { }
-static inline void module_imv_update(void) { }
 static inline void imv_unref_core_init(void) { }
 
 #endif
