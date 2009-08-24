Return-Path: <linux-kernel-owner+w=401wt.eu-S1751471AbZHXJ0d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751471AbZHXJ0d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 05:26:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751441AbZHXJ0d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 05:26:33 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:57852 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244AbZHXJ0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 05:26:32 -0400
Date: Mon, 24 Aug 2009 11:26:22 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Goswin von Brederlow <goswin-v-b@web.de>
Cc: Rob Landley <rob@landley.net>, kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com, tytso@mit.edu,
       rdunlap@xenotime.net, linux-doc@vger.kernel.org,
       linux-ext4@vger.kernel.org
Subject: Re: ext2/3: document conditions when reliable operation is possible
Message-ID: <20090824092622.GC25591@elf.ucw.cz>
References: <20090312092114.GC6949@elf.ucw.cz> <200903121413.04434.rob@landley.net> <20090316122847.GI2405@elf.ucw.cz> <200903161426.24904.rob@landley.net> <20090323104525.GA17969@elf.ucw.cz> <87ljqn82zc.fsf@frosties.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ljqn82zc.fsf@frosties.localdomain>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >> > This is not about barriers (that should be different topic). Atomic
> >> > write means that either whole sector is written, or nothing at all is
> >> > written. Because raid5 needs to update both master data and parity at
> >> > the same time, I don't think it can guarantee this during powerfail.
> 
> Actualy raid5 should have no problem with a power failure during
> normal operations of the raid. The parity block should get marked out
> of sync, then the new data block should be written, then the new
> parity block and then the parity block should be flaged in sync.
> 
> >> Good point, but I thought that's what journaling was for?
> >
> > I believe journaling operates on assumption that "either whole sector
> > is written, or nothing at all is written".
> 
> The real problem comes in degraded mode. In that case the data block
> (if present) and parity block must be written at the same time
> atomically. If the system crashes after writing one but before writing
> the other then the data block on the missng drive changes its
> contents. And for example with a chunk size of 1MB and 16 disks that
> could be 15MB away from the block you actualy do change. And you can
> not recover that after a crash as you need both the original and
> changed contents of the block.
> 
> So writing one sector has the risk of corrupting another (for the FS)
> totally unconnected sector. No amount of journaling will help
> there. The raid5 would need to do journaling or use battery backed
> cache.

Thanks, I updated my notes.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
