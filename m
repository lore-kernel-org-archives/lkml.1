Return-Path: <linux-kernel-owner+w=401wt.eu-S1754937AbZKVMW3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754937AbZKVMW3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 07:22:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754752AbZKVMW2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 07:22:28 -0500
Received: from cust.7.157.adsl.cistron.nl ([62.216.7.157]:39666 "EHLO
	larstiq.dyndns.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754257AbZKVMW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 07:22:28 -0500
X-Greylist: delayed 2379 seconds by postgrey-1.27 at vger.kernel.org; Sun, 22 Nov 2009 07:22:27 EST
Date: Sun, 22 Nov 2009 12:42:35 +0100
From: Wouter van Heyst <larstiq@larstiq.dyndns.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mmc@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, 504391@bugs.debian.org,
       Pierre Ossman <pierre@ossman.eu>
Subject: Re: [PATCH] mmc: add module parameter to set whether cards are
	assumed removable
Message-ID: <20091122114234.GA28590@one.lan>
References: <1257914676.2237.57.camel@localhost> <20091116122329.847916b6.akpm@linux-foundation.org> <1258410709.2792.9.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1258410709.2792.9.camel@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 16, 2009 at 10:31:49PM +0000, Ben Hutchings wrote:
> On Mon, 2009-11-16 at 12:23 -0800, Andrew Morton wrote:
> > On Wed, 11 Nov 2009 04:44:36 +0000
> > Ben Hutchings <ben@decadent.org.uk> wrote:
> > 
> > > Some people run general-purpose distribution kernels on netbooks with
> > > a card that is physically non-removable or logically non-removable
> > > (e.g. used for /home) and cannot be cleanly unmounted during suspend.
> > > Add a module parameter to set whether cards are assumed removable or
> > > non-removable, with the default set by CONFIG_MMC_UNSAFE_RESUME.
> > > 
> > 
> > The description really doesn't give me enough info to work out what's
> > happening here and why this is being proposed.  But it smells nasty.
> 
> In general, it is not possible to tell whether a card present in an MMC
> slot after resume is the same that was there before suspend.  So there
> are two possible behaviours, each of which will cause data loss in some
> cases:
> 
> CONFIG_MMC_UNSAFE_RESUME=n (default): Cards are assumed to be removed
> during suspend.  Any filesystem on them must be unmounted before
> suspend; otherwise, buffered writes will be lost.
> 
> CONFIG_MMC_UNSAFE_RESUME=y: Cards are assumed to remain present during
> suspend.  They must not be swapped during suspend; otherwise, buffered
> writes will be flushed to the wrong card.
> 
> Currently the choice is made at compile time and this allows that to be
> overridden at module load time.

I'm running 2.6.32-rc7 with this patch applied and CONFIG_MMC_UNSAFE_RESUME=y
That works as desired for my non-removable case. Is it desired that I
test if 'removable=1' will thrash my filesystem?

Wouter van Heyst
