Return-Path: <linux-kernel-owner+w=401wt.eu-S1755569AbZCLLfx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755569AbZCLLfx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 07:35:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753196AbZCLLfn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 07:35:43 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57898 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752114AbZCLLfm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 07:35:42 -0400
Date: Thu, 12 Mar 2009 12:35:20 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jan Beulich <jbeulich@novell.com>
Cc: jeremy.fitzhardinge@citrix.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: Re: [PATCH] x86-64: fix HYPERVISOR_update_descriptor()
Message-ID: <20090312113520.GA8353@elte.hu>
References: <49B8F3D4.76E4.0078.0@novell.com> <20090312105426.GC30204@elte.hu> <49B8FF3E.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49B8FF3E.76E4.0078.0@novell.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Jan Beulich <jbeulich@novell.com> wrote:

> >>> Ingo Molnar <mingo@elte.hu> 12.03.09 11:54 >>>
> >* Jan Beulich <jbeulich@novell.com> wrote:
> >> Signed-off-by: Jan Beulich <jbeulich@novell.com>
> >> Acked-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> >> 
> >> ---
> >>  arch/x86/include/asm/xen/hypercall.h |    2 ++
> >>  1 file changed, 2 insertions(+)
> >> 
> >> --- linux-2.6.29-rc7/arch/x86/include/asm/xen/hypercall.h	2009-03-11 17:52:10.000000000 +0100
> >> +++ 2.6.29-rc7-x86_64-xen-update-descr/arch/x86/include/asm/xen/hypercall.h	2009-02-13 11:41:39.000000000 +0100
> >> @@ -296,6 +296,8 @@ HYPERVISOR_get_debugreg(int reg)
> >>  static inline int
> >>  HYPERVISOR_update_descriptor(u64 ma, u64 desc)
> >>  {
> >> +	if (sizeof(u64) == sizeof(long))
> >> +		return _hypercall2(int, update_descriptor, ma, desc);
> >>  	return _hypercall4(int, update_descriptor, ma, ma>>32, desc, desc>>32);
> >
> >missing changelog and Impact line.
> 
> I'm confused: What point is there to add a textual description 
> that matches the subject? [...]

For example, under what circumstances did you trigger the bug, 
how widely does it affect people, how did you test it. You are 
sending patches very close to the 2.6.29 release, and your 
commit log is non-existent.

Yes, i can figure out what the patch does, but that is not the 
point.

The point is for you to be forthcoming with such information and 
trying to be helpful to the maintenance process, by properly 
describing changes, by describing how you found the bug, how you 
tested the fix, how significant you find the fix, etc.

I.e. try to emit the information you have about this _already_, 
and generously so, instead of hiding it and forcing others to 
recover it. It might be a small work for me to recover it and 
put it into the changelog, but many of your past patches showed 
such a pattern and such overhead mounts up quickly.

> [...] And where is the need for an impact line documented 
> (clearly neither SubmitChecklist no SubmittingPatches have any 
> occurrence of the word impact), i.e. what are the valid values 
> to chose from?

See:

  http://lkml.org/lkml/2008/10/28/67

	Ingo
