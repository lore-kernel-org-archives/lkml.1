Return-Path: <linux-kernel-owner+w=401wt.eu-S2993006AbXDDSQE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993006AbXDDSQE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 14:16:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993005AbXDDSP6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 14:15:58 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:2698 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993006AbXDDSPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 14:15:51 -0400
Date: Wed, 4 Apr 2007 19:15:32 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Theodore Tso <tytso@mit.edu>, "H. Peter Anvin" <hpa@zytor.com>,
       David Miller <davem@davemloft.net>, dwmw2@infradead.org,
       paulus@samba.org, alan@lxorguk.ukuu.org.uk, flar@allandria.com,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Stop pmac_zilog from abusing 8250's device numbers.
Message-ID: <20070404181531.GA9388@flint.arm.linux.org.uk>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	"H. Peter Anvin" <hpa@zytor.com>,
	David Miller <davem@davemloft.net>, dwmw2@infradead.org,
	paulus@samba.org, alan@lxorguk.ukuu.org.uk, flar@allandria.com,
	linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
References: <1175663999.2932.8.camel@shinybook.infradead.org> <17939.15726.114059.679277@cargo.ozlabs.ibm.com> <1175666635.2932.17.camel@shinybook.infradead.org> <20070404.011208.120446173.davem@davemloft.net> <20070404083803.GA13134@flint.arm.linux.org.uk> <20070404122154.GF31973@thunk.org> <4613CF6A.2090407@zytor.com> <20070404174153.GI31973@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070404174153.GI31973@thunk.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 04, 2007 at 01:41:53PM -0400, Theodore Tso wrote:
> On Wed, Apr 04, 2007 at 09:16:42AM -0700, H. Peter Anvin wrote:
> > One option would be to move the 8250-based serial ports, to, say, 
> > /dev/ttyN* (for National Semiconductors -- the best I could come up 
> > with) and redefine /dev/ttyS* as a serial port multiplexer which maps in 
> > all the types, for the ones that really want dynamic mapping.
> 
> > Of course, now you have the potential of aliasing, again, which tends to 
> > cause all kinds of headaches w.r.t. locking.  
> 
> That would break the 99.9% of the the world using Intel-based systems
> which only have 8250's, for very little gain. 
> 
> Like it or not, /dev/ttySx and 8250 UART's are to serial ports what
> the PCI is to system buses....

And the simple answer to this (oh I've been here before) is to leave
the existing serial allocations well alone.

Then, you allocate a new major number and device name for the dynamically
assigned space and arrange for the serial layer to map these new chardevs
to the real serial ports.

*However* you still run into the issue that you do not know how many
serial ports you will need to register a tty driver with the tty layer.
Solve that technical problem and the idea of having a single namespace
for chosen serial ports and 8250 ports suddenly becomes realistic.

Continue ignoring that problem and this thread will just grow with zero
real progress.

I'm repeating myself though.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
