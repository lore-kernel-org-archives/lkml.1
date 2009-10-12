Return-Path: <linux-kernel-owner+w=401wt.eu-S932486AbZJLPBW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932486AbZJLPBW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 11:01:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932458AbZJLPBV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 11:01:21 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47696 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932133AbZJLPBT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 11:01:19 -0400
Date: Mon, 12 Oct 2009 17:00:37 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Greg KH <gregkh@suse.de>, Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [origin tree build failure] [PATCH] Revert "USB: musb: make
	HAVE_CLK support optional"
Message-ID: <20091012150037.GA14004@elte.hu>
References: <alpine.LFD.2.01.0910111446410.3438@localhost.localdomain> <20091012074221.GA19198@elte.hu> <8bd0f97a0910120605q17a586dag29cf4ab6d89dd29d@mail.gmail.com> <20091012142940.GB1114@suse.de> <8bd0f97a0910120739k3122bctb46713881eaef9ca@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8bd0f97a0910120739k3122bctb46713881eaef9ca@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Frysinger <vapier.adi@gmail.com> wrote:

> On Mon, Oct 12, 2009 at 10:29, Greg KH wrote:
> > On Mon, Oct 12, 2009 at 09:05:57AM -0400, Mike Frysinger wrote:
> >> On Mon, Oct 12, 2009 at 03:42, Ingo Molnar wrote:
> >> >
> >> > * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> >> >
> >> >> As usual, please test this for regressions, both new and old.
> >> >
> >> >>       USB: musb: make HAVE_CLK support optional
> >> >
> >> > This USB/Blackfin commit broke the x86 build with these config options:
> >> >
> >> >  CONFIG_USB_MUSB_HDRC=y
> >> >  CONFIG_USB_MUSB_HOST=y
> >> >  # CONFIG_USB_MUSB_PERIPHERAL is not set
> >> >  # CONFIG_USB_MUSB_OTG is not set
> >> >  # CONFIG_USB_GADGET_MUSB_HDRC is not set
> >> >  CONFIG_USB_MUSB_HDRC_HCD=y
> >> >  CONFIG_MUSB_PIO_ONLY=y
> >> >  CONFIG_USB_MUSB_DEBUG=y
> >> >
> >> > Because a side-effect of the patch was that it enabled the driver on x86
> >> > too which doesnt have HAVE_CLK. So this formerly embedded-only driver
> >> > got exposed on the more widely tested x86 platform.
> >>
> >> this is dumb.  you're addressing unrealistic scenarios (randconfig) by
> >> reverting code for realistic scenarios.  how about updating the
> >> already present arch depend string instead.
> >
> > We want 'randconfig' to work, so this is not unrealistic.  Have you not
> > seen Randy Dunlap's zillion patches to get this to all work properly
> > over the past months?
> 
> i'm not suggesting it not be fixed, i'm suggested it be *fixed*
> instead of blindly reverted.

Sure, i'd agree with that if we were in the merge window. The thing is, 
-rc4 is not the time to do patches that need fixes. It is to fix 
regressions. I dont think this commit applies as a regression fix, does 
it? It _introduces_ a regression.

So a revert is a proper first-level response to this and i fail to 
understand your surprise about that. A fix is nice too, of course, if 
it's simple enough.

	Ingo
