Return-Path: <linux-kernel-owner+w=401wt.eu-S1755744AbYHMLB3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755744AbYHMLB3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 07:01:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752906AbYHMLBV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 07:01:21 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52759 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752865AbYHMLBU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 07:01:20 -0400
Date: Wed, 13 Aug 2008 13:00:50 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "roland@redhat.com" <roland@redhat.com>,
       "drepper@redhat.com" <drepper@redhat.com>,
       "mikpe@it.uu.se" <mikpe@it.uu.se>,
       "chrisw@sous-sol.org" <chrisw@sous-sol.org>,
       "andi@firstfloor.org" <andi@firstfloor.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [patch 0/9] x86, xsave: xsave/xrstor support
Message-ID: <20080813110050.GA7758@elte.hu>
References: <20080729172917.185593000@linux-os.sc.intel.com> <488FA318.3040905@zytor.com> <20080729232951.GB11223@linux-os.sc.intel.com> <488FAB2B.7050405@zytor.com> <20080730100326.GA9683@elte.hu> <20080730182539.GA17140@elte.hu> <20080730234102.GF11223@linux-os.sc.intel.com> <20080731212915.GH2729@elte.hu> <20080731215808.GB8563@linux-os.sc.intel.com> <20080731221744.GG23801@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080731221744.GG23801@elte.hu>
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

> > Anyhow, with watchdog removed, it works just fine. (both xsave and 
> > non-xsave kernels)
> 
> Great, thanks. I've re-integrated tip/x86/xsave into x86/master and 
> have pushed out the result.

FYI, small tip/x86/xsave build fixlet below - user-space exposed 
interfaces need to use __u64 not u64.

	Ingo

-------------->
>From 26d809af6397ce5c37f5c44d89734d19cce1ad25 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Wed, 13 Aug 2008 12:46:26 +0200
Subject: [PATCH] x86: fix xsave build error
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

fix this build failure with certain glibc versions:

In file included from /usr/include/bits/sigcontext.h:28,
                 from /usr/include/signal.h:333,
                 from Documentation/accounting/getdelays.c:24:
/home/mingo/tip/usr/include/asm/sigcontext.h:191: error: expected specifier-qualifier-list before ‘u64’

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/asm-x86/sigcontext.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/asm-x86/sigcontext.h b/include/asm-x86/sigcontext.h
index 899fe2f..ee813f4 100644
--- a/include/asm-x86/sigcontext.h
+++ b/include/asm-x86/sigcontext.h
@@ -264,9 +264,9 @@ struct sigcontext {
 #endif /* !__i386__ */
 
 struct _xsave_hdr {
-	u64 xstate_bv;
-	u64 reserved1[2];
-	u64 reserved2[5];
+	__u64 xstate_bv;
+	__u64 reserved1[2];
+	__u64 reserved2[5];
 };
 
 /*
