Return-Path: <linux-kernel-owner+w=401wt.eu-S1756498AbZIKUKu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756498AbZIKUKu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 16:10:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754411AbZIKUKt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 16:10:49 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:36062 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752786AbZIKUKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 16:10:48 -0400
Date: Fri, 11 Sep 2009 22:09:23 +0200
From: Pavel Machek <pavel@ucw.cz>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Zdenek Kabelac <zdenek.kabelac@gmail.com>, Christoph Hellwig <hch@lst.de>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-mmc@vger.kernel.org, viro@zeniv.linux.org.uk
Subject: Re: Regression in suspend to ram in 2.6.31-rc kernels
Message-ID: <20090911200922.GF8137@elf.ucw.cz>
References: <c4e36d110909010234i5f1b9357l805132137725a4f8@mail.gmail.com> <c4e36d110909031529q77b53122kdb85785ba293c478@mail.gmail.com> <20090903232317.GA6760@lst.de> <87ljkvmt71.fsf@devron.myhome.or.jp> <c4e36d110909040213t4d4258b4w3e2d4725e0b2a161@mail.gmail.com> <87iqfx5mss.fsf@devron.myhome.or.jp> <20090907125130.GA1595@ucw.cz> <87ljko5k3v.fsf@devron.myhome.or.jp> <20090910192354.GD23356@elf.ucw.cz> <87bplim1ce.fsf@devron.myhome.or.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87bplim1ce.fsf@devron.myhome.or.jp>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Um..., sorry, I'm not sure what are you talking about. Of course, the
> problem of this is that system freeze on suspend.
> 
> Or are you asking my guess of the cause, or something?  If so, although
> I'm not reading all emails on this thread, from Zdenek's backtrace, the
> sequence would be
> 
>     1) suspend mmc
>     2) mmc generates card removed event
>     3) prepare to invalidate blockdev
>     4) sync fs on invalidating blockdev
>     5) flush buffers on invalidating blockdev (partitions)
>     6) delete blockdev (partitions)
> 
> or like the above. And I can guess some possible issues/root-cause we
> have to handle from it.
> 
>     a) card removed event from mmc for suspend is right design?
>     b) the card can be changed/removed before system was resumed, mmc
>        can be detect/handle it properly?
>     c) flushing buffers on _deleted_ device is right design?
> 
> and I suspect there are more issues in detail and resume process though.

I guess c) is main problem. If device is not there, how do you want to
flush buffers on it?

								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
