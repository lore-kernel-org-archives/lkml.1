Return-Path: <linux-kernel-owner+w=401wt.eu-S1752793AbYJaKCc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752793AbYJaKCc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 06:02:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751116AbYJaKCX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 06:02:23 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44473 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750846AbYJaKCW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 06:02:22 -0400
Date: Fri, 31 Oct 2008 11:02:01 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>, Roland McGrath <roland@redhat.com>,
       Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>,
       Yinghai Lu <yinghai@kernel.org>
Subject: Re: cpu2000(both float and int) 13% regression with 2.6.28-rc1
Message-ID: <20081031100201.GA17426@elte.hu>
References: <1225175522.1685.57.camel@ymzhang> <20081028080327.GB15734@elte.hu> <20081028202649.GJ30573@linux-os.sc.intel.com> <7E82351C108FA840AB1866AC776AEC46401F518D@orsmsx505.amr.corp.intel.com> <490A5A80.3070203@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <490A5A80.3070203@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

> Pallipadi, Venkatesh wrote:
> > 
> > We figured out that this is not related to signals. But to this mismerge here
> > 
> >>  +#define X86_FEATURE_AMDC1E  (3*32+21) /* AMD C1E detected */
> >> + #define X86_FEATURE_XTOPOLOGY       (3*32+21) /* cpu topology enum extensions */
> > 
> > I had earler sent a patch to fix this.
> > http://marc.info/?l=linux-kernel&m=122341178202930&w=2
> > 
> > But, somehow I don’t see this patch either in Linus's git or in tip.
> > 
> > ingo, hpa: Can you push that patch along.
> > 
> 
> OK, thought it already had been.  I will investigate later tonight.

i've picked it up into x86/urgent - see the commit below.

	Ingo

--------------->
>From 2576c9991758e431b73e374f6019d6e1e12a8d36 Mon Sep 17 00:00:00 2001
From: Venki Pallipadi <venkatesh.pallipadi@intel.com>
Date: Tue, 7 Oct 2008 13:33:12 -0700
Subject: [PATCH] x86: fix AMDC1E and XTOPOLOGY conflict in cpufeature

Impact: fix xsave slowdown regression

Fix two features from conflicting in feature bits.

Fixes this performance regression:

   Subject: cpu2000(both float and int) 13% regression with 2.6.28-rc1
   http://lkml.org/lkml/2008/10/28/36

Reported-by: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Bisected-by: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/cpufeature.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index f73e95d..cfdf8c2 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -91,7 +91,7 @@
 #define X86_FEATURE_11AP	(3*32+19) /* "" Bad local APIC aka 11AP */
 #define X86_FEATURE_NOPL	(3*32+20) /* The NOPL (0F 1F) instructions */
 #define X86_FEATURE_AMDC1E	(3*32+21) /* AMD C1E detected */
-#define X86_FEATURE_XTOPOLOGY	(3*32+21) /* cpu topology enum extensions */
+#define X86_FEATURE_XTOPOLOGY	(3*32+22) /* cpu topology enum extensions */
 
 /* Intel-defined CPU features, CPUID level 0x00000001 (ecx), word 4 */
 #define X86_FEATURE_XMM3	(4*32+ 0) /* "pni" SSE-3 */
