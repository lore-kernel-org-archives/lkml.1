Return-Path: <linux-kernel-owner+w=401wt.eu-S1760813AbYARM0O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760813AbYARM0O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 07:26:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756926AbYARMZ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 07:25:59 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:40370 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752496AbYARMZ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 07:25:58 -0500
Date: Fri, 18 Jan 2008 13:25:40 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Michael Opdenacker <michael-lists@free-electrons.com>
Cc: Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org,
       Linux-tiny@selenic.com, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86: fix unconditional
	arch/x86/kernel/pcspeaker.c?compiling
Message-ID: <20080118122540.GH11044@elte.hu>
References: <200801171643.49301.michael-lists@free-electrons.com> <478F8AEC.1080209@free-electrons.com> <1200590031.5332.19.camel@cinder.waste.org> <200801172315.29976.michael-lists@free-electrons.com> <20080118110252.GA17397@elte.hu> <47909821.1090907@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47909821.1090907@free-electrons.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Michael Opdenacker <michael-lists@free-electrons.com> wrote:

> On 01/18/2008 12:02 PM, Ingo Molnar wrote:
> >
> > why didnt you make this:
> >
> >   obj-$(CONFIG_INPUT_PCSPKR)		+= pcspeaker.o
> >
> > ?
> >   
> Many thanks for your feedback.
> 
> That's what I did first, but if CONFIG_INPUT_PCSPKR=m, 
> arch/x86/kernel/pcspeaker.c gets compiled as a module. While compiling 
> doesn't fail, is this still a valid module? It defines no init and 
> exit functions, and it defines an initcall, which only makes sense at 
> boot time.
> 
> We could make pcspeaker.c depend on another switch, like 
> CONFIG_PCSPEAKER on mips. We could offer the possibility to disable it 
> when CONFIG_EMBEDDED is set.

i'm confused, the .ko definitely exists:

 europe:~> uname -r
 2.6.24-0.123.rc6.fc9

 europe:~> lsmod | grep pcspkr
 pcspkr                  6400  0

ah, this is a different .ko.

perhaps the right solution would be to only build it in if 
CONFIG_PCSPEAKER is "y" or "m". I.e. your original patch?

	Ingo
