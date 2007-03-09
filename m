Return-Path: <linux-kernel-owner+w=401wt.eu-S2993126AbXCIVFf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993126AbXCIVFf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 16:05:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993130AbXCIVFf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 16:05:35 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:41366 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993126AbXCIVFe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 16:05:34 -0500
Date: Fri, 9 Mar 2007 22:04:30 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Zachary Amsden <zach@vmware.com>,
       Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>,
       akpm@linux-foundation.org, LKML <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>,
       Chris Wright <chrisw@sous-sol.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: ABI coupling to hypervisors via CONFIG_PARAVIRT
Message-ID: <20070309210430.GA14905@elte.hu>
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
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> So please
> 
>  - point out things that are badly done. [...]

the thing badly done is fundamental and it trumps any other small 
technological detail complaint i have, because it affects the 
development and maintainance model: to promise backwards compatibility 
to 4-5 different hypervisors, using separate ABIs for each. /One/ such 
ABI would be complex enough to maintain IMO.

( if there is no backwards compatibility promise then i have zero
  complaints: then paravirt_ops + the hypercall just becomes another API
  internal to Linux that we can improve at will. But that is not
  realistic: if we provide CONFIG_VMI today, people will expect to have
  CONFIG_VMI in the future too. )

as i said in the very, very first email about this topic: /one/ new ABI 
towards hypervisors should be introduced step by step, and via concensus 
across hypervisors. We should treat the hypercall ABI very similar to 
the system call ABI: the system call ABI is largely based on a concensus 
between applications.

[ i think apic_write() granularity is bad too - but that is a small
  technical issue, dwarved by the ABI issues that impact the development
  model IMO. ]

	Ingo
