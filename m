Return-Path: <linux-kernel-owner+w=401wt.eu-S1756956AbXK1Rxl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756956AbXK1Rxl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 12:53:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754164AbXK1Rxd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 12:53:33 -0500
Received: from smtp-103-wednesday.nerim.net ([62.4.16.103]:49680 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753919AbXK1Rxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 12:53:33 -0500
Date: Wed, 28 Nov 2007 18:53:29 +0100
From: Jean Delvare <khali@linux-fr.org>
To: "Jon Smirl" <jonsmirl@gmail.com>
Cc: "Lennart Sorensen" <lsorense@csclub.uwaterloo.ca>,
       "Russell King" <rmk+kernel@arm.linux.org.uk>,
       "Adrian Bunk" <bunk@kernel.org>, i2c@lm-sensors.org,
       "Lennert Buytenhek" <buytenh@wantstofly.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [i2c] [2.6 patch] some overdue I2C driver removal
Message-ID: <20071128185329.3772a738@hyperion.delvare>
In-Reply-To: <9e4733910711280943t75564912m805cfdb2fe099528@mail.gmail.com>
References: <20071024162528.GX30533@stusta.de>
	<20071024164347.GN4003@csclub.uwaterloo.ca>
	<20071128112357.3828d469@hyperion.delvare>
	<20071128173022.GD2308@csclub.uwaterloo.ca>
	<9e4733910711280943t75564912m805cfdb2fe099528@mail.gmail.com>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Nov 2007 12:43:00 -0500, Jon Smirl wrote:
> On 11/28/07, Lennart Sorensen <lsorense@csclub.uwaterloo.ca> wrote:
> > On Wed, Nov 28, 2007 at 11:23:57AM +0100, Jean Delvare wrote:
> > > There's no driver to write (i2c-gpio is the driver). Instead, the
> > > scx200 platform needs to implement the standard GPIO API. I don't think
> > > that it has happened yet, and last time this was discussed, someone
> > > (can't remember who, sorry), complained that the GPIO API "sucked" and
> > > that the scx200 platform would not be updated to use it. I didn't buy
> > > the claim due to a lack of argumentation and the fact that the GPIO
> > > infrastructure seems to work well enough for many other platforms.
> > >
> > > As far as I can see, the ixp2000 platform also doesn't implement the
> > > standard GPIO API yet, so of the 3 drivers that are about to be
> > > removed, only i2c-ixp4xx can be removed without functionality loss at
> > > the moment. Lennert, Russell, are there any plans to convert the
> > > ixp2000 platform to use the generic GPIO layer?
> > >
> > > Maybe I shouldn't have added this entry in feature-removal-schedule.txt
> > > in the first place: these drivers should ideally be dropped in favor of
> > > i2c-gpio, but it can only happen for platforms that implement the
> > > standard GPIO API. As I am not the one who will convert these
> > > platforms, and some of them might as well never be converted (I don't
> > > know how active they are nowadays), there's not much I can do.
> >
> > Well if I get a chance I might try to do it for the scx200 at some point
> > (since I do use it) although given the current i2c driver works just
> > fine and I have no need for the rest of the gpio lines what so ever
> > there isn't that much insentive to do so yet.
> >
> > Removing the existing i2c driver would seem like a mistake at this time
> > though.
> 
> Hasn't their been a one year notice that these drivers were going to
> be removed? How about removing them and putting them into a tarball on
> the i2c web site with a note explaining about how they need to be
> updated to use the gpio driver? Then if someone really wants to use
> the old drivers they can use them out of tree.

There's no "i2c web site". And no, I'm not breaking people's setup for
fun. The drivers in question are small, I don't care that much if they
stick around. If we can remove them (as is the case for i2c-ixp4xx),
great, let's go, but if not, there's really no reason to make
gratuitous trouble.

The patch I have in my tree now removes i2c-ixp4xx and leaves
i2c-ixp2000 and scx200_i2c alone. They can always be removed later if
the respective platforms are updated to use the generic GPIO layer.

-- 
Jean Delvare
