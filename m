Return-Path: <linux-kernel-owner+w=401wt.eu-S934088AbXCFL75@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934088AbXCFL75 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 06:59:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933244AbXCFL75
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 06:59:57 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:55599 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965893AbXCFL74 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 06:59:56 -0500
Date: Tue, 6 Mar 2007 12:59:37 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Gerd Hoffmann <kraxel@suse.de>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       virtualization <virtualization@lists.osdl.org>,
       Jan Beulich <jbeulich@novell.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: Xen & VMI?
Message-ID: <20070306115937.GA25313@elte.hu>
References: <45ECC91D.1020809@vmware.com> <45ECC9B6.1060209@goop.org> <20070306081909.GA9331@elte.hu> <45ED2837.3020108@suse.de> <20070306085222.GA17002@elte.hu> <45ED3121.8090308@suse.de> <20070306093436.GA30239@elte.hu> <45ED3F29.6000705@suse.de> <20070306102658.GA7478@elte.hu> <45ED4AD8.6020504@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45ED4AD8.6020504@suse.de>
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


* Gerd Hoffmann <kraxel@suse.de> wrote:

> > || Also, lguest and KVM is Linux-internal, so there's a natural 
> > || match between the guest and the host APIs.
> >
> > It's a basic kernel maintainance issue: lguest/KVM and Linux host 
> > and guest will co-evolve foward in a natural way as they are in 
> > essence Linux-internal technologies. They /will/ harmonize.
> 
> Yes for lguest, that is a linux-only ground for play and research and 
> that will most likely not change in near future.

i actually disagree here: lguest is growing up and will inevitably have 
to spend a small amount of its attention on the world beyond the 
playground too - even if Rusty doesnt want that =B-) That will happen 
de-facto the first time a distro ships an lguest-capable kernel, so it's 
unavoidable.

> It is complete bullshit for kvm.  You can run almost anything as guest 
> in kvm, and I certainly wouldn't be surprised if we see other 
> operating systems start using the kvm paravirt interface.

legacy support has to be ensured, but it does not hugely matter in terms 
of the designing our future. What matters is that once we change some 
fundamental aspect of Linux, we can adopt lguest/KVM immediately. With 
'external' hypervisors there is no such compulsory forward motion, and 
my fear is that by giving them ABI interfaces to the innards of the 
Linux guest they will just stick with those ABIs - and worse, drag Linux 
along with them. (because distros will be forced by the legacy 
assumptions to carry those ABIs along.)

> > There is no such guarantee with Xen/VMWare/etc. (which are 
> > distinctly separate technologies) - so any ABIs towards them could 
> > become (and are already becoming) a drag and distraction.
> 
> We'll certainly need some stable ABI for kvm too, so you can mix 
> kernel versions on host and guest.  I really can't see why do you 
> think kvm is special in any way [...]

lguest/KVM is fundamentally special because its future evolution is 
naturally aligned with that of Linux. Sure, legacies will have to be 
taken care of (just like Linux supports old system-calls and even old 
driver APIs in some circumstances), but there is no danger of KVM 
staying in legacy land forever. With Xen and VMWare i see no guarantee 
at all that Linux wont be hindered by their legacies (or by any plain 
diverging approaches) forever.

so for example, if we change some fundamental thing that can be 
implemented via the legacy ABI but only slowly, that's not a problem 
because new-lguest/new-KVM will use the new approach, so there's a 
straightforward technology-based migratory path out of the legacy. But 
if Xen or VMWare were to stick with that legacy ABI forever (for 
whatever reason), we couldnt solve that situation on the Linux side at 
all, via technological measures.

> >> So in the end you would still have two different hypervisor ABI's, 
> >> the VMI ROM just hides that.
> > 
> > oh, but that way i have cleverly pushed the problem out of Linux and 
> > into the VMI-ROM's domain ;) Which is all i care about.
> 
> Fine, so lets move kvm paravirtualitzation into vmi too (proof of 
> concept code by Anthony Liguori exists) and kill one more item on the 
> (linux) QA test matrix?  (just following your arguments, not that I'm 
> confident it would actually help reducing QA effort).

yes - although obviously a KVM Linux guest does not need such an 
interface - but it's a nice proof of concept to integrate other guest 
OSs into KVM.

	Ingo
