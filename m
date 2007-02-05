Return-Path: <linux-kernel-owner+w=401wt.eu-S933379AbXBETVP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933379AbXBETVP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 14:21:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933400AbXBETVP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 14:21:15 -0500
Received: from wr-out-0506.google.com ([64.233.184.226]:29729 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933379AbXBETVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 14:21:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=cFpM6Qhd4JldZBfqIKuPmPLE8zvxHv0/Eb/wvrIUKpyj1mqEbmXGoC3IKR6hRfPIMx364Z3WRY1b8yVN+bnahMCW/BC3WYagAze6tdomksmKxWE+DtLAvrLUDLNDaeW2NBraFfH0sZXgqBcpj8omuzgiocCyzf+HmczSX7aUHy8=
Message-ID: <8d158e1f0702051121w6e8a840dm1044ca73d3f6f47@mail.gmail.com>
Date: Mon, 5 Feb 2007 20:21:11 +0100
From: "Patrick Ale" <patrick.ale@gmail.com>
To: "Mark Lord" <lkml@rtr.ca>
Subject: Re: hdparm for lib_pata
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <45C773D6.3010009@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <8d158e1f0702030041xaa34440r125a39a85d498f4c@mail.gmail.com>
	 <45C773D6.3010009@rtr.ca>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

\
> Userspace PIO mode changes are NOT a good idea,
> and I doubt that libata would want to support that feature.
> The "-d" flag (enable/disable DMA) is currently not implemented
> by libata, though there may be a /sys/.. attribute for it (?).
>
Okay but... the driver itself does implement the calls, maybe in
another way but it does switch from DMA to PIO. At boot time it uses
UDMA100 and after some transfer speed downgrades even tells me how
there is no lower mode available (which means its running in PIO mode
1 I guess).

I agree that its not a good idea, and in normal cases, you wont even
need it cause your hardware works properly. I had a closer look at my
old kernel logs, and different from the old ata drivers, the new
libsata drivers probe every disk for its UDMA capabilities and sets
them per drive, also on a bus reset, rather than resetting the entire
bus and using the same transfer setting for all drives on that bus
(which is what i saw happening with my  promise IDE card and the old
IDE drivers.

So, with the new drivers, one failing disk doesnt drag the other disk
with him into PIO mode, at least, this is how I see things on my
screen and how I experience it.

The disk that does fall back to PIO mode probably does have  a serious
problem or, in my case, the entire southbridge is overheated causing
lots of PCI problems (thanks Robert, for the point out, I changed the
powersuply and the southbridge fan and all works great now).

So, yeah, in general I like the idea of being in control of my
machine, how dangerous that might be, but in the case of libsata and
my experience with the new pata drivers so far, the driver knows
what's best for me and acts like it and building some overriding
controls for userspace just will break things, if not totaly destroy
it.

Actually all problems I had so far with libsata were pointable to my
stupidity (hello CONFIG_DEV_SD) or hardware that was totaly failing.
So, I give two thumbs up to the new libsata/pata drivers, I really
like the way they work and I truely see advantages using them over the
old IDE drivers, not in the last place cause it is much easier to see
disk/bus problems now since I find the ATA messages in the kernel log
regarding what is done with my disks way more clear.

So Alan, Robert, everybody else who helped me with migrating to
libsata from the old IDE drivers, thanks a lot, your help was and is
highly appriciated.

Patrick
