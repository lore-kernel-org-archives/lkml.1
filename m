Return-Path: <linux-kernel-owner+w=401wt.eu-S933090AbYETT4Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933090AbYETT4Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 15:56:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758608AbYETT4I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 15:56:08 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36259 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757320AbYETT4G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 15:56:06 -0400
Date: Tue, 20 May 2008 21:55:15 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Hugh Dickins <hugh@veritas.com>,
       Theodore Tso <tytso@mit.edu>, Gabriel C <nix.or.die@googlemail.com>,
       Keith Packard <keithp@keithp.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Eric Anholt <eric@anholt.net>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>, airlied@linux.ie,
       "Barnes, Jesse" <jesse.barnes@intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH 0 of 8] x86: use PTE_MASK consistently
Message-ID: <20080520195515.GA18839@elte.hu>
References: <patchbomb.1211268376@localhost> <20080520195147.GA17648@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080520195147.GA17648@elte.hu>
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

> > This series has had some testing in the x86.git tree, and hasn't 
> > shown any problems.  Each patch is more or less absolutely trivial 
> > and the series is very bisectable, to help track down any problems 
> > which might arise (this area has always been a source of subtle 
> > problems).
> 
> yep, this has been problem-free in x86.git and then in -tip, we had a 
> separate x86/ptemask topic for it that we originally intended for 
> v2.6.27, and we dont mind to see it upstream now ;-)

the only delta between the 8 patches you posted here and tip/x86/ptemask 
topic is the comment below - so we are indeed on the safe side.

	Ingo

----------------->
diff --git a/include/asm-x86/pgtable.h b/include/asm-x86/pgtable.h
index 21fed4f..97c271b 100644
--- a/include/asm-x86/pgtable.h
+++ b/include/asm-x86/pgtable.h
@@ -57,6 +57,7 @@
 #define _KERNPG_TABLE	(_PAGE_PRESENT | _PAGE_RW | _PAGE_ACCESSED |	\
 			 _PAGE_DIRTY)
 
+/* Set of bits not changed in pte_modify */
 #define _PAGE_CHG_MASK	(PTE_MASK | _PAGE_PCD | _PAGE_PWT |		\
 			 _PAGE_ACCESSED | _PAGE_DIRTY)
 
