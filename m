Return-Path: <linux-kernel-owner+w=401wt.eu-S933217AbXCFK1Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933217AbXCFK1Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 05:27:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933221AbXCFK1Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 05:27:25 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:33571 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933217AbXCFK1Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 05:27:24 -0500
Date: Tue, 6 Mar 2007 11:26:59 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Gerd Hoffmann <kraxel@suse.de>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       virtualization <virtualization@lists.osdl.org>,
       Jan Beulich <jbeulich@novell.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: Xen & VMI?
Message-ID: <20070306102658.GA7478@elte.hu>
References: <45ECBDDC.8080708@vmware.com> <45ECC076.9050209@goop.org> <45ECC91D.1020809@vmware.com> <45ECC9B6.1060209@goop.org> <20070306081909.GA9331@elte.hu> <45ED2837.3020108@suse.de> <20070306085222.GA17002@elte.hu> <45ED3121.8090308@suse.de> <20070306093436.GA30239@elte.hu> <45ED3F29.6000705@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45ED3F29.6000705@suse.de>
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

> > cleanliness and performance: KVM doesnt need any artificial 
> > indirection.
> 
> Xen doesn't need it either.
> 
> > IMO the GPL-ed ROM portion of VMI was a bad idea to begin with.
> 
> So why do you want xen use vmi then?

due to the other argument i listed:

|| Also, lguest and KVM is Linux-internal, so there's a natural match 
|| between the guest and the host APIs.

It's a basic kernel maintainance issue: lguest/KVM and Linux host and 
guest will co-evolve foward in a natural way as they are in essence 
Linux-internal technologies. They /will/ harmonize. There is no such 
guarantee with Xen/VMWare/etc. (which are distinctly separate 
technologies) - so any ABIs towards them could become (and are already 
becoming) a drag and distraction.

> > well, the VMI patches got into Linux with the claim that it's also 
> > useful for Xen. So that claim was ... not actually true?
> 
> As mentioned there was a proof-of-concept VMI ROM done by vmware.  As 
> far I know it translated the VMI ROM interface calls into xen 
> hypercalls somehow, Zach probably has more details.
> 
> So in the end you would still have two different hypervisor ABI's, the 
> VMI ROM just hides that.

oh, but that way i have cleverly pushed the problem out of Linux and 
into the VMI-ROM's domain ;) Which is all i care about.

really, one of my jobs as a maintainer is to keep crap out of Linux (we 
are capable of adding enough crap ourselves ;-). Having multiple, 
overlapping, technologically redundant ABIs between /software/, embedded 
into the heart of the kernel (paravirt ops nonwithstanding), for 
perpetuity, is one such type of crap. It is in fact the kind of crap i'm 
/most/ worried about, because it sticks forever.

	Ingo
