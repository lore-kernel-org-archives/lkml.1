Return-Path: <linux-kernel-owner+w=401wt.eu-S1767568AbXCIW0P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767568AbXCIW0P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 17:26:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767569AbXCIW0O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 17:26:14 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:49818 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767568AbXCIW0O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 17:26:14 -0500
Date: Fri, 9 Mar 2007 23:24:35 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Chris Wright <chrisw@sous-sol.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Zachary Amsden <zach@vmware.com>,
       Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>,
       akpm@linux-foundation.org, LKML <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: ABI coupling to hypervisors via CONFIG_PARAVIRT
Message-ID: <20070309222435.GB24341@elte.hu>
References: <20070309180230.GA17988@elte.hu> <Pine.LNX.4.64.0703091022490.10832@woody.linux-foundation.org> <20070309192420.GA27747@elte.hu> <Pine.LNX.4.64.0703091137340.10832@woody.linux-foundation.org> <20070309210430.GA14905@elte.hu> <20070309212714.GU10574@sequoia.sous-sol.org> <20070309214704.GA20988@elte.hu> <20070309221046.GV10574@sequoia.sous-sol.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070309221046.GV10574@sequoia.sous-sol.org>
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
> > i am worried whether /any/ future change to the upstream kernel's design 
> > can be adopted via paravirt_ops, via the current VMI ABI. And by /any/ i 
> > mean truly any. And whether that can be done is not a function of the 
> > flexibility of paravirt_ops, it's a function of the flexibility of the 
> > VMI ABI.
> 
> i'm not really one to argue on behalf of VMI, but i don't think it's 
> as dire make it out. [...]

hey, that's what i thought when i helped do the vDSO, until i got 
slapped with cold reality called "CONFIG_COMPAT_VDSO". I'm a bit more 
careful about ABIs since then =B-)

> [...] the VMI is client code of pv_ops, and as the kernel changes that 
> client code will simply have to adapt.  of course there are 
> theoretical limitations, but let's keep it grounded to practical 
> reality. the whole premise is evolution.  so throw out specific 
> issues, and let's adapt rather than fall deep into theoretical 
> rhetoric.

ok, sure, how about the one i mentioned: long-term i'd like to have a 
paravirt model where the guest does not store /any/ page tables - all 
paging is managed by the hypervisor. The guest has a vma tree, but 
otherwise it does not process pagefaults, has no concept of a pte (if in 
paravirt mode), has no concept of kernel page tables either: there are 
hypercalls to allocate/free guest-kernel memory, etc. This needs some 
(serious) MM surgery but it's doable and it's interesting as well. How 
would you map this to the VMI backend?

	Ingo
