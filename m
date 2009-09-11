Return-Path: <linux-kernel-owner+w=401wt.eu-S1757174AbZIKWgJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757174AbZIKWgJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 18:36:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757145AbZIKWgI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 18:36:08 -0400
Received: from void.printf.net ([89.145.121.20]:49370 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757129AbZIKWgH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 18:36:07 -0400
From: Chris Ball <cjb@laptop.org>
To: Zdenek Kabelac <zdenek.kabelac@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Christoph Hellwig <hch@lst.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-mmc@vger.kernel.org, viro@zeniv.linux.org.uk
Subject: Re: Regression in suspend to ram in 2.6.31-rc kernels
References: <c4e36d110909010234i5f1b9357l805132137725a4f8@mail.gmail.com>
	<20090903232317.GA6760@lst.de> <87ljkvmt71.fsf@devron.myhome.or.jp>
	<c4e36d110909040213t4d4258b4w3e2d4725e0b2a161@mail.gmail.com>
	<87iqfx5mss.fsf@devron.myhome.or.jp> <20090907125130.GA1595@ucw.cz>
	<87ljko5k3v.fsf@devron.myhome.or.jp>
	<20090910192354.GD23356@elf.ucw.cz>
	<87bplim1ce.fsf@devron.myhome.or.jp>
	<20090911200922.GF8137@elf.ucw.cz>
	<c4e36d110909111414n716a06b1mdd0cd741230595b5@mail.gmail.com>
Date: Fri, 11 Sep 2009 18:22:42 -0400
In-Reply-To: <c4e36d110909111414n716a06b1mdd0cd741230595b5@mail.gmail.com>
	(Zdenek Kabelac's message of "Fri, 11 Sep 2009 23:14:08 +0200")
Message-ID: <m3k505qfyl.fsf@pullcord.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

   > IMHO steps 2..6 are only valid for the case I would 'remove'
   > unexpectedly card - but if I suspend and resume my laptop and I
   > keep the card inside - all those step looks plain wrong.

How can the MMC stack tell whether you kept the card inside or
modified it during suspend?

There's no way to know, and an incorrect guess gives you filesystem
corruption, so we remove cards on suspend and reprobe them on resume.
(If you did know that cards would never be removed during suspend,
you could set CONFIG_MMC_UNSAFE_RESUME=y.)

So, I'd say:

   >> a) card removed event from mmc for suspend is right design?

Yes, for a card containing a filesystem with CONFIG_MMC_UNSAFE_RESUME
not set.

   >> b) the card can be changed/removed before system was resumed, mmc
   >> can be detect/handle it properly?

Yes, precisely because we removed it before suspend.

   >> c) flushing buffers on _deleted_ device is right design?

No, something's obviously gone wrong here.

-- 
Chris Ball   <cjb@laptop.org>
One Laptop Per Child
