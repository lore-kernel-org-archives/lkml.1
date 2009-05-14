Return-Path: <linux-kernel-owner+w=401wt.eu-S1754590AbZENJlF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754590AbZENJlF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 05:41:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752055AbZENJky
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 05:40:54 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:45707 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751731AbZENJkx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 05:40:53 -0400
Date: Thu, 14 May 2009 11:40:46 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-pm@lists.linux-foundation.org, fengguang.wu@intel.com,
       linux-kernel@vger.kernel.org, nigel@tuxonice.net, rientjes@google.com,
       linux-mm@kvack.org
Subject: Re: [PATCH 4/6] PM/Hibernate: Rework shrinking of memory
Message-ID: <20090514094046.GF6417@elf.ucw.cz>
References: <200905070040.08561.rjw@sisk.pl> <200905132255.04681.rjw@sisk.pl> <20090513141647.076b67f0.akpm@linux-foundation.org> <200905132356.39481.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200905132356.39481.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > > > The main point (I thought) was to remove shrink_all_memory().  Instead,
> > > > we're retaining it and adding even more stuff?
> > > 
> > > The idea is that afterwards we can drop shrink_all_memory() once the
> > > performance problem has been resolved.  Also, we now allocate memory for the
> > > image using GFP_KERNEL instead of doing it with GFP_ATOMIC after freezing
> > > devices.  I'd think that's an improvement?
> > 
> > Dunno.  GFP_KERNEL might attempt to do writeback/swapout/etc, which
> > could be embarrassing if the devices are frozen.
> 
> They aren't, because the preallocation is done upfront, so once the OOM killer
> has been taken care of, it's totally safe. :-)

As is GFP_ATOMIC. Except that GFP_KERNEL will cause catastrophic
consequences when accounting goes wrong. (New kernel's idea of what is
on disk will differ from what is _really_ on disk.)

If accounting is right, GFP_ATOMIC and GFP_KERNEL is equivalent.

If accounting is wrong, GFP_ATOMIC will fail with NULL, while
GFP_KERNEL will do something bad.

I'd keep GFP_ATOMIC (or GFP_NOIO or similar). 

								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
