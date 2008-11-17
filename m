Return-Path: <linux-kernel-owner+w=401wt.eu-S1754807AbYKQWoc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754807AbYKQWoc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 17:44:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753737AbYKQWoP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 17:44:15 -0500
Received: from tim.rpsys.net ([194.106.48.114]:52348 "EHLO tim.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753662AbYKQWoP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 17:44:15 -0500
Subject: Re: [PATCH] leds: Fix locking for WM8350
From: Richard Purdie <rpurdie@rpsys.net>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Pavel Machek <pavel@suse.cz>, linux-kernel@vger.kernel.org
In-Reply-To: <20081115191414.GA12907@opensource.wolfsonmicro.com>
References: <1226579997-3505-1-git-send-email-broonie@opensource.wolfsonmicro.com>
	 <1226588269-17642-1-git-send-email-broonie@opensource.wolfsonmicro.com>
	 <20081115173110.GD1523@ucw.cz>
	 <20081115175050.GB12466@opensource.wolfsonmicro.com>
	 <20081115185119.GA19900@elf.ucw.cz>
	 <20081115191414.GA12907@opensource.wolfsonmicro.com>
Content-Type: text/plain
Date: Mon, 17 Nov 2008 15:33:15 +0000
Message-Id: <1226935995.17109.22.camel@ted>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-11-15 at 19:14 +0000, Mark Brown wrote:
> On Sat, Nov 15, 2008 at 07:51:20PM +0100, Pavel Machek wrote:
> > On Sat 2008-11-15 17:50:50, Mark Brown wrote:
> 
> > > Yes, that'd be safer though I'd be surprised to see systems that could
> > > trigger it.
> 
> > Yes, they are uncommon. They exist; SPARC, IIRC. Plus you need
> 
> Exceptionally uncommon with the systems the WM8350 gets used with -
> it's a primary PMIC for mobile devices so anything other than
> uniprocessor ARM would be surprising.
> 
> > barriers on anything SMP... Just use atomic_t.
> 
> I was intending to do so next time I spin the patch.  Andrew had some
> other comments and I don't have any test systems when I'm not in the
> office anyway.

I've not looked in detail at the code but it looks like a maximum of a
32 bit value where you don't actually care which write succeeds as long
as it takes one of the values written? I don't see why that particular
variable needs any locking or to be atomic?

Cheers,

Richard

