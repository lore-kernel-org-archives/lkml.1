Return-Path: <linux-kernel-owner+w=401wt.eu-S1755472AbYIJVF3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755472AbYIJVF3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 17:05:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752478AbYIJVFT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 17:05:19 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52536 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752253AbYIJVFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 17:05:18 -0400
Date: Wed, 10 Sep 2008 14:04:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Miller <davem@davemloft.net>
Cc: david-b@pacbell.net, James.Bottomley@hansenpartnership.com,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-parisc@vger.kernel.org, alessandro.zummo@towertech.it,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] fix RTC_CLASS regression with PARISC
Message-Id: <20080910140417.bc35c199.akpm@linux-foundation.org>
In-Reply-To: <20080908.195235.200905674.davem@davemloft.net>
References: <200809081629.21125.david-b@pacbell.net>
	<20080908.164427.216880550.davem@davemloft.net>
	<200809081755.26148.david-b@pacbell.net>
	<20080908.195235.200905674.davem@davemloft.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 08 Sep 2008 19:52:35 -0700 (PDT)
David Miller <davem@davemloft.net> wrote:

> From: David Brownell <david-b@pacbell.net>
> Date: Mon, 8 Sep 2008 17:55:25 -0700
> 
> > On Monday 08 September 2008, David Miller wrote:
> > > From: David Brownell <david-b@pacbell.net>
> > > Date: Mon, 8 Sep 2008 16:29:20 -0700
> > > 
> > > > That said, there's a bit of unresolved stuff around NTP hooks
> > > > in the kernel.  Some patches are pending to let thtem work with
> > > > the RTC framework -- where writing an RTC may need to sleep,
> > > > for example because the RTC is on an I2C or SPI bus.  And
> > > > then there's the discussion of whether that shouldn't all be
> > > > handled by NTPD anyway, no special kernel support desired.
> > > > Alessandro has opinions there.  ;)
> > > 
> > > My update_persistent_clock() on sparc64 is:
> > > 
> > > int update_persistent_clock(struct timespec now)
> > > {
> > > 	struct rtc_device *rtc = rtc_class_open("rtc0");
> > 
> > I'd be tempted to cache that ... notice how you never
> > close it, too.  That will goof lots of refcounts...
> 
> Well if I cache it then we'll hold it forever and that's not
> so nice right?
> 
> I'm going to put the missing rtc_close() in there for now to
> fix the leak.
> 
> I'm happy to cache this if you think it's warranted, but then
> this is like saying that the refcount doesn't matter :-)
> 
> > =============== CUT ON THE DOTTED LINE ==================
> > Subject: ntp: let update_persistent_clock() sleep
> > From: "Maciej W. Rozycki" <macro@linux-mips.org>
> 
> I see, as Paul mentioned this is needed for stuff like RTCs
> behind I2C.
> 
> This change isn't in Linus's tree yet.

Should it be?

Its current status is: stuck in -mm.  I've sent it to Thomas a couple
of times marked "for 2.6.27?" and he might have applied it now (I'm a
few days behind, waiting for linux-next to start up again).

It was not included in Thomas's recent mainline pull request:

From: Thomas Gleixner <tglx@tglx.de>
Subject: [GIT pull] timer updates for 2.6.27
Date: Tue, 9 Sep 2008 22:32:39 +0200 (CEST)


