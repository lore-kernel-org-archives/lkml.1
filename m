Return-Path: <linux-kernel-owner+w=401wt.eu-S1765545AbXE2UGS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765545AbXE2UGS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 16:06:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757797AbXE2UGL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 16:06:11 -0400
Received: from keetweej.vanheusden.com ([213.84.46.114]:56095 "EHLO
	keetweej.vanheusden.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758101AbXE2UGJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 16:06:09 -0400
Date: Tue, 29 May 2007 22:06:08 +0200
From: Folkert van Heusden <folkert@vanheusden.com>
To: Pavel Machek <pavel@ucw.cz>, Theodore Tso <tytso@mit.edu>,
       M Macnair <mmacnair@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Seeding /dev/random not working
Message-ID: <20070529200608.GF19229@vanheusden.com>
References: <de6d2b4f0705290453kec2b050pb4d0bebc256b87a5@mail.gmail.com> <20070529131501.GA9899@thunk.org> <20070529141456.GC5840@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070529141456.GC5840@ucw.cz>
Organization: www.unixexpert.nl
X-Chameleon-Return-To: folkert@vanheusden.com
X-Xfmail-Return-To: folkert@vanheusden.com
X-Phonenumber: +31-6-41278122
X-URL: http://www.vanheusden.com/
X-PGP-KeyID: 1F28D8AE
X-GPG-fingerprint: AC89 09CE 41F2 00B4 FCF2  B174 3019 0E8C 1F28 D8AE
X-Key: http://pgp.surfnet.nl:11371/pks/lookup?op=get&search=0x1F28D8AE
Read-Receipt-To: <folkert@vanheusden.com>
Reply-By: Tue May 29 21:31:50 CEST 2007
X-Message-Flag: PGP key-id: 0x1f28d8ae - consider encrypting your e-mail to
	me with PGP!
User-Agent: Mutt/1.5.15+20070515 (2007-05-02)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > > I have two embedded boards (one ARM, one PowerPC), running two
> > > different versions of 2.6.  They have no hard drives, keyboards or
> > > mice.  They each have a NIC, but I understand these make no
> > > contribution to the entropy pool.
> > > 	if [ -f $random_seed ]; then
> > > 		cat $random_seed >/dev/urandom  # should seed the pool
> > > 	fi
> > > 	dd if=/dev/urandom of=$random_seed count=1 2>/dev/null # save some
> > > data from urandom for next boot
> > > I have rebooted my boards many times, and after each boot I read the
> > > contents of $random_seed.  Whilst it does not happen every time, the
> > > contents of $random_seed are /often the same/.  To give you a feel:
> > > rebooted 11 times, got a total of 3 different outputs.
> > 
> > Ok, so this is telling me a couple of things.  First of all, if you're
> > only getting three outputs, it means that you don't have any
> > peripherals feeding entropy into the system from the boot sequence.
> > Without any hard drives, keyboards or mice, and a NIC whose device
> > driver hasn't been configured to feed entropy, you're definitely
> > hosed.
> 
> Can we get at least time-of-boot from rtc clock to the pool? We really
> should not be getting identical outputs...

And add readings from lm-sensors as well? I guess harddisk and cpu
temperatures (lower bits) and such are pretty random?


Folkert van Heusden

-- 
MultiTail est un flexible tool pour suivre de logfiles et execution de
commandements. Filtrer, pourvoir de couleur, merge, 'diff-view', etc.
http://www.vanheusden.com/multitail/
----------------------------------------------------------------------
Phone: +31-6-41278122, PGP-key: 1F28D8AE, www.vanheusden.com
