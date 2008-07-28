Return-Path: <linux-kernel-owner+w=401wt.eu-S1755690AbYG1NMx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755690AbYG1NMx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 09:12:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752579AbYG1NMf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 09:12:35 -0400
Received: from bu3sch.de ([62.75.166.246]:51002 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752134AbYG1NMe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 09:12:34 -0400
From: Michael Buesch <mb@bu3sch.de>
To: David Brownell <david-b@pacbell.net>
Subject: Re: [PATCH v2] Add GPIO-based MMC/SD driver
Date: Mon, 28 Jul 2008 15:11:53 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Randy Dunlap <randy.dunlap@oracle.com>, gregkh <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       Piot Skamruk <piotr.skamruk@gmail.com>,
       Pierre Ossman <drzeus-mmc@drzeus.cx>, openwrt-devel@lists.openwrt.org
References: <200807182201.33913.mb@bu3sch.de> <20080721135332.4ce02e0c.randy.dunlap@oracle.com> <200807271630.07939.david-b@pacbell.net>
In-Reply-To: <200807271630.07939.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807281511.54299.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 28 July 2008 01:30:07 David Brownell wrote:
> > How to?
> 
> Simplest to just rip out the support for using one!  And in any case:
> as a rule, any delay should be a function of the target bus speed.

Well, that wasn't exactly an answer to my question. ;)
So setting boardinfo->max_speed_hz to zero will do?

> > Where's that documented?
> 
> UTSL ... mmc_spi_probe(), first thing.  :)

Well, the code of a function isn't really a documentation for its API. ;)
But well, thanks for the hint.

> Don't export that.  It's a (less expressive) subset of the standard
> way to do that.

Well, if we have that code in one place, why would we want to reinvent the
wheel over and over again? We can just export this API and let users use
it instead of requireing them to reinvent it.
I'm really really not too sure where your problem is with exporting
that API. If you don't want to use it, simply don't do so and reinvent
the wheel in your code. I'm prefectly fine with that. But IMO that's not
a good reason to hide the code from everybody else who wants to use it.

> > > 
> > > There is no "platform GPIO bus" ... 
> > 
> > hm??
> 
> If you look in /sys/bus you won't see GPIO.  It's not a bus.

Oh well... This is getting boring...
Then call it "platform GPIO pins" or "platform GPIO controller" or whatever.
That's really just splitting the hair into 16 parts.

> > People asked me to expose it. It was hidden in the first patch that
> > I submitted. I'm not going to change this just to see the next one
> > yelling "I want to see this interface in public" again.
> 
> Could you send me some URLs for that feedback?

It was private. One of the OpenWRT guys requested that to have a
convenient way to define a hardwired MMC card in the platform code
by just defining a simple data structure.

-- 
Greetings Michael.
