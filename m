Return-Path: <linux-kernel-owner+w=401wt.eu-S1756137AbZA0QEg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756137AbZA0QEg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 11:04:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754835AbZA0QER
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 11:04:17 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:36946 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754668AbZA0QEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 11:04:16 -0500
Subject: Re: [PATCH 1/2 #tj-percpu] x86: fix build breakage on voyage
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Tejun Heo <htejun@gmail.com>, Brian Gerst <brgerst@gmail.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090127155044.GB28209@elte.hu>
References: <20090126103243.GA31307@elte.hu>
	 <1232977445-11815-1-git-send-email-brgerst@gmail.com>
	 <20090126141832.GA31442@elte.hu> <497E6B34.1020508@kernel.org>
	 <497E8778.9060503@gmail.com>
	 <1233032609.3248.78.camel@localhost.localdomain>
	 <497E9B9D.4010102@gmail.com> <20090127113734.GA28249@elte.hu>
	 <1233070302.3231.34.camel@localhost.localdomain>
	 <20090127155044.GB28209@elte.hu>
Content-Type: text/plain
Date: Tue, 27 Jan 2009 16:04:13 +0000
Message-Id: <1233072253.3231.47.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-01-27 at 16:50 +0100, Ingo Molnar wrote:
> * James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> 
> > On Tue, 2009-01-27 at 12:37 +0100, Ingo Molnar wrote:
> > > * Tejun Heo <htejun@gmail.com> wrote:
> > > 
> > > > From: James Bottomley <James.Bottomley@HansenPartnership.com>
> > > > 
> > > > Impact: build fix
> > > > 
> > > > x86_cpu_to_apicid and x86_bios_cpu_apicid aren't defined for voyage. 
> > > > Earlier patch forgot to conditionalize early percpu clearing.  Fix it.
> > > 
> > > > +#ifdef CONFIG_X86_LOCAL_APIC
> > > >  	early_per_cpu_ptr(x86_cpu_to_apicid) = NULL;
> > > >  	early_per_cpu_ptr(x86_bios_cpu_apicid) = NULL;
> > > > +#endif
> > > 
> > > That patch is not acceptable - it is ugly and it adds another set of
> > > #ifdefs to an already complex piece of code.
> > > 
> > > As i explained it to James in recent threads, the clean and acceptable 
> > > solution to this class of problems is to switch Voyager away from that 
> > > fragile subarch code to proper generic x86 code. (just like we did it for 
> > > other subarchitectures)
> > > 
> > > There is nothing in Voyager that justifies special treatment in the area 
> > > of x86 percpu code.
> > > 
> > > This is one of the mails that explains the principles:
> > > 
> > >   http://lkml.indiana.edu/hypermail/linux/kernel/0901.2/00954.html
> > > 
> > > Or - if there's no time/interest in doing that, we can mark Voyager as 
> > > CONFIG_BROKEN.
> > 
> > Have you quite finished?
> 
> What is that supposed to mean?

It's a conventional response implying your rant wasn't factually
connected to the actual problem at hand.  The justification was actually
in the text you cut ... but boils down to you can reproduce it in a non
voyager configuration, so it's not a voyager specific problem.

The actual problem, as I see it, is how (or whether) to get rid of the
nine #if/#ifdefs that clutter setup_percpu.c ... none of which is
voyager specific.

James


