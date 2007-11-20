Return-Path: <linux-kernel-owner+w=401wt.eu-S1757440AbXKTFwP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757440AbXKTFwP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 00:52:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755505AbXKTFv7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 00:51:59 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:48496 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753593AbXKTFv6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 00:51:58 -0500
Date: Tue, 20 Nov 2007 06:51:13 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Bastian Blank <bastian@waldi.eu.org>,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       glommer@gmail.com, tglx@linutronix.de, rusty@rustcorp.com.au,
       ak@suse.de, chrisw@sous-sol.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       lguest@ozlabs.org, kvm-devel@lists.sourceforge.net, zach@vmware.com,
       jun.nakajima@intel.com
Subject: Re: [PATCH 7/24] consolidate msr.h
Message-ID: <20071120055113.GC20436@elte.hu>
References: <11946337851964-git-send-email-gcosta@redhat.com> <11946337933104-git-send-email-gcosta@redhat.com> <11946337991750-git-send-email-gcosta@redhat.com> <11946338053158-git-send-email-gcosta@redhat.com> <11946338103068-git-send-email-gcosta@redhat.com> <1194633815833-git-send-email-gcosta@redhat.com> <11946338212915-git-send-email-gcosta@redhat.com> <11946338263902-git-send-email-gcosta@redhat.com> <20071119222151.GA11178@wavehammer.waldi.eu.org> <Pine.LNX.4.58.0711191734270.32296@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0711191734270.32296@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> > On Fri, Nov 09, 2007 at 04:42:48PM -0200, Glauber de Oliveira Costa wrote:
> > > -	wrmsrl(MSR_CSTAR, ia32_cstar_target);
> > > +	wrmsrl(MSR_CSTAR, (u64)ia32_cstar_target);
> >
> > Hmm, why do you add explicit casts? The compiler should convert that
> > correctly on its own.
> >
> > > +static inline void wrmsrl(unsigned int msr, unsigned long long val)
> >
> > Hmm, long long is 64 bit on all x86, but why not use explicit u64 to
> > show that?
> 
> (quick reply)
> 
> With PVOPS on it gives compiler warnings without that explict cast. 
> Without looking at the code, IIRC with non-PVOPS it is a macro 
> directly into asm, so it didn't matter what the cast was. But with 
> PVOPS as a function, it gave compiler warnings.
> 
> Take it out and try compiling it for both i386 and x86_64. One of them 
> gave warnings. But maybe it's not a problem now.

i dont think there's ever any true need (and good cause) to force 
integer type casts like that at the callee site.

	Ingo
