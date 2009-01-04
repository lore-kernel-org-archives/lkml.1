Return-Path: <linux-kernel-owner+w=401wt.eu-S1754620AbZADCHB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754620AbZADCHB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 21:07:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751072AbZADCGw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 21:06:52 -0500
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:36590
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911AbZADCGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 21:06:51 -0500
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: PATCH [0/3]: Simplify the kernel build by removing perl.
Date: Sat, 3 Jan 2009 20:06:47 -0600
User-Agent: KMail/1.10.1 (Linux/2.6.27-7-generic; KDE/4.1.2; x86_64; ; )
Cc: Leon Woestenberg <leon.woestenberg@gmail.com>,
       Embedded Linux mailing list <linux-embedded@vger.kernel.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>
References: <200901020207.30359.rob@landley.net> <c384c5ea0901031454n451bc899w166bb146c96f6164@mail.gmail.com> <495FEEAF.5020005@zytor.com>
In-Reply-To: <495FEEAF.5020005@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901032006.47652.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 03 January 2009 17:03:11 H. Peter Anvin wrote:
> Leon Woestenberg wrote:
> > I agree with Rob that the amount of required dependencies should be
> > kept to a minimum.
> >
> > If we only use 0.5% of a certain language (or: dependent package),
> > then rather implement that 0.5% in the existing language.
> >
> > Dependencies very quickly become dependency hell. If A requires B,
> > then A also inherits all (future) requirements of B, etc. etc.
> >
> > In my daily software development work with Linux and GNU software in
> > general, 10% of it is spent fighting/removing these extremely "thin"
> > or false depencies, so that it is usuable in embedded devices.
>
> First of all, I largely consider this a joke.

Yes, I've noticed this.  The fact multiple other people do _not_ consider this 
a joke doesn't seem to have sunk in yet.

> All real-life embedded
> kernel builds take place on hosted platforms; anything else seems to be
> done "just because it can be done", as a kind of show-off art project.
> Cute, but hardly worth impeding the rest of the kernel community for.
>
> We're not talking about general platform dependencies here, but build
> dependencies for the kernel.  A platform that can build the kernel is
> not a small platform.

The kernel didn't need perl to build until 2.6.25.  For 17 years, this 
dependency was not required.  You added it, in a way that affected even 
"allnoconfig", for no obvious gain.

> Second of all, these patches are not fullworthy replacements.  The
> original patch using bc had less dependencies, but bc failed on some
> platforms, mysteriously.

So rather than debugging it, you rewrote it in perl.  Much less potential 
mysterious behavior there.

> The new patches have *more* environmental
> dependencies than that ever did.

Could you please be a little more specific?

> Third, if someone actually cares to do it right, I have a smallish
> bignum library at http://git.zytor.com/?p=lib/pbn.git;a=summary that
> might be a starting point.

This doesn't _need_ bignum support.  It maxes out around 72 bits and the 
_result_ can't use more than about $SHIFT bits because you're dividing by the 
amount you shifted, so just chop off the bottom 32 bits, do a normal 64 bit 
division on the top (it has to fit), and then do the same division on the 
appropriate shifted remainder, and combine the results.  This is easy because 
when the shift _is_ 32 bits or more, the bottom 32 bits all have to be zeroes 
so you don't even have to mask and add, just shift the remainder left 32 bits 
so you can continue the divide.

Pulling out perl isn't always a good alternative to thinking about the 
problem.

> 	-hpa

Rob
