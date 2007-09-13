Return-Path: <linux-kernel-owner+w=401wt.eu-S1754226AbXIMHtR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754226AbXIMHtR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 03:49:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752078AbXIMHtH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 03:49:07 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:33932 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751709AbXIMHtG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 03:49:06 -0400
Date: Thu, 13 Sep 2007 08:47:42 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michael Westermann <michael@dvmwest.de>, linux-kernel@vger.kernel.org
Subject: Re: DTR/DSR Patch
Message-ID: <20070913074742.GB11938@flint.arm.linux.org.uk>
References: <20070831131741.GA14569@dvmwest.dvmwest.de> <20070912173817.7ca5c3dc.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070912173817.7ca5c3dc.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2007 at 05:38:17PM -0700, Andrew Morton wrote:
> On Fri, 31 Aug 2007 15:17:41 +0200
> Michael Westermann <michael@dvmwest.de> wrote:
> 
> > Hello,
> > 
> > I make driver for Point of Sale Printer, a wide range of Printer use
> > only a DTR/DSR hardware-handshaking. When I use a handshaking in the
> > userspace, the Printr has a overrun problem and our customer has a
> > problem with the tax office.
> > 
> > my Patch relaize a simple DTR/DSR handhake with a small change of the
> > code. The change auf the userspace is very simple. e.g.
> > 
> > 
> > cflags |= CDTRDSR;
> > 
> > The change of the stty tool at 2 lines.
> > 
> 
> googling for CDTRDSR is useful.  I see from
> http://lkml.org/lkml/2006/12/10/49 that Russell was generally supportive,
> but requested changes which afaict you have implemented here?

Partially implemented - my point 1 seems to have been addressed but not
point 2.  Point 2 is rather important, otherwise you can end up with a
port in stopped mode with no way to get it transmitting.

Also, it doesn't seem to be tweaking the DTR signal at all, so how does
it tell the remote end to stop transmitting?

Essentially, the author needs to search for CRTSCTS in serial_core.c and
*carefully* consider whether they need to modify those places as well.
I stress carefully, because at the moment we start the tty whenever
we move from CRTSCTS to no CRTSCTS.  If you're moving CRTSCTS->CDTRDSR
then you only want to do this iff DSR is asserted.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
