Return-Path: <linux-kernel-owner+w=401wt.eu-S935480AbXG2UHK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935480AbXG2UHK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 16:07:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933547AbXG2UG6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 16:06:58 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:35806 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933542AbXG2UG6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 16:06:58 -0400
Date: Sun, 29 Jul 2007 22:08:00 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Meelis Roos <mroos@linux.ee>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Richard Henderson <rth@twiddle.net>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Jay Estabrook <jay.estabrook@hp.com>
Subject: Re: [PATCH] lib: move kasprintf to a separate file
Message-ID: <20070729200800.GA21064@uranus.ravnborg.org>
References: <Pine.SOC.4.64.0706041419470.7370@math> <20070605231712.ff1df46f.akpm@linux-foundation.org> <Pine.SOC.4.64.0707281950340.20474@math.ut.ee> <20070728200450.GA25619@uranus.ravnborg.org> <20070728202012.GB25619@uranus.ravnborg.org> <46ABC7C0.9060302@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46ABC7C0.9060302@goop.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 28, 2007 at 03:48:32PM -0700, Jeremy Fitzhardinge wrote:
> Sam Ravnborg wrote:
> > kasprintf pulls in kmalloc which proved to be fatal for at least
> > bootimage target on alpha.
> > Move it to a separate file so only users of kasprintf are exposed
> > to the dependency on kmalloc.
> >   
> 
> OK by me (that's what my original patch did), but it might be worth
> documenting what environmental constraints vsprintf.c is under.  I
> didn't realize it was used by non-kernel code.

Looking for other users I saw that i386 iboot had included a minimal printf
implmentation which could also be a possibility for alpha.
Now the i386 printf does not support 64 bit - but I dunno if this is
a problem for alpha.

Actually I would prefer the local printf solution for alpha to
keep dependencies on the functions in lib/ as one may expect 
them (kernel only - not boot).

	Sam
