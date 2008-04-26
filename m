Return-Path: <linux-kernel-owner+w=401wt.eu-S1760657AbYDZRe1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760657AbYDZRe1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 13:34:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751501AbYDZReS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 13:34:18 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:60961 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751493AbYDZReS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 13:34:18 -0400
Date: Sat, 26 Apr 2008 19:34:50 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Alexander van Heukelum <heukelum@mailshack.com>
Subject: Re: [git pull] generic bitops, take 2
Message-ID: <20080426173450.GB29451@uranus.ravnborg.org>
References: <20080424215739.GA32378@elte.hu> <alpine.LFD.1.10.0804241510420.2779@woody.linux-foundation.org> <20080426151516.GA27894@elte.hu> <alpine.LFD.1.10.0804260955300.2813@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0804260955300.2813@woody.linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 26, 2008 at 10:03:31AM -0700, Linus Torvalds wrote:
> 
> 
> On Sat, 26 Apr 2008, Ingo Molnar wrote:
> > 
> > i've added Alexander's patch that does the cleanup suggested by you
> 
> Well.. Not really:
> 
> > diff --git a/arch/um/Kconfig.x86_64 b/arch/um/Kconfig.x86_64
> > index 3fbe69e..7a75043 100644
> > --- a/arch/um/Kconfig.x86_64
> > +++ b/arch/um/Kconfig.x86_64
> > @@ -27,6 +27,14 @@ config SMP_BROKEN
> >  	bool
> >  	default y
> >  
> > +config GENERIC_FIND_FIRST_BIT
> > +	bool
> > +	default y
> > +
> > +config GENERIC_FIND_NEXT_BIT
> > +	bool
> > +	default y
> > +
> 
> It still declares this GENERIC_FIND_*_BIT thing separately for UM.

It would be nice if this could follow the sample outlined
in Documentation/kbuild/kconfig-language.txt.

See the section about HAVE_

Basically we should only define the config symbol once in all
the Kconfig files and where we then want to use this function
we should select the config symbol.

	Sam
