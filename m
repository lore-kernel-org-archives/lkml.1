Return-Path: <linux-kernel-owner+w=401wt.eu-S1752911AbZDMVhM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752911AbZDMVhM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 17:37:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751226AbZDMVg4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 17:36:56 -0400
Received: from mk-filter-3-a-1.mail.uk.tiscali.com ([212.74.100.54]:46680 "EHLO
	mk-filter-3-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750836AbZDMVgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 17:36:54 -0400
X-Trace: 177660549/mk-filter-3.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.21.180/None/adrian@newgolddream.dyndns.info
X-SBRS: None
X-RemoteIP: 79.69.21.180
X-IP-MAIL-FROM: adrian@newgolddream.dyndns.info
X-MUA: Evolution 2.24.3 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AiAFAFtN40lPRRW0/2dsb2JhbACBUst1g3wG
X-IronPort-AV: E=Sophos;i="4.40,181,1238972400"; 
   d="scan'208";a="177660549"
Subject: Re: [RFC][patch] filesystem: Vmufat filesystem, version 4
From: Adrian McMenamin <adrian@newgolddream.dyndns.info>
To: Paul Mundt <lethal@linux-sh.org>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-sh <linux-sh@vger.kernel.org>,
       "Josef 'Jeff' Sipek" <jeffpc@josefsipek.net>,
       Sam Ravnborg <sam@ravnborg.org>
In-Reply-To: <20090413210030.GA14847@linux-sh.org>
References: <1239654768.6542.10.camel@localhost.localdomain>
	 <20090413210030.GA14847@linux-sh.org>
Content-Type: text/plain
Date: Mon, 13 Apr 2009 22:36:44 +0100
Message-Id: <1239658604.6542.28.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-04-14 at 06:00 +0900, Paul Mundt wrote:
> On Mon, Apr 13, 2009 at 09:32:48PM +0100, Adrian McMenamin wrote:
> > I know this still has issues that others have raised but I wanted to
> > post a version before the end of the long weekend...
> > 
> Make sure all of the folks that had comments are included in the Cc on
> future versions. If they haven't seen the updated version and are
> therefore unable to comment on it, that is not an indicator that the
> issues have been addressed.


Fair point. Did think about this but wasn't sure what the correct
etiquette is, as sometimes people don't want more email, but will do so
in future.

> 
> Reviewing code is tedious work at best, making people that have taken the
> time to participate in review do even more work to find updated versions
> that may or may not have addressed their issues is remarkably poor
> etiquette at best, especially when they haven't completed their review.
> 

As far as I can see the three issues I haven't addressed were posting a
further patch to magic.h and a couple of *suggestions* about code style.
I will fix these points in due course, for sure. I have taken on board,
afaics, all the substantive points for which thanks

...


> 
> > A few people commented that this is a bit long for a single file - but
> > it is comparable to other files in the filesystem hierarchy - comments
> > welcome.
> > 

...

>
> Furthermore, the fact other file systems haven't done so is not an excuse
> for you not to, especially as their reasons for doing so might be valid
> (you of course haven't bothered citing what other file systems you are
> referring to, so one can only vaguely postulate, though at least the
> arguments for things like cramfs do not apply to vmufat).
> 

I didn't say that it was - I was offering my explanation for having
taken the decision to make it all one file and then seeing what the
bounce back was... there are in fact a very large number of filesystems
like this, not least of which of course is ext2 which has longer inode.c
and super.c files than this inode.c


> You should also think about whether you really want to go down the road
> of decoupling this from the VMU device dependencies. vmufat is not and
> never will be a general purpose file system, the on-disk format,
> limitation in block numbering, etc. are all directly tied to the VMU
> itself. Since you cited emulators as a potential user, these should be
> emulating the VMU itself anyways before you worry about layering vmufat
> on top of it. Trying to position this as a general purpose file system
> will bring you a world of pain you really don't want.

The two compromises are that on a failed read of a block it tries again
(as experience suggest that fixes most issues with the flaky VMU
hardware - though I doubt emulator builders will replicate that) and
that it does not write out a new date for the "superblock" on a change
of the filesystem - to avoid wear on the flash on the VMU, but again not
an issue for most emulator writers - I think the Kconfig makes it pretty
clear this isn't a general purpose filesystem.

