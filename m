Return-Path: <linux-kernel-owner+w=401wt.eu-S1753119AbXDDQLA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753119AbXDDQLA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 12:11:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752800AbXDDQKr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 12:10:47 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:3127 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752261AbXDDQKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 12:10:43 -0400
Date: Wed, 4 Apr 2007 17:10:29 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Theodore Tso <tytso@mit.edu>, David Miller <davem@davemloft.net>,
       dwmw2@infradead.org, paulus@samba.org, alan@lxorguk.ukuu.org.uk,
       flar@allandria.com, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Stop pmac_zilog from abusing 8250's device numbers.
Message-ID: <20070404161029.GB18990@flint.arm.linux.org.uk>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	David Miller <davem@davemloft.net>, dwmw2@infradead.org,
	paulus@samba.org, alan@lxorguk.ukuu.org.uk, flar@allandria.com,
	linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
References: <1175663999.2932.8.camel@shinybook.infradead.org> <17939.15726.114059.679277@cargo.ozlabs.ibm.com> <1175666635.2932.17.camel@shinybook.infradead.org> <20070404.011208.120446173.davem@davemloft.net> <20070404083803.GA13134@flint.arm.linux.org.uk> <20070404122154.GF31973@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070404122154.GF31973@thunk.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 04, 2007 at 08:21:54AM -0400, Theodore Tso wrote:
> So if we're going to do the "Worse is Better" thing, what I'd suggest
> doing is that someone simply submit a hack so that pmac_zilog can
> steal minor numbers and use /dev/ttyS0.  I accepted the patch way back
> when I was serial maintainer; Russell ripped it out when he became the
> serial maintainer; but now that he's no longer the serial maintainer,
> he doesn't get to complain about that any more :-)

The problem with that approach was that it was being extended to more
and more drivers in the ARM world, creating an #ifdef mess in the
serial driver.

Moreover, it provided *no* way to select an 8250-based serial port in
the presence of a "foreign" port claiming the ttyS console namespace.
Utterly unacceptable when you have a real environment of mixed serial
port types.

IOW, it was utterly broken.  It prevented me from doing the things I
wanted to do.

The only real answer is to fix the problem *properly*.  Hacks just end
up breaking peoples setups.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
