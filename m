Return-Path: <linux-kernel-owner+w=401wt.eu-S1761473AbYFLNYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761473AbYFLNYS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 09:24:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758701AbYFLNYJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 09:24:09 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:52111 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756425AbYFLNYH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 09:24:07 -0400
Date: Thu, 12 Jun 2008 15:24:50 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [tree] ftrace, v16
Message-ID: <20080612132450.GC13702@uranus.ravnborg.org>
References: <20080612075425.GB18419@elte.hu> <20080612075545.GA32585@elte.hu> <20080612083339.GA25565@uranus.ravnborg.org> <20080612091818.GD15312@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080612091818.GD15312@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2008 at 11:18:18AM +0200, Ingo Molnar wrote:
> 
> * Sam Ravnborg <sam@ravnborg.org> wrote:
> 
> > Hi Ingo
> > 
> > >       kbuild: create new CFLAGS_REMOVE_(basename).o option
> > 
> > But no changes to Documentation/kbuild/makefiles.txt
> > 
> > Documentation must be included for new kbuild features.
> > 
> > 
> > > +ifdef CONFIG_DYNAMIC_FTRACE
> > > +CFLAGS_REMOVE_ftrace.o = -pg
> > > +endif
> > 
> > I can see where this comes from as we have:
> > 
> >     CFLAGS_ftrace.o := -foobar
> > 
> > But in all cases below I see the pattern:
> > 
> > ifdef CONFIG_FOO_BAR
> > CFLAGS_REMOVE_foobar.o = -pg
> > endif
> > 
> > And it would be nice to get this on one line instead.
> > And use a syntax we can somehow remember.
> > 
> > Today we have:
> >     ccflags-y := -foobar
> > 
> > to add options valid for the whole file.
> > So we should then add:
> > - possibility to remove an option valid for the whole file
> > - add/remove an option for a single file
> > 
> > The suggested syntax:
> > ccflags-remove-y := -foobar
> > ccflags-<file.o>-y := -foobar
> > ccflags-remove-<file.o>-y := -foobar
> > 
> > So in the case above for ftrace we would use:
> > 
> > ccflags-remove-ftrace.o-$(CONFIG_DYNAMIC_FTRACE) := -pg
> > 
> > Comments?
> 
> sounds like a good cleanup to me. Would you be interested in sending 
> patches for this?

Will do - but need to fix -next breakage first and a few other things.

	Sam
