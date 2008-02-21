Return-Path: <linux-kernel-owner+w=401wt.eu-S933041AbYBUUGW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933041AbYBUUGW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 15:06:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755650AbYBUUGL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 15:06:11 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:37729 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755579AbYBUUGJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 15:06:09 -0500
Date: Thu, 21 Feb 2008 21:06:20 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       Stefano Brivio <stefano.brivio@polimi.it>,
       Al Viro <viro@zeniv.linux.org.uk>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mac80211: check endianness/types in sparse runs
Message-ID: <20080221200620.GA29352@uranus.ravnborg.org>
References: <1203503909.17534.14.camel@johannes.berg> <20080220195913.GE21139@uranus.ravnborg.org> <1203597776.20331.5.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1203597776.20331.5.camel@johannes.berg>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 21, 2008 at 01:42:56PM +0100, Johannes Berg wrote:
> >> [patch doing CHECKFLAGS += -D__CHECK_ENDIAN__ in the
> >> net/mac80211/Makefile]
> 
> > I would prefer it to be kernel wide enabled.
> > Tried a defconfig build.
> 
> Hm. I tend to think there was a reason for this, since this is actually
> explicitly disabled by include/linux/types.h:
> 
> #ifdef __CHECKER__
> #define __bitwise__ __attribute__((bitwise))
> #else 
> #define __bitwise__
> #endif
> 
> #ifdef __CHECK_ENDIAN__
> #define __bitwise __bitwise__
> #else
> #define __bitwise
> #endif
> 
> The commit that introduced __CHECK_ENDIAN__ was
> af4ca457eaf2d6682059c18463eb106e2ce58198 ("gfp_t: infrastructure") but
> it doesn't say anything about the rationale for it.
> 
> > When I enabled __CHECK_ENDIAN I got:
> > 8 files with > 100 warnings
> > 14 files with 10 to 99 warnings.
> > 
> > So nothing that should scare a kernel hacker...
> > 
> > warnings without: 1686
> > warnings with: 2788
> > 
> > OK - thats a lot, but then fixing 8 files will significantly
> > reduce this.
> 
> I recently ran sparse on my config and was surprised by the number of
> warnings. Then again, something in mmzone.h or so generated billions of
> them...
> 
> In any case, I would love to have __CHECK_ENDIAN__ enabled by default at
> least on the wireless code (just caught another bug with it...)

I should then add support for something like:

checkflags-y := -D__CHECK_ENDIAN__

to match the style of the rest.

I do not like all the buried in assumption about the
global variables.


But I would prefer that someone would spend a few days looking into the
warnings generated with sparse.
Dedicating a few hours/day in a week could help a lot here if
one understand the warnings.

What I see is that people mindlessly add code that introduce
new sparse warnings without noticing simply due to the
massive amount of warnings generated.

	Sam
