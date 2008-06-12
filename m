Return-Path: <linux-kernel-owner+w=401wt.eu-S1756670AbYFLIdO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756670AbYFLIdO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 04:33:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752372AbYFLIc6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 04:32:58 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:33116 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752156AbYFLIc5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 04:32:57 -0400
Date: Thu, 12 Jun 2008 10:33:39 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [tree] ftrace, v16
Message-ID: <20080612083339.GA25565@uranus.ravnborg.org>
References: <20080612075425.GB18419@elte.hu> <20080612075545.GA32585@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080612075545.GA32585@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo

>       kbuild: create new CFLAGS_REMOVE_(basename).o option

But no changes to Documentation/kbuild/makefiles.txt

Documentation must be included for new kbuild features.


> +ifdef CONFIG_DYNAMIC_FTRACE
> +CFLAGS_REMOVE_ftrace.o = -pg
> +endif

I can see where this comes from as we have:

    CFLAGS_ftrace.o := -foobar

But in all cases below I see the pattern:

ifdef CONFIG_FOO_BAR
CFLAGS_REMOVE_foobar.o = -pg
endif

And it would be nice to get this on one line instead.
And use a syntax we can somehow remember.

Today we have:
    ccflags-y := -foobar

to add options valid for the whole file.
So we should then add:
- possibility to remove an option valid for the whole file
- add/remove an option for a single file

The suggested syntax:
ccflags-remove-y := -foobar
ccflags-<file.o>-y := -foobar
ccflags-remove-<file.o>-y := -foobar

So in the case above for ftrace we would use:

ccflags-remove-ftrace.o-$(CONFIG_DYNAMIC_FTRACE) := -pg

Comments?

PS. Yes - I saw the patches when they were sent to linux-kbuild
but I just never came around commenting them.

	Sam
