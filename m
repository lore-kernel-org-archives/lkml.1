Return-Path: <linux-kernel-owner+w=401wt.eu-S933267AbXG2SE3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933267AbXG2SE3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 14:04:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764184AbXG2SEU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 14:04:20 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:45379 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764161AbXG2SET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 14:04:19 -0400
Date: Sun, 29 Jul 2007 19:03:07 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Shaohua Li <shaohua.li@intel.com>, Yinghai Lu <yhlu.kernel@gmail.com>,
       =?iso-8859-1?Q?S=E9bastien_Dugu=E9?= <sebastien.dugue@bull.net>,
       linux-kernel <linux-kernel@vger.kernel.org>, ambx1@neo.rr.com,
       akpm@linux-foundation.org, lenb@kernel.org, mjg59@srcf.ucam.org,
       castet.matthieu@free.fr
Subject: Re: commit 7e92b4fc34 - x86, serial: convert legacy COM ports to platform devices - broke my serial console
Message-ID: <20070729180307.GC25431@flint.arm.linux.org.uk>
References: <20070724162805.76ea8328@frecb000686.frec.bull.fr> <86802c440707251737p3be3ae69qe3f91282bec8984a@mail.gmail.com> <1185416466.31345.1.camel@sli10-conroe.sh.intel.com> <200707271217.00164.bjorn.helgaas@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707271217.00164.bjorn.helgaas@hp.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 27, 2007 at 12:16:59PM -0600, Bjorn Helgaas wrote:
> For example, 8250_pnp could have rules like "COM1 should always
> be ttyS0" or "a port at 0x3f8 should always be ttyS0."

In which case register via the legacy ports first, and then register
PNP ports.  If the PNP ports correspond with legacy ports, they will
re-use those slots.

So, if we register 0x3f8 first (which ends up as ttyS0), followed by
0x2f8 (ttyS1) and then PNP tries to register a port at 0x2f8 then
0x3f8, you'll still end up with 0x3f8 being ttyS0 and 0x2f8 as ttyS1.

> That doesn't help with Yinghai's PCI root ordering issue, of course.
> But I hope that can be addressed with udev, because there's not so
> much need for a persistent kernel name.  If that's not enough, can
> you explain more about the problem?

However, aren't PNP serial ports attached to separate PNP devices?  If
so, udev can work it out already - they just need to look at the
backing device associated with the serial port.  For legacy ports that'll
be serial8250.0.  For PNP, it'll be some PNP device.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
