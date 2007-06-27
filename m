Return-Path: <linux-kernel-owner+w=401wt.eu-S1761005AbXF0NGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761005AbXF0NGU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 09:06:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756388AbXF0NGM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 09:06:12 -0400
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:44838
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755916AbXF0NGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 09:06:12 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [PATCH RFC #2] hwrng: Add type categories
Date: Wed, 27 Jun 2007 15:05:33 +0200
User-Agent: KMail/1.9.6
Cc: Matt Mackall <mpm@selenic.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
References: <200706262021.51410.mb@bu3sch.de> <20070626224517.GG11115@waste.org> <20070627024856.GB5491@khazad-dum.debian.net>
In-Reply-To: <20070627024856.GB5491@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706271505.33970.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 27 June 2007 04:48:56 Henrique de Moraes Holschuh wrote:
> (a) is just broken, unless one is to take it as "never use it".  And I am
> really not sure about (b).  It *is* better than just using whatever crap we
> found first (or last), but it is the wrong solution for a problem that we
> really should not have in the first place if someone had thought a bit
> before adding a misc device for something that has no reason to be unique in
> a system.

Well, we have that userspace ABI of one hwrng char device. I did not
invent that. It's kind of broken, yes.
And changing it in a compatible way is probably difficult.

> Instead of papering over the problem with borked solutions, maybe we should
> just export ALL HRNGs to userspace.  While at it, please add whatever is

And then we would _still_ export some kind of hint for rngd that
the CPU rng device should be preferred over the bcm43xx device.
rngd needs some basic hint about the devices.
How would you implement that? (We're back to my TYPE_XXX definitions ;) )

> needed so that userspace can talk to the kernel driver to get vital
> information about the HRNG device the driver might have (the current
> interface is a bad simplistic hack).

What is "vital information"? My TYPE_XXX categories? ;)

> Let userspace get the data from whichever HRNG it wants, process it in any

It _can_. We can switch the RNG in sysfs. So userspace _can_ get data
from whichever HWRNG it wants.

> way it wants and pipe it back through /dev/random IOCTLs.  And let it do it
> for as many HRNGs it wants at the same time.

That's an improvement, yes.

> And if you must have /dev/hw_random point somewhere, let udev scripts or
> something else like that take care of it.

Could do that, yes.


-- 
Greetings Michael.
