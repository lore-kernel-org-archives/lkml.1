Return-Path: <linux-kernel-owner+w=401wt.eu-S1756869AbZBPIIK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756869AbZBPIIK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 03:08:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754675AbZBPIHy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 03:07:54 -0500
Received: from mk-filter-1-a-1.mail.uk.tiscali.com ([212.74.100.52]:8489 "EHLO
	mk-filter-1-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754608AbZBPIHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 03:07:53 -0500
X-Trace: 150770032/mk-filter-1.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/80.44.176.196/None/adrian@newgolddream.dyndns.info
X-SBRS: None
X-RemoteIP: 80.44.176.196
X-IP-MAIL-FROM: adrian@newgolddream.dyndns.info
X-MUA: Evolution 2.24.3 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao4FAOqtmElQLLDE/2dsb2JhbACBbs16hBwG
X-IronPort-AV: E=Sophos;i="4.38,215,1233532800"; 
   d="scan'208";a="150770032"
Subject: Re: [RFC][PATCH] filesystem: VMUFAT filesystem
From: Adrian McMenamin <adrian@newgolddream.dyndns.info>
To: Paul Mundt <lethal@linux-sh.org>
Cc: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, linux-sh@vger.kernel.org
In-Reply-To: <20090216031523.GA16824@linux-sh.org>
References: <1234646219.6609.37.camel@localhost.localdomain>
	 <20090216031523.GA16824@linux-sh.org>
Content-Type: text/plain
Date: Mon, 16 Feb 2009 08:07:23 +0000
Message-Id: <1234771643.6628.8.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-02-16 at 12:15 +0900, Paul Mundt wrote:
> On Sat, Feb 14, 2009 at 09:16:59PM +0000, Adrian McMenamin wrote:
> > +#include <linux/module.h>
> > +#include <linux/init.h>
> > +#include <linux/fs.h>
> > +#include <linux/slab.h>
> > +#include <linux/blkdev.h>
> > +#include <linux/buffer_head.h>
> > +#include <linux/mtd/mtd.h>
> > +#include "vmufat.h"
> > +
> Why do you have an mtd include?


Ah, a left over from when this was first written and tied to the
hardware

...
> > +
> > +	bh->b_data[z + 0x10] = bcd_from_u8(century);
> > +	u8year = year + 80;
> > +	if (u8year > 99)
> > +		u8year = u8year - 100;
> > +
> > +	bh->b_data[z + 0x11] = bcd_from_u8(u8year);
> > +	bh->b_data[z + 0x12] = bcd_from_u8((__u8) month);
> > +	bh->b_data[z + 0x13] =
> > +	    bcd_from_u8((__u8) day - day_n[month - 1] + 1);
> > +	bh->b_data[z + 0x14] =
> > +	    bcd_from_u8((__u8) ((unix_date / 3600) % 24));
> > +	bh->b_data[z + 0x15] = bcd_from_u8((__u8) ((unix_date / 60) % 60));
> > +	bh->b_data[z + 0x16] = bcd_from_u8((__u8) (unix_date % 60));
> > +
> This should be abstracted out in to a separate function, and you can get
> rid of most of this hand-rolled time mangling by using the rtc lib
> routines.
> 
> Additionally, all of the bcd conversion code is superfluous, since you
> can include linux/bcd.h and use bin2bcd and bcd2bin directly.
> 

Another left over. In the 2.4 kernel there were several bespoke bcd
conversion functions and I just wrote another one and didn't even think
to check if a generic one had been added to the 2.6 kernel.


> > +	sb->s_blocksize_bits = log_2;
> 
> ilog2()?


Again, from what I can see this wasn't available kernel wide back in the
2.4 days.
> 
> I've tried to skip over the bits already noted by Evgeniy, but you may
> have already fixed up some of the issues noted above anyways.
> 
> Also, in the next iteration of this patch, please do not break the Cc
> list and send multiple times to different lists, it makes it very
> difficult to follow what is going on, especially if the threads of
> conversation diverge.


Thanks. I have already fixed some of this, as you say. Will get on with
tidying the rest of it.

