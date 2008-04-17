Return-Path: <linux-kernel-owner+w=401wt.eu-S1754291AbYDQTgK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754291AbYDQTgK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 15:36:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752333AbYDQTfz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 15:35:55 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44110 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750952AbYDQTfy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 15:35:54 -0400
Date: Thu, 17 Apr 2008 21:35:37 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [v2.6.26] what's brewing in x86.git for v2.6.26
Message-ID: <20080417193537.GA6253@elte.hu>
References: <20080416202338.GA6007@elte.hu> <20080417002552.5742ad65.akpm@linux-foundation.org> <20080417083000.GA4935@elte.hu> <20080417014054.ea788f1f.akpm@linux-foundation.org> <20080417090626.GA14383@elte.hu> <20080417021813.04df7912.akpm@linux-foundation.org> <20080417093025.GA17389@elte.hu> <20080417023603.672d1032.akpm@linux-foundation.org> <19f34abd0804171147l4403d49aoeab005105a90392b@mail.gmail.com> <20080417192729.GA3058@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080417192729.GA3058@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> > Actually it doesn't. I attach a patch which gets rid of the page flag, 
> > and we rely instead on the PTE flag for page-trackedness.
> [...]
> > Ingo, will you take this for some additional testing?
> 
> thanks Vegard, i've applied it - looks good to me too.

x86.git randconfig testing found a build bug - fix below.

	Ingo

------------>
Subject: kmemcheck: fix build
From: Ingo Molnar <mingo@elte.hu>
Date: Thu Apr 17 21:20:43 CEST 2008

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/kmemcheck.h |    3 +++
 1 file changed, 3 insertions(+)

Index: linux/include/linux/kmemcheck.h
===================================================================
--- linux.orig/include/linux/kmemcheck.h
+++ linux/include/linux/kmemcheck.h
@@ -1,6 +1,8 @@
 #ifndef LINUX_KMEMCHECK_H
 #define LINUX_KMEMCHECK_H
 
+#include <linux/types.h>
+
 #ifdef CONFIG_KMEMCHECK
 extern int kmemcheck_enabled;
 
@@ -24,6 +26,7 @@ void kmemcheck_mark_uninitialized_pages(
 #ifndef CONFIG_KMEMCHECK
 #define kmemcheck_enabled 0
 static inline void kmemcheck_init(void) { }
+static inline bool kmemcheck_page_is_tracked(struct page *p) { return false; }
 #endif /* CONFIG_KMEMCHECK */
 
 #endif /* LINUX_KMEMCHECK_H */
