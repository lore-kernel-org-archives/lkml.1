Return-Path: <linux-kernel-owner+w=401wt.eu-S964798AbXGSJMv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964798AbXGSJMv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 05:12:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758805AbXGSJMm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 05:12:42 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33146 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755316AbXGSJMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 05:12:40 -0400
Date: Thu, 19 Jul 2007 02:10:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Andy Whitcroft <apw@shadowen.org>, Jens Axboe <axboe@kernel.dk>,
       "James E.J. Bottomley" <James.Bottomley@SteelEye.com>,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Alessandro Rubini <rubini@vision.unipv.it>, linuxppc-dev@ozlabs.org,
       Paul Mackerras <paulus@samba.org>, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [patch 1/3] ps3: Disk Storage Driver
Message-Id: <20070719021045.c0b994ca.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.62.0707191039430.8661@pademelon.sonytel.be>
References: <20070716161539.075822000@pademelon.sonytel.be>
	<20070716162206.392129000@pademelon.sonytel.be>
	<20070718163637.3f0e0164.akpm@linux-foundation.org>
	<Pine.LNX.4.62.0707191039430.8661@pademelon.sonytel.be>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Jul 2007 10:57:53 +0200 (CEST) Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com> wrote:

> 	Hi Andrew,
> 
> On Wed, 18 Jul 2007, Andrew Morton wrote:
> > On Mon, 16 Jul 2007 18:15:40 +0200
> > Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com> wrote:
> > 
> > > From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
> > > 
> > > Add a Disk Storage Driver for the PS3:
> > 
> > Your patchset significantly hits powerpc, scsi and block.  So who gets to
> > merge this?  Jens?  James?  Paul?
> > 
> > Me, I guess ;)
> 
> As Paul is on holidays, please take it.

OK.

> The PS3 storage driver core support is
> already in mainline, but the actual drivers aren't, as Paul was waiting for
> acks from the maintainers.
> 
> BTW, do you prefer incremental patches for the comments below, or an update of
> the full patchset?

Incremental is preferred, but I convert replacement patches into
incremental patches at about 10Hz nowadays.  Whatever's easier.

(Actually, if it's a replacement patch then only I get to see the
incremental patch, and the incremental patch is more reviewer-friendly).

> I didn't have much choice, as most of it was static and I don't need the full
> libata core anyway.
> 
> If I would factor it out, any good suggestion where to put the factored out
> code?

Take it up with Jeff, please.  If you're keen.  It isn't a lot of code.

> 
> > > +static int ps3disk_remove(struct ps3_system_bus_device *_dev)
> > > +{
> > > +	struct ps3_storage_device *dev = to_ps3_storage_device(&_dev->core);
> > > +	struct ps3disk_private *priv = ps3disk_priv(dev);
> > > +
> > > +	__clear_bit(priv->gendisk->first_minor / PS3DISK_MINORS,
> > > +		    &ps3disk_mask);
> > 
> > I see no locking here which makes this __clear_bit and the above __set_bit
> > non-racy?
> 
> Were .probe()/.remove() made concurrent again? I thought that idea was dropped
> because it caused too many problems?

I don't _think_ there's any global exclusion on ->probe calls.  For a
particular driver instance it's hard to see how these thigns can run
concurrently, dunno.  I guess two hotunplugs coud happen concurrently.


