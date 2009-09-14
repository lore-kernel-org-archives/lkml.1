Return-Path: <linux-kernel-owner+w=401wt.eu-S933912AbZINU1k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933912AbZINU1k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 16:27:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933890AbZINU1h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 16:27:37 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:40252 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933901AbZINU1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 16:27:34 -0400
Date: Mon, 14 Sep 2009 22:27:29 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Chris Ball <cjb@laptop.org>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Christoph Hellwig <hch@lst.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-mmc@vger.kernel.org, viro@zeniv.linux.org.uk
Subject: Re: Regression in suspend to ram in 2.6.31-rc kernels
Message-ID: <20090914202729.GB10398@elf.ucw.cz>
References: <20090903232317.GA6760@lst.de> <c4e36d110909111445nb6592cfue01543f5d04c2cda@mail.gmail.com> <m3eiqdqfnm.fsf@pullcord.laptop.org> <200909120036.41725.rjw@sisk.pl> <c4e36d110909140139u786f2165oc5a35dce5b2c0527@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c4e36d110909140139u786f2165oc5a35dce5b2c0527@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2009-09-14 10:39:44, Zdenek Kabelac wrote:
> 2009/9/12 Rafael J. Wysocki <rjw@sisk.pl>:
> > On Saturday 12 September 2009, Chris Ball wrote:
> >> Hi,
> >>
> >>    > Well system could check basic card ids if they match after resume
> >>
> >> No.  That (arguably) guarantees that it's the same card, but not that
> >> it wasn't modified in another machine during the suspend.
> >
> > Generally speaking, we'd also need to check superblocks for this to work.
> >
> >>    > if some users wants to crash his card by randomly swapping it
> >>    > during suspend/resume - I'd have no problem with that....
> >>
> >> You should have a problem with it.  Taking a card from a suspended
> >> machine and working on it with a different machine is not a bizarre
> >> thing to want to do.
> >
> > Agreed.
> 
> 
> Well - ok - so let me ask this question - if I'll replace local hard
> drive during suspend - what will happen - is this prohibited by hw
> (e.i. to switch SATA cables) ?

During _suspend_: yes. You are not expected to open your machine while
powered up.

> IMHO filesystem should be able to detect corruption of its data
> structures - (assuming fs is notified about suspend/resume
> operation)

Patch welcome.

> Also there could be one simple quick solution/hack - to require to
> have at least all remote drives unmounted - so suspend would be
> refused if it runs mounted card/usb drive -  this would be 100% better
> than current solution which effectively kills my laptop if I forget to
> unmount card in mmc reader - especially if dmesg contains message with
> the reason why my suspend fails.

It should not _kill_ your laptop -- that's a bug we want to
fix. Instead it is designed to behave as if you hot-unplugged your
card while mounted.

									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
