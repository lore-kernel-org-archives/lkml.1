Return-Path: <linux-kernel-owner+w=401wt.eu-S1758810AbZABRzg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758810AbZABRzg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 12:55:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757423AbZABRz1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 12:55:27 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:57537 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755711AbZABRz0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 12:55:26 -0500
Date: Fri, 2 Jan 2009 18:54:58 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
       rdreier@cisco.com, ian.campbell@citrix.com,
       jeremy.fitzhardinge@citrix.com, deller@gmx.de, rusty@rustcorp.com.au,
       linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org,
       kyle@mcmartin.ca, randolph@tausq.org, sam@ravnborg.org,
       dave@hiauly1.hia.nrc.ca
Subject: [PATCH] Disallow gcc versions 3.{0,1}
Message-ID: <20090102175458.GA29512@elte.hu>
References: <alpine.LFD.2.00.0812310942110.5086@localhost.localdomain> <20081231105425.9ccac21d.akpm@linux-foundation.org> <alpine.LFD.2.00.0812311318420.5086@localhost.localdomain> <20081231.141408.60544902.davem@davemloft.net> <20090102115547.GB3027@elte.hu> <alpine.LFD.2.00.0901020844070.5086@localhost.localdomain> <alpine.LFD.2.00.0901020933370.5086@localhost.localdomain> <20090102174641.GA27287@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090102174641.GA27287@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
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

> > And it all looks more logical too, imho.
> 
> yeah, agreed, much cleaner.
> 
> The gcc3 check for gcc 3.0 and 3.1 can be pushed into gcc3 as well - not 
> sure whether you fixed that. (i fixed it in the patch i just sent - but 
> i didnt notice the gcc5 mess in gcc4.h that you fixed)

ok, i see them now:

 f9d1425: Disallow gcc versions 4.1.{0,1}
 f153b82: Sanitize gcc version header includes

agreed, much cleaner.

One small issue - i think this now allows gcc 3.0 and 3.1 again - which we 
didnt before. Dont we need the patch below - am i missing something?

	Ingo

------------------->
>From 1458f25412a838968e845ec0bc1b18db70cba7cd Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Fri, 2 Jan 2009 18:53:14 +0100
Subject: [PATCH] Disallow gcc versions 3.{0,1}

GCC 3.0 and 3.1 are too old to build a working kernel.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/compiler-gcc3.h |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/include/linux/compiler-gcc3.h b/include/linux/compiler-gcc3.h
index 2befe65..8005eff 100644
--- a/include/linux/compiler-gcc3.h
+++ b/include/linux/compiler-gcc3.h
@@ -2,6 +2,10 @@
 #error "Please don't include <linux/compiler-gcc3.h> directly, include <linux/compiler.h> instead."
 #endif
 
+#if __GNUC_MINOR__ < 2
+# error Sorry, your compiler is too old - please upgrade it.
+#endif
+
 #if __GNUC_MINOR__ >= 3
 # define __used			__attribute__((__used__))
 #else
