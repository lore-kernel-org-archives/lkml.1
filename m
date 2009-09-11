Return-Path: <linux-kernel-owner+w=401wt.eu-S1756962AbZIKVvY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756962AbZIKVvY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 17:51:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756406AbZIKVvX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 17:51:23 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:49481 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755992AbZIKVvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 17:51:22 -0400
Date: Fri, 11 Sep 2009 23:51:17 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Christoph Hellwig <hch@lst.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-mmc@vger.kernel.org, viro@zeniv.linux.org.uk
Subject: Re: Regression in suspend to ram in 2.6.31-rc kernels
Message-ID: <20090911215117.GA11441@elf.ucw.cz>
References: <c4e36d110909040213t4d4258b4w3e2d4725e0b2a161@mail.gmail.com> <87iqfx5mss.fsf@devron.myhome.or.jp> <20090907125130.GA1595@ucw.cz> <87ljko5k3v.fsf@devron.myhome.or.jp> <20090910192354.GD23356@elf.ucw.cz> <87bplim1ce.fsf@devron.myhome.or.jp> <20090911200922.GF8137@elf.ucw.cz> <c4e36d110909111414n716a06b1mdd0cd741230595b5@mail.gmail.com> <20090911213204.GC25544@elf.ucw.cz> <c4e36d110909111445nb6592cfue01543f5d04c2cda@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c4e36d110909111445nb6592cfue01543f5d04c2cda@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2009-09-11 23:45:01, Zdenek Kabelac wrote:
> 2009/9/11 Pavel Machek <pavel@ucw.cz>:
> >
> >> And why suspend of mmc should generate card removal ??
> >
> > Card is powered down during suspend -> mmc can't guarantee the card is
> > same and unchanged -> it makes some sense to simulate
> > removal/reinsert.
> 
> But how is this going to work when I keep the device mounted and
> blockdev is basically destroyed -  what if I'm reading file from card
> during suspend ?

"Don't do it".

> >> if I suspend and resume my laptop and I keep the card inside - all
> >> those step looks plain wrong.
> >
> > Unfortunately system can't tell.
> 
> Well system could check basic card ids if they match after resume - if
> some users wants to crash his card by randomly swapping it during
> suspend/resume - I'd have no problem with that....

Well, I do have small problem with that :-).

Anyway, patch for rechecking IDs would probably be accepted, but
that's not how it works now.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
