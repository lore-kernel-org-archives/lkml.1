Return-Path: <linux-kernel-owner+w=401wt.eu-S1752928AbZGANMl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752928AbZGANMl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 09:12:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751054AbZGANMe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 09:12:34 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33147 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750782AbZGANMe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 09:12:34 -0400
Date: Wed, 1 Jul 2009 15:12:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Paul Mackerras <paulus@samba.org>
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] perf_counter: Add Generalized Hardware FPU
	support for AMD
Message-ID: <20090701131217.GA13524@elte.hu>
References: <1246267985.3185.3.camel@hpdv5.satnam> <20090630101105.GF6942@elte.hu> <1246368049.3026.11.camel@hpdv5.satnam> <20090630224220.GI1241@elte.hu> <19019.22396.776453.297335@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19019.22396.776453.297335@cargo.ozlabs.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul Mackerras <paulus@samba.org> wrote:

> Ingo Molnar writes:
> 
> >         19583739  vec-adds               (   2.01x scaled)
> >         20856051  vec-muls               (   2.01x scaled)
> >         20856051  vec-divs               (   2.01x scaled)
> >      25100224054  vec-idle-cycles        (   1.99x scaled)
> >         12540131  vec-busy-cycles        (   1.99x scaled)
> >         42286702  vec-ops                (   2.01x scaled)
> > 
> > Paulus: would this categorization fit PowerPC too?
> 
> Conceptually that looks nice, but unfortunately we don't have 
> events that correspond to that categorization on any PowerPC with 
> vector hardware (VMX/Altivec).  POWER6 seems to have the most 
> vector events, and they are mostly divided up along the lines of 
> simple / complex / permute / load / store operations, and whether 
> they are integer or floating-point operations.

Here's what we have on x86:

     20177177044  vec-adds                  (scaled from 66.63%)
     34101687027  vec-muls                  (scaled from 66.64%)
      3984060862  vec-divs                  (scaled from 66.71%)
     26349684710  vec-idle-cycles           (scaled from 66.65%)
      9052001905  vec-stall-cycles          (scaled from 66.66%)
     76440734242  vec-ops                   (scaled from 66.71%)

Could at least the idle/busy/stall/total generic stats be filled in 
on powerpc, with a reasonable enough approximation? Those 
utilization metrics are the most important ones when one tries to 
figure out how well utilized the vector units are.

	Ingo
