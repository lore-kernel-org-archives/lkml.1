Return-Path: <linux-kernel-owner+w=401wt.eu-S933091AbZKDXQi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933091AbZKDXQi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 18:16:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933063AbZKDXQi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 18:16:38 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:56265 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933062AbZKDXQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 18:16:37 -0500
Date: Thu, 5 Nov 2009 00:16:35 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Paul Fertser <fercerpav@gmail.com>
Cc: Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/6] power: pcf50633: properly reenable charging when
 the supply conditions change
Message-ID: <20091104231635.GD27325@elf.ucw.cz>
References: <1257369899-325-1-git-send-email-fercerpav@gmail.com>
 <1257369899-325-2-git-send-email-fercerpav@gmail.com>
 <1257369899-325-3-git-send-email-fercerpav@gmail.com>
 <1257369899-325-4-git-send-email-fercerpav@gmail.com>
 <1257369899-325-5-git-send-email-fercerpav@gmail.com>
 <20091104214622.GA27325@elf.ucw.cz>
 <20091104222431.GB24196@home.pavel.comp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091104222431.GB24196@home.pavel.comp>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2009-11-05 01:24:31, Paul Fertser wrote:
> Hi,
> 
> On Wed, Nov 04, 2009 at 10:46:22PM +0100, Pavel Machek wrote:
> > On Thu 2009-11-05 00:24:58, Paul Fertser wrote:
> > > If chgmod == BATFULL, setting chgena has no effect. Datasheet says we
> > > need to set resume instead but when autoresume is used resume doesn't
> > > work. Clear and set chgena instead.
> > > 
> > > This enables a user to force charging by re-plugging USB even when the
> > > charger entered Battery Full mode, might be handy before a long
> > > trip.
> > 
> > And is against manufacturer recommendation and will unneccessary
> > shorted life of battery with frequent plugs/unplugs. Is it good idea?
> 
> Well, to me it seems that frequent plugs/unplugs is not exactly common
> usecase so i consider that to be acceptable.

Well, they are quite common here with my HTC Dream at least (I'm not
sure what your device is). Often, I unplug it from 1A charger to
connect it to PC for file transfer, and back.

> Especially comparing to millions of laptops and netbooks that always
> top their battery while being externally powered and heat it at the
> same time, probably the worst conditions lifetime-wise one can
> imagine.

Well, at least thinkpads will not start charging the battery when over
95%. (And the limit is configurable).

> > If you want to "top-up" the battery, perhaps that should be on
> > explicit request, like something in /sys?
> 
> Well, probably but to me it seems like an unnecessary complexity. 

And leaving behaviour before patch, that is "do not charge if battery
is over 80%" -- AFAICT from the changelog.

>Also
> since Li* batteries are dominating the market nowadays this
> functionality would need to be introduced in the power_supply core to
> provide userspace with a consistent interface. Anton, can you please
> comment on this?

I agree that it is not important part of functionality, but at least
Dream, Spitz and Collie could use that support....
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
