Return-Path: <linux-kernel-owner+w=401wt.eu-S1753707AbXDCX6F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753707AbXDCX6F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 19:58:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753719AbXDCX6F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 19:58:05 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:40569 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753707AbXDCX6C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 19:58:02 -0400
Subject: Re: [PATCH] Stop pmac_zilog from abusing 8250's device numbers.
From: David Woodhouse <dwmw2@infradead.org>
To: Brad Boyer <flar@allandria.com>
Cc: Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070403212928.GA12951@cynthia.pants.nu>
References: <1175610345.2665.15.camel@shinybook.infradead.org>
	 <17938.57292.870224.132415@cargo.ozlabs.ibm.com>
	 <1175642916.10567.24.camel@shinybook.infradead.org>
	 <20070403212928.GA12951@cynthia.pants.nu>
Content-Type: text/plain
Date: Tue, 03 Apr 2007 19:57:22 -0400
Message-Id: <1175644642.10567.31.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0 (2.10.0-7.fc7.dwmw2.2) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-04-03 at 14:29 -0700, Brad Boyer wrote:
> On Tue, Apr 03, 2007 at 07:28:36PM -0400, David Woodhouse wrote:
> > I agree to a certain extent -- but then again, why should a user know or
> > care about the name /dev/ttyS0 _either_? A GUI PPP dialer should be
> > listing the available serial ports in the system whatever their names
> > are.
> 
> The moment you do serial console, the user needs to know. I would hate
> having to have console=ttyPZ0 in my kernel command line. Does that even
> work? I didn't see a change to the console setup in your patch.

Oops. Well-spotted; I forgot to change that. I'll send a replacement
patch.

> The TTY_MAJOR should have never belonged to 8250.c in the first place.
> I know it's just my opinion, but I think this major device should be
> owned by the serial core, and it shouldn't matter what chip drives each
> individual port. Each hardware driver should just register with the
> core how many ports it has and should be allocated from the same range.

Yeah, because that works out really well for Ethernet devices and SCSI
disks, with different numbers every day of the week according to what
order we happen to load drivers in. :)

> This situation is purely a side-effect of the fact that all the
> original Linux supported hardware used the 8250 driver and everyone
> who didn't use 8250 was marginalized enough that they got ignored.

Not really. Non-8250 serial ports, such as the multiport PCI cards from
Cyclades, Stallion, etc. have had their own device numbers for _years_.
With hindsight, it was a mistake for pmac_zilog ever to have been called
'ttyS0' and to have used the ttyS0 device numbers in the first place.

-- 
dwmw2

