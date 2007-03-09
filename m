Return-Path: <linux-kernel-owner+w=401wt.eu-S2993147AbXCIVtH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993147AbXCIVtH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 16:49:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993150AbXCIVtH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 16:49:07 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:32894 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993149AbXCIVtF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 16:49:05 -0500
Date: Fri, 9 Mar 2007 22:47:04 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Chris Wright <chrisw@sous-sol.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Zachary Amsden <zach@vmware.com>,
       Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>,
       akpm@linux-foundation.org, LKML <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: ABI coupling to hypervisors via CONFIG_PARAVIRT
Message-ID: <20070309214704.GA20988@elte.hu>
References: <20070309180230.GA17988@elte.hu> <Pine.LNX.4.64.0703091022490.10832@woody.linux-foundation.org> <20070309192420.GA27747@elte.hu> <Pine.LNX.4.64.0703091137340.10832@woody.linux-foundation.org> <20070309210430.GA14905@elte.hu> <20070309212714.GU10574@sequoia.sous-sol.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070309212714.GU10574@sequoia.sous-sol.org>
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


* Chris Wright <chrisw@sous-sol.org> wrote:

> * Ingo Molnar (mingo@elte.hu) wrote:
> > ( if there is no backwards compatibility promise then i have zero
> >   complaints: then paravirt_ops + the hypercall just becomes another API
> >   internal to Linux that we can improve at will. But that is not
> >   realistic: if we provide CONFIG_VMI today, people will expect to have
> >   CONFIG_VMI in the future too. )
> 
> This was the whole reason we didn't adopt VMI directly.  Instead, 
> preferring an kernel internal API, pv_ops, that can adopt naturally as 
> the kernel changes, and it is the pv_ops client code's (or backend as 
> it is also referred to) responsibility to do whatever is necessary to 
> map back to the hypervisor's ABI.  The goal was explicitly to keep 
> things internal fluid as usual.  As I said before, no matter how you 
> slice it there's glue code somewhere to deal with compatibilities. And 
> it's always been the virtualization platform's responsibility to deal 
> with the changes.

For example, for the sake of argument, if the VMI ABI consisted only of 
a single call:

  #define VMI_CALL_NOP           1

then obviously it would be very hard for VMI to adopt to changes in the 
kernel - no matter how many smarts you put into paravirt_ops :-)

agreed? That is the center of my argument. Does the VMI ABI limit the 
Linux kernel or not?

As we increase the complexity of a hypercall ABI, more and more things 
can be implemented via it. So _obviously_ there is a 'minimum level of 
capability' for every hypercall ABI that is /required/ to keep the Linux 
kernel 100% flexible. If in some tricky corner the ABI has some stupid 
limit or assumption, it might stiffle future changes in Linux.

i am worried whether /any/ future change to the upstream kernel's design 
can be adopted via paravirt_ops, via the current VMI ABI. And by /any/ i 
mean truly any. And whether that can be done is not a function of the 
flexibility of paravirt_ops, it's a function of the flexibility of the 
VMI ABI.

	Ingo
