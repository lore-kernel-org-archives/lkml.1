Return-Path: <linux-kernel-owner+w=401wt.eu-S933056AbXCHUkj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933056AbXCHUkj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 15:40:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933086AbXCHUki
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 15:40:38 -0500
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:4568 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933065AbXCHUkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 15:40:37 -0500
Date: Thu, 8 Mar 2007 20:40:21 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Robin Getz <rgetz@blackfin.uclinux.org>
Cc: Oleksiy Kebkal <kebkal@gmail.com>, Krzysztof Halasa <khc@pm.waw.pl>,
       Mike Frysinger <vapier.adi@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-serial@vger.kernel.org
Subject: Re: should RTS init in serial core be tied to CRTSCTS
Message-ID: <20070308204020.GE30023@flint.arm.linux.org.uk>
Mail-Followup-To: Robin Getz <rgetz@blackfin.uclinux.org>,
	Oleksiy Kebkal <kebkal@gmail.com>, Krzysztof Halasa <khc@pm.waw.pl>,
	Mike Frysinger <vapier.adi@gmail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-serial@vger.kernel.org
References: <8bd0f97a0703011603m794e00f5x875eb68ad0db05de@mail.gmail.com> <200703080844.32157.rgetz@blackfin.uclinux.org> <20070308134800.GA30023@flint.arm.linux.org.uk> <200703081523.39698.rgetz@blackfin.uclinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200703081523.39698.rgetz@blackfin.uclinux.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 08, 2007 at 03:23:39PM -0500, Robin Getz wrote:
> On Thu 8 Mar 2007 08:48, Russell King pondered:
> > On Thu, Mar 08, 2007 at 08:44:31AM -0500, Robin Getz wrote:
> > > That would let you change things are run time, but the problem is at
> > > boot time. A default setting needs to be set, so when things initialize,
> > > and proc does not exist yet, it is still set properly...
> >
> > I disagree.  "proc does not exist yet" - the only time that applies is
> > long before userspace as active.
> 
> Right - We both agree - And setting console=/dev/null in the bootargs still 
> does not help.

Ok, good.

> When the kernel initializes the UART Port, it asserts RTS - which confuses
> the host it is attached to (in this case, the Linux system is the serial 
> peripheral).

... which occurs /after/ userspace is up and running, when sysfs is
available.  So putting it in sysfs is reasonable.

> How about adding a module_param to serial core, which the default is to
> assert RTS (as is today), and someone (like me) can override with
> serial_core.RTS=0

So all ports change behaviour with a single parameter?  That'll stop
NULL modem cables with hardware flow control enabled working on other
ports without compensatory tweaking.

No, doing a system-wide change like that is _not_ a solution - it just
moves the problem elsewhere.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
