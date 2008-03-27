Return-Path: <linux-kernel-owner+w=401wt.eu-S1757338AbYC0Icx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757338AbYC0Icx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 04:32:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753110AbYC0Ico
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 04:32:44 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58815 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751824AbYC0Icn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 04:32:43 -0400
Date: Thu, 27 Mar 2008 09:32:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Huang, Ying" <ying.huang@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, andi@firstfloor.org, mingo@redhat.com,
       tglx@linutronix.de, Paul Jackson <pj@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 0/4] x86_64 boot: Add linked listof struct
	setup_data to boot protocol
Message-ID: <20080327083221.GD15626@elte.hu>
References: <1206601743.3067.20.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1206601743.3067.20.camel@caritas-dev.intel.com>
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


* Huang, Ying <ying.huang@intel.com> wrote:

> This patchset adds the linked list of struct setup_data to boot 
> protocol. This is needed by EDD information and some SGI machine with 
> E820 entry number > 128.

what happens with the SGI machine - does it crash (because we overflow 
the e820 array) - or does it boot up with less memory available and we 
get this bootup warning:

    Ooops! Too many entries in the memory map!

?

I guess we should we raise E820MAX from 128 to 256 (patch below), but if 
we do something worse (crash), we should fix that side-effect as well.

> Now, only the x86_64 is supported. The i386 can be supported after 
> early reservation mechanism for x86 is available.

could you try to do that nevertheless? We generally prefer feature 
patches after sensible unification has been done.

	Ingo

-------------->
Subject: x86: more e820
From: Ingo Molnar <mingo@elte.hu>
Date: Thu Mar 27 09:18:44 CET 2008

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/asm-x86/e820.h |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

Index: linux-x86.q/include/asm-x86/e820.h
===================================================================
--- linux-x86.q.orig/include/asm-x86/e820.h
+++ linux-x86.q/include/asm-x86/e820.h
@@ -1,8 +1,9 @@
 #ifndef __ASM_E820_H
 #define __ASM_E820_H
-#define E820MAP	0x2d0		/* our map */
-#define E820MAX	128		/* number of entries in E820MAP */
-#define E820NR	0x1e8		/* # entries in E820MAP */
+
+#define E820MAP		0x2d0		/* our map */
+#define E820MAX		256		/* number of entries in E820MAP */
+#define E820NR		0x1e8		/* # entries in E820MAP */
 
 #define E820_RAM	1
 #define E820_RESERVED	2
