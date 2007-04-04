Return-Path: <linux-kernel-owner+w=401wt.eu-S1766908AbXDDTv2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766908AbXDDTv2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 15:51:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766906AbXDDTv1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 15:51:27 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:50475 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1766908AbXDDTvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 15:51:25 -0400
Subject: Re: [PATCH] Stop pmac_zilog from abusing 8250's device numbers.
From: David Woodhouse <dwmw2@infradead.org>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: Theodore Tso <tytso@mit.edu>, "H. Peter Anvin" <hpa@zytor.com>,
       David Miller <davem@davemloft.net>, paulus@samba.org,
       alan@lxorguk.ukuu.org.uk, flar@allandria.com, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070404181531.GA9388@flint.arm.linux.org.uk>
References: <1175663999.2932.8.camel@shinybook.infradead.org>
	 <17939.15726.114059.679277@cargo.ozlabs.ibm.com>
	 <1175666635.2932.17.camel@shinybook.infradead.org>
	 <20070404.011208.120446173.davem@davemloft.net>
	 <20070404083803.GA13134@flint.arm.linux.org.uk>
	 <20070404122154.GF31973@thunk.org> <4613CF6A.2090407@zytor.com>
	 <20070404174153.GI31973@thunk.org>
	 <20070404181531.GA9388@flint.arm.linux.org.uk>
Content-Type: text/plain
Date: Wed, 04 Apr 2007 15:50:15 -0400
Message-Id: <1175716215.2774.52.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0 (2.10.0-7.fc7.dwmw2.2) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-04-04 at 19:15 +0100, Russell King wrote:
> And the simple answer to this (oh I've been here before) is to leave
> the existing serial allocations well alone.
> 
> Then, you allocate a new major number and device name for the dynamically
> assigned space and arrange for the serial layer to map these new chardevs
> to the real serial ports.
> 
> *However* you still run into the issue that you do not know how many
> serial ports you will need to register a tty driver with the tty layer.
> Solve that technical problem and the idea of having a single namespace
> for chosen serial ports and 8250 ports suddenly becomes realistic.
> 
> Continue ignoring that problem and this thread will just grow with zero
> real progress.
>
> I'm repeating myself though.

And you always will be. The amount of pain involved in implementing
this, just so that people can call their serial port 'ttyS0', is _far_
more than it's worth. It could be done, but it's a completely pointless
waste of time and effort. 

Separate device names work just fine. It's simpler, and for many people
it's preferable because it gives more repeatability to device names.
With the current patch I _know_ that ttyPZ0 is the built-in z8530
controller and ttyS0 is the PCMCIA modem, for example.

The argument that people shouldn't need to know what type of port they
have is a red herring. They're going to have to work out what _number_
it is anyway, and sharing the major numbers just makes that _harder_.
 
Graphical tools are also a red herring -- if the graphical tools are
broken and don't show non-8250 ports, then they can be fixed.

-- 
dwmw2

