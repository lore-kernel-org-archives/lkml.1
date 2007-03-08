Return-Path: <linux-kernel-owner+w=401wt.eu-S1030810AbXCHWbj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030810AbXCHWbj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 17:31:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030815AbXCHWbj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 17:31:39 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:47924 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030810AbXCHWbi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 17:31:38 -0500
Date: Thu, 8 Mar 2007 23:30:41 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <ak@suse.de>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Zachary Amsden <zach@vmware.com>,
       tglx@linutronix.de, john stultz <johnstul@us.ibm.com>,
       akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Pratap Subrahmanyam <pratap@vmware.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Daniel Hecht <dhecht@vmware.com>,
       Daniel Arai <arai@vmware.com>, Chris Wright <chrisw@sous-sol.org>
Subject: Re: hardwired VMI crap
Message-ID: <20070308223041.GB30113@elte.hu>
References: <45EF175D.6030609@vmware.com> <45F07D07.5090003@goop.org> <20070308213458.GA24634@elte.hu> <200703082243.31659.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200703082243.31659.ak@suse.de>
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


* Andi Kleen <ak@suse.de> wrote:

> > what we do _NOT_ want is some mixture of 'simplified' and 
> > 'hardwired' native hardware access mixed with hypercalls that 
> > somehow ends up creating a Frankenstein mixture of 'virtual 
> > silicon', is specified nowhere else but in VMWare's proprietary 
> > hypervisor source code that we have no way to fix and no way to even 
> > see!
> 
> Hmm, but we already drive the "vmware silicon" quite successfully with 
> fully virtualized kernels. [...]

that is exactly what i listed as the first variant we want to support:

> >  - native hardware ABIs. If a hypervisor (like KVM) happens to do
> >    its stuff based on those, more power to them - we dont (and 
> >    cannot) care.

the "vmware silicon" you are talking about /is/ the native hardware ABI! 
I never had any problems with /that/.

> [...] And apparently the VMI version is the same, just with some short 
> cuts. Are you just worried about the ->apic_write() hooks or about 
> something else too?

i'm worried about those "shot cuts" (which in essence create software 
variants of silicon), the hooks, the hardwirings combined with the 
hypervisor-side ABIs creating a rigid mess that is harmful to Linux. 
paravirt_ops and the hooks gives a license for all hypervisor 'backends' 
to deviate into random arbitrary directions and to create all their 
separate 'virtual silicon' playgrounds with no regard to Linux 
maintainability. And once this gets released, Linux has no choice but to 
play along.

	Ingo
