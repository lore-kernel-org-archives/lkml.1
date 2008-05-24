Return-Path: <linux-kernel-owner+w=401wt.eu-S1762009AbYEXUpj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762009AbYEXUpj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 16:45:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760042AbYEXUpb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 16:45:31 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:43273 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756456AbYEXUpa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 16:45:30 -0400
Date: Sat, 24 May 2008 22:46:10 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Roman Zippel <zippel@linux-m68k.org>
Subject: Re: [RFC PATCH] kconfig: introduce KCONFIG_* symbols for .c files
Message-ID: <20080524204610.GB3136@uranus.ravnborg.org>
References: <20080524192540.GA28067@uranus.ravnborg.org> <20080524125316.4b969936.akpm@linux-foundation.org> <48387736.9050004@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48387736.9050004@goop.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 24, 2008 at 09:14:46PM +0100, Jeremy Fitzhardinge wrote:
> Andrew Morton wrote:
> >It could help to get us out of the occasional sticky situation, but it
> >  
> 
> I think if you know you can use the if(KCONFIG_) technique, then one 
> would tend to structure things so that you do it as much as possible.  
> Ideally you'd use CONFIG vars in Makefiles to make code go away 
> entirely, and if (KCONFIG_) in .c files to do conditional compilation.
> 
> >does seem a bit risky.  What happens with Kconfig variables which are
> >just not known about at all with some .configs?
> >
> >Silly example, one could add
> >
> >	if (KCONFIG_DVB_VES1820)
> >
> >to kernel/sched.c and that would work happily until someone sets DVB=n,
> >in which case I assume KCONFIG_DVB_VES1820 doesn't get defined
> >anywhere?
> >
> >A more realistic example might be using an x86-only KCONFIG_* in non-x86
> >code.
> >  
> 
> Well, logically that means that all config vars are always "known", even 
> if they can never be defined.  I don't know what the practicalities of 
> that are: can all Kconfig files everywhere reasonably be scanned to 
> produce the symbol list?

When we have one configuration for the kernel and not as today
where we have one configuration for each architecture (with a lot
of shared files) then it is already taken care of by my (updated) patch.

	Sam
