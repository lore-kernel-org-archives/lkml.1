Return-Path: <linux-kernel-owner+w=401wt.eu-S1756789AbZAPGoh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756789AbZAPGoh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 01:44:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753718AbZAPGo1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 01:44:27 -0500
Received: from brick.kernel.dk ([93.163.65.50]:10775 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752457AbZAPGo0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 01:44:26 -0500
Date: Fri, 16 Jan 2009 07:43:02 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Grant Grundler <grundler@google.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
       Greg Freemyer <greg.freemyer@gmail.com>, Tejun Heo <htejun@gmail.com>,
       Michael Tokarev <mjt@tls.msk.ru>, Kay Sievers <kay.sievers@vrfy.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] block: export SSD/non-rotational queue flag through sysfs
Message-ID: <20090116064301.GR30821@kernel.dk>
References: <ac3eb2510901051347r6593d0fmd64702b1689716c1@mail.gmail.com> <20090106073515.GY32491@kernel.dk> <4964866D.8010503@msgid.tls.msk.ru> <1231342473.3282.19.camel@localhost.localdomain> <496ECBA0.60209@gmail.com> <87f94c370901150707h10506e99reaa40c23e32ab18c@mail.gmail.com> <1232035561.5966.48.camel@localhost.localdomain> <da824cf30901151055o2385ef74x918e8390e576d807@mail.gmail.com> <1232046039.5966.54.camel@localhost.localdomain> <da824cf30901151445q6b54c0b1nbf24f03849e1a5b3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <da824cf30901151445q6b54c0b1nbf24f03849e1a5b3@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 15 2009, Grant Grundler wrote:
> On Thu, Jan 15, 2009 at 11:00 AM, James Bottomley
> <James.Bottomley@hansenpartnership.com> wrote:
> ...
> >> Code can test for zero/nonzero or (preferably) more fine grained.
> >> e.g. "avgreadcost > 1ms" or "avgwritecost". I'm hoping this test
> >> can be abstracted into a macro.
> >
> > Um these really have to be things we can get out of the device at boot
> > time without effort (as in part of the data the device can give in a
> > single command).  I'll be shot for increasing boot time so we can work
> > out these parameters ...
> 
> No. The whole point is we should not care what it is at boot time.  It
> should be based on recent history of what is going on.  At boot time
> we read the partition table and we superblocks to mount file systems.
> That's fine to start with. So I don't see any need to add some
> synthetic test to establish initial values.
> 
> The rest of the code should work regardless of what the values start
> out to be.  This is true for the previous proposed patch too when user
> space has to decide what the right policy is.

I absolutely hate the idea of rw cost numbers. Why? Because it's a
property that's impossible to present as a single number. It depends on
so many different things, like cache settings and access pattern. If you
just want to know the avg seek time of your device, look at the reported
RPM value. Userspace can do that, because the kernel doesn't really care
a whole lot about it to be honest.

-- 
Jens Axboe

