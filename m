Return-Path: <linux-kernel-owner+w=401wt.eu-S1757792AbZJLSqt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757792AbZJLSqt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 14:46:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757733AbZJLSqs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 14:46:48 -0400
Received: from bamako.nerim.net ([62.4.17.28]:64381 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757687AbZJLSqr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 14:46:47 -0400
Date: Mon, 12 Oct 2009 20:45:58 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: LKML <linux-kernel@vger.kernel.org>, Zhang Rui <rui.zhang@intel.com>,
       Rodolfo Giometti <giometti@enneenne.com>,
       "Michele De Candia (VT)" <michele.decandia@valueteam.com>,
       Linux I2C <linux-i2c@vger.kernel.org>, Pavel Machek <pavel@suse.cz>,
       corentin.chary@gmail.com
Subject: Re: [PATCH] ALS: TSL2550 driver move from i2c/chips
Message-ID: <20091012204558.0e15788d@hyperion.delvare>
In-Reply-To: <4AD36114.50108@cam.ac.uk>
References: <4ACF4AC6.7070802@cam.ac.uk>
	<20091010185200.671846c5@hyperion.delvare>
	<4AD33ADB.4000500@cam.ac.uk>
	<20091012175216.6d844623@hyperion.delvare>
	<4AD36114.50108@cam.ac.uk>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Oct 2009 18:02:12 +0100, Jonathan Cameron wrote:
> Jean Delvare wrote:
> > The name size really isn't an issue. You won't notice 16 bytes instead
> > of 9. And it's not like we'll have millions of these devices.
>
> I agree, it's merely a question of picking some suitable limit. IDR's
> on a 64 bit box will do something in the ball park of 2e18 which might
> be an excessive limit ;) I'll leave this be for next version on basis

In all honesty, I don't expect als device names of ~30 chars to cause a
memory shortage to any machine any time soon. I'm not claiming that we
are likely to see machines with 2e18 light sensors any time soon
either. All I'm saying is that arbitrary limits should be avoided when
possible.

> (...)
> Counter argument placed (cc'd Pavel and Corentin for this point)
> is that having a generic name, e.g. hwmon0 and a name field in sysfs
> is superfluous when we can combine the two.

Counter counter argument is that this then makes it impossible to have
different subtypes and differentiate by name. See the input subsystem
for an example: they have input%d and event%d devices, for two
different purposes. It's very easy for both users and user-space
software to see what is what with this naming scheme. Other examples of
this include video4linux and sound classes. As a matter of fact,
looking at all classes that are in use on my machine, I can't see any
class which leaves device naming up to its implementing drivers (except
apparently mem and misc, but you'll have to agree that these are very
special classes.)

As a summary, I can't see any reason to come up with a new way to
handle class device names in the als class, when all other classes
around have already agreed on a standard approach.

> > (...)
> > The length is fine until someone needs more sensors, changes
> > TSL2550_DEV_MAX to 16, and then the code crashes and nobody knows why.
> > You can't assume that other developers won't touch your code. Thus it
> > is much better to handle a given limitation in a single place. Here you
> > can simply check the value returned by snprintf() and then you know if
> > your name was correctly set.
> > 
> > Again, not that it matters, because the name buffer should simply be
> > large enough that it always fits.
>
> That's awfully big if we don't place some arbitrary limit on number of

Where "awfully big" is like 30 bytes. Wow, I'm frightened :)

> devices. I'm happy to pick another one, but one is needed. Clearly the
> code can be made more resilient to the sort of change you mention as well
> and I'll do that if this isn't moved into the core.

Whatever limit you end up with, it should be set by the buffer size,
rather than a separate constant.

-- 
Jean Delvare
