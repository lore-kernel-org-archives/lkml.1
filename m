Return-Path: <linux-kernel-owner+w=401wt.eu-S1758026AbYFLJSm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758026AbYFLJSm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 05:18:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752326AbYFLJSe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 05:18:34 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:32892 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751309AbYFLJSe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 05:18:34 -0400
Date: Thu, 12 Jun 2008 11:18:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [tree] ftrace, v16
Message-ID: <20080612091818.GD15312@elte.hu>
References: <20080612075425.GB18419@elte.hu> <20080612075545.GA32585@elte.hu> <20080612083339.GA25565@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080612083339.GA25565@uranus.ravnborg.org>
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


* Sam Ravnborg <sam@ravnborg.org> wrote:

> Hi Ingo
> 
> >       kbuild: create new CFLAGS_REMOVE_(basename).o option
> 
> But no changes to Documentation/kbuild/makefiles.txt
> 
> Documentation must be included for new kbuild features.
> 
> 
> > +ifdef CONFIG_DYNAMIC_FTRACE
> > +CFLAGS_REMOVE_ftrace.o = -pg
> > +endif
> 
> I can see where this comes from as we have:
> 
>     CFLAGS_ftrace.o := -foobar
> 
> But in all cases below I see the pattern:
> 
> ifdef CONFIG_FOO_BAR
> CFLAGS_REMOVE_foobar.o = -pg
> endif
> 
> And it would be nice to get this on one line instead.
> And use a syntax we can somehow remember.
> 
> Today we have:
>     ccflags-y := -foobar
> 
> to add options valid for the whole file.
> So we should then add:
> - possibility to remove an option valid for the whole file
> - add/remove an option for a single file
> 
> The suggested syntax:
> ccflags-remove-y := -foobar
> ccflags-<file.o>-y := -foobar
> ccflags-remove-<file.o>-y := -foobar
> 
> So in the case above for ftrace we would use:
> 
> ccflags-remove-ftrace.o-$(CONFIG_DYNAMIC_FTRACE) := -pg
> 
> Comments?

sounds like a good cleanup to me. Would you be interested in sending 
patches for this?

	Ingo
