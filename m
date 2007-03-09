Return-Path: <linux-kernel-owner+w=401wt.eu-S1767477AbXCIUN6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767477AbXCIUN6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 15:13:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767479AbXCIUN5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 15:13:57 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:36664 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767477AbXCIUN4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 15:13:56 -0500
Date: Fri, 9 Mar 2007 21:12:57 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Zachary Amsden <zach@vmware.com>,
       Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>,
       akpm@linux-foundation.org, LKML <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>,
       Chris Wright <chrisw@sous-sol.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: ABI coupling to hypervisors via CONFIG_PARAVIRT
Message-ID: <20070309201257.GA5761@elte.hu>
References: <20070309180230.GA17988@elte.hu> <Pine.LNX.4.64.0703091022490.10832@woody.linux-foundation.org> <20070309192420.GA27747@elte.hu> <Pine.LNX.4.64.0703091137340.10832@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0703091137340.10832@woody.linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> Similarly, maybe the VMI ABI doesn't allow for something that the 
> kernel wants to do efficiently. Big deal. What relevance does that 
> have to do with anything, except the fact that if true, the VMWare 
> people are screwed? It's *their* problem.

i wont hold you up for long, but i think this is the key difference, and 
if i understand your point correctly i think you are really wrong here.

This is 'enterprise Linux compatibility and ABI 101', really - i dare to 
bet blindly that you wont see anyone here from distros arguing against 
this simple point.

Once this thing is released upstream, it creates a new compatibility 
rule:

  _new kernel must not break on an older hypervisor_

due to a new paravirt_ops design. Ever. It's really that simple. (I 
think i never said this explicitly because this requirement of backwards 
compatibility was so obvious to me.)

And it doesnt matter whether we think that it was VMWare who messed up. 
Users/customers _will_ blame us: "v2.6.25 regresses, it wont run under 
ESX v1.12 anymore". Distro will yield and will undo whatever change 
breaks backwards compatibility with older hypervisors. (most likely it 
will be undone upstream already) Backwards compatibility acts as a very 
heavy barrier against certain types of paravirt_ops design changes.

Once v2.6.21 is released, and a bigger distro releases a kernel with 
CONFIG_PARAVIRT+CONFIG_VMI enabled: backwards compatibility in future 
versions becomes mainly /that/ distro's problem (and upstream's 
problem), _NOT_ WMware's problem.

That's why i mentioned CONFIG_COMPAT_VDSO as an example. One major 
distro (SuSE 9.0) came out with that particular glibc version that had a 
bug that depended on a particular and totally unintentional ABI detail 
in the vDSO. As a result we had to do several iterations of 
CONFIG_COMPAT_VDSO to keep backwards compatibility. And glibc is perhaps 
_the_ most kernel-friendly external software project in existence. 
Still, the ABI dependency was there, and we cannot break users who run 
old userspace. The same rule holds here: we cannot break users who run 
an old hypervisor.

	Ingo
