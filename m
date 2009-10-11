Return-Path: <linux-kernel-owner+w=401wt.eu-S1752373AbZJKVgY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752373AbZJKVgY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 17:36:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752268AbZJKVgY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 17:36:24 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:33197 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752261AbZJKVgX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 17:36:23 -0400
Date: Sun, 11 Oct 2009 23:35:46 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [regressions] Re: kbuild: save ARCH & CROSS_COMPILE when
	building a kernel
Message-ID: <20091011213546.GB2768@merkur.ravnborg.org>
References: <20091003103441.GA10874@elte.hu> <20091004191729.GA20203@merkur.ravnborg.org> <20091009092648.GA18894@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091009092648.GA18894@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 09, 2009 at 11:26:48AM +0200, Ingo Molnar wrote:
> 
> * Sam Ravnborg <sam@ravnborg.org> wrote:
> 
> > On Sat, Oct 03, 2009 at 12:34:41PM +0200, Ingo Molnar wrote:
> > > 
> > > Sam,
> > > 
> > > that arch-cache thing introduced in:
> > > 
> > >  5755433: kbuild: save ARCH & CROSS_COMPILE when building a kernel
> > > 
> > > isnt working very well in my experience.
> > > 
> > > 1) it's a nuisance in cross-builds (it broke several cross-build scripts 
> > >    of mine)
> >
> > On the contrary it has helped me big time on my cross builds. [...]
> 
> Could you please try to do that without hurting the existing scripting 
> and existing workflow of other people?

The only message in the above was that this was also beneficial
to some - and not a nusiance only.

> 
> > No need to script is all to remember to set the correct ARCH + 
> > CROSS_COMPILE settings.
> 
> Then put your new state into the .config instead of this stupid 
> include/generated/ extra state that is a _big_ regression over v2.6.31 
> in terms of cross-build usability.

I cannot see why saving this in include/generated/*
has anything to do with your complains. I guess you did not look
at the patch in question.

What is hurting you and several other users are _not_ related
to the fact that we save ARCH and CROSS_COMPILE setting or where
we save it.
What hurt you is the consistency checks that was added
to try to catch people in doing something unexpected.

Unexpected like trying to build a 64 bit kernel where they
previosuly were building a 32 bit kernel.
Or when they suddenly used a different set of binutils
because they changed CROSS_COMPILE settings.


The patch in question is reverted in my next push to Linus.
This is not an argument about that.
This is solely an argument about why it had this negative
impact for you and others.

[PS - mails had not been ignored. Other stuff just had higher
priority]

	Sam
