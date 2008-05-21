Return-Path: <linux-kernel-owner+w=401wt.eu-S937255AbYEUVpr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937255AbYEUVpr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 17:45:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759361AbYEUVpc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 17:45:32 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:60573 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756116AbYEUVpb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 17:45:31 -0400
Date: Wed, 21 May 2008 23:46:08 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] Fix Immediate Values x86_64 support old gcc
Message-ID: <20080521214608.GA15136@uranus.ravnborg.org>
References: <482AB6C5.4060604@goop.org> <20080516124811.GC4226@Krystal> <482DFD65.10300@zytor.com> <20080521133122.GA18084@Krystal> <48344239.9070003@zytor.com> <20080521160217.GA26974@Krystal> <20080521170150.GA29428@Krystal> <20080521203743.GA12982@uranus.ravnborg.org> <20080521212809.GE6158@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080521212809.GE6158@Krystal>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2008 at 05:28:09PM -0400, Mathieu Desnoyers wrote:
> * Sam Ravnborg (sam@ravnborg.org) wrote:
> > Hi Mathieu
> > > Does this fix make more sense ?
> > > 
> > > GCC < 4, on x86_64, does not accept symbol+offset operands for "i" constraints
> > > asm statements. Fallback on generic immediate values if this compiler is
> > > detected.
> > > 
> > > Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> > > ---
> > >  arch/x86/Makefile           |    3 +++
> > >  arch/x86/kernel/Makefile    |    4 +++-
> > >  include/asm-x86/immediate.h |    5 +++++
> > >  include/linux/immediate.h   |    4 +++-
> > >  kernel/Makefile             |    4 +++-
> > >  5 files changed, 17 insertions(+), 3 deletions(-)
> > > 
> > > Index: linux-2.6-sched-devel/arch/x86/Makefile
> > > ===================================================================
> > > --- linux-2.6-sched-devel.orig/arch/x86/Makefile	2008-05-21 09:04:52.000000000 -0400
> > > +++ linux-2.6-sched-devel/arch/x86/Makefile	2008-05-21 09:22:05.000000000 -0400
> > > @@ -78,6 +78,9 @@
> > >                  "$(CC)" -fstack-protector-all )
> > >  
> > >          KBUILD_CFLAGS += $(stackp-y)
> > > +
> > > +	export GCC_BROKEN_IMMEDIATE
> > > +	GCC_BROKEN_IMMEDIATE := $(shell if [ $(call cc-version) -lt 0400 ] ; then echo "y"; fi)
> > 
> > So here we introduce a global environment variable that tells
> > us that gcc has "BROKEN_IMMEDIATE".
> > I have absolutely no clue what "BROKEN_IMMEDIATE" is so I guess others
> > are in the same boat. Comment please!
> > 
> 
> Yes, I guess this worth being commented, you are right. I'll write
> something along the lines written in the patch header.
> 
> > Consider something like this (note: no negative logic involved):
> > export USE_IMMEDIATE := $(call cc-ifversion, -ge, 0400, $(CONFIG_IMMEDIATE))
> > 
> 
> Hrm, if I do that, I would have to add USE_IMMEDIATE to each
> architecture's makefiles for which immediate values are supported, e.g.:
> 
> export USE_IMMEDIATE := $(CONFIG_IMMEDIATE)
> 
> The "BROKEN_IMMEDIATE" (negative) approach only needs to be defined on
> x86_64 where gcc 3.x does not support symbol+offset correctly.
Same with USE_IMMEDIATE - as USE_IMMEDIATE is only used in a x86 Makefile.
Or did I miss sothing?

	Sam
