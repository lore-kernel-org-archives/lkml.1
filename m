Return-Path: <linux-kernel-owner+w=401wt.eu-S1752668AbYKRIeD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752668AbYKRIeD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 03:34:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750967AbYKRIdx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 03:33:53 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:54582 "EHLO UNKNOWN"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750756AbYKRIdx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 03:33:53 -0500
Date: Tue, 18 Nov 2008 09:33:47 +0100
From: Pavel Machek <pavel@suse.cz>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] leds: Fix locking for WM8350
Message-ID: <20081118083346.GB1494@ucw.cz>
References: <1226579997-3505-1-git-send-email-broonie@opensource.wolfsonmicro.com> <1226588269-17642-1-git-send-email-broonie@opensource.wolfsonmicro.com> <20081115173110.GD1523@ucw.cz> <20081115175050.GB12466@opensource.wolfsonmicro.com> <20081115185119.GA19900@elf.ucw.cz> <20081115191414.GA12907@opensource.wolfsonmicro.com> <1226935995.17109.22.camel@ted>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1226935995.17109.22.camel@ted>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2008-11-17 15:33:15, Richard Purdie wrote:
> On Sat, 2008-11-15 at 19:14 +0000, Mark Brown wrote:
> > On Sat, Nov 15, 2008 at 07:51:20PM +0100, Pavel Machek wrote:
> > > On Sat 2008-11-15 17:50:50, Mark Brown wrote:
> > 
> > > > Yes, that'd be safer though I'd be surprised to see systems that could
> > > > trigger it.
> > 
> > > Yes, they are uncommon. They exist; SPARC, IIRC. Plus you need
> > 
> > Exceptionally uncommon with the systems the WM8350 gets used with -
> > it's a primary PMIC for mobile devices so anything other than
> > uniprocessor ARM would be surprising.
> > 
> > > barriers on anything SMP... Just use atomic_t.
> > 
> > I was intending to do so next time I spin the patch.  Andrew had some
> > other comments and I don't have any test systems when I'm not in the
> > office anyway.
> 
> I've not looked in detail at the code but it looks like a maximum of a
> 32 bit value where you don't actually care which write succeeds as long
> as it takes one of the values written? I don't see why that particular
> variable needs any locking or to be atomic?

Yes.. but it would hurt if you  find 42 there, right? So atomic_t is
safer. gcc is alowed to do fancy optimalizations on plain integers....

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
