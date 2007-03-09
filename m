Return-Path: <linux-kernel-owner+w=401wt.eu-S1752387AbXCIVg3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752387AbXCIVg3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 16:36:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752637AbXCIVg3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 16:36:29 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:52290 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752387AbXCIVg2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 16:36:28 -0500
Date: Fri, 9 Mar 2007 22:36:07 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Zachary Amsden <zach@vmware.com>,
       Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>,
       akpm@linux-foundation.org, LKML <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>,
       Chris Wright <chrisw@sous-sol.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: ABI coupling to hypervisors via CONFIG_PARAVIRT
Message-ID: <20070309213607.GA16796@elte.hu>
References: <20070309180230.GA17988@elte.hu> <Pine.LNX.4.64.0703091022490.10832@woody.linux-foundation.org> <20070309192420.GA27747@elte.hu> <Pine.LNX.4.64.0703091137340.10832@woody.linux-foundation.org> <20070309201257.GA5761@elte.hu> <Pine.LNX.4.64.0703091305090.10832@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0703091305090.10832@woody.linux-foundation.org>
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

> If we change paravirt_ops to be higher-level ops (as we should), yes, 
> the paravirt->VMI layer needs to be extended to have the 
> "higher->lower" translation. But at no point did we break the 
> hypervisor.

hm. So your point is that VMI is in essence a Turing machine (a 
near-complete one)? No matter what redesign we do on the Linux side, the 
VMI paravirt_ops will always be able to adopt to it? If that is the case 
then my ABI worries would indeed be wrong and i'd owe Zach a big fat 
apology [and more] for my flames ;-)

but what if the transformation is not just a top-down transformation, 
but something more conceptual, introducing something that VMI does not 
cover today, like: 'elimination of the APIC concept from guest mode 
(replacing it with a virtual interrupt controller)', or 'elimination of 
the concept of IRQ vectors from guest mode (virtual irq controller)'. Or 
'elimination of pagetables stored in the guest (all paravirt hooks would 
be vma-based)'?

but ... maybe because VMI is so lowlevel and covers /all/ of x86 today, 
it will always be able to emulate whatever different concept we can come 
up with? Do we really know this absolutely sure?

	Ingo
