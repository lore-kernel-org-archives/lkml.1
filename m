Return-Path: <linux-kernel-owner+w=401wt.eu-S1765576AbYECRe3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765576AbYECRe3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 13:34:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760162AbYECReX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 13:34:23 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39713 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758366AbYECReW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 13:34:22 -0400
Date: Sat, 3 May 2008 19:34:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: jamal <hadi@cyberus.ca>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Jan Beulich <jbeulich@novell.com>
Subject: Re: i387/FPU init issues...
Message-ID: <20080503173402.GA5292@elte.hu>
References: <1209810775.6972.37.camel@localhost> <alpine.LFD.1.10.0805031650120.6003@apollo.tec.linutronix.de> <1209834123.6972.48.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1209834123.6972.48.camel@localhost>
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


* jamal <hadi@cyberus.ca> wrote:

> > we have:
> > #define P6_NOP3 ".byte 0x0f,0x1f,0x00\n"
> 
> Dang - I feel i should have saved myself all that git bisecting
> and just posted the oops ;->

your bisection was still very useful - it pinpointed the NOPs - the 
assembly code around the NOP changed so a different length NOP was 
patched in => which did not work on your CPU. So thanks for that! The 
fix is already in x86.git (we'll update the commit log).

> > So the alternatives code applies the wrong nop padding for your CPU. 
> > This was probably introduced with commit 
> > 32c464f5d9701db45bc1673288594e664065388e.
> > 
> > Jan, are you sure that P3 knows the P6 NOPs ? AFAICT its P4, but I 
> > have to dig up the manuals.
> > 
> > Jamal, does the following patch solve your problem ?
> 
> Indeed it does - thanks.

great. So this NOP is indeed not generally known to all "P6 and later" 
CPUs. (the PII)

	Ingo
