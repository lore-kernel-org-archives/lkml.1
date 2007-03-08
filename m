Return-Path: <linux-kernel-owner+w=401wt.eu-S1751906AbXCHO3E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751906AbXCHO3E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 09:29:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751975AbXCHO3E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 09:29:04 -0500
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:4156 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751965AbXCHO3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 09:29:00 -0500
Date: Thu, 8 Mar 2007 14:28:49 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Oleksiy Kebkal <kebkal@gmail.com>
Cc: Robin Getz <rgetz@blackfin.uclinux.org>, Krzysztof Halasa <khc@pm.waw.pl>,
       Mike Frysinger <vapier.adi@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-serial@vger.kernel.org
Subject: Re: should RTS init in serial core be tied to CRTSCTS
Message-ID: <20070308142849.GC30023@flint.arm.linux.org.uk>
Mail-Followup-To: Oleksiy Kebkal <kebkal@gmail.com>,
	Robin Getz <rgetz@blackfin.uclinux.org>,
	Krzysztof Halasa <khc@pm.waw.pl>,
	Mike Frysinger <vapier.adi@gmail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-serial@vger.kernel.org
References: <8bd0f97a0703011603m794e00f5x875eb68ad0db05de@mail.gmail.com> <200703071019.55896.rgetz@blackfin.uclinux.org> <57354eff0703071330k2395e9c8n58e12f2111dcb25a@mail.gmail.com> <200703080844.32157.rgetz@blackfin.uclinux.org> <20070308134800.GA30023@flint.arm.linux.org.uk> <57354eff0703080623r2f7f88c3r7ddf6381061cbd73@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <57354eff0703080623r2f7f88c3r7ddf6381061cbd73@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 08, 2007 at 03:23:49PM +0100, Oleksiy Kebkal wrote:
> 2007/3/8, Russell King <rmk+lkml@arm.linux.org.uk>:
> >On Thu, Mar 08, 2007 at 08:44:31AM -0500, Robin Getz wrote:
> >> On Wed 7 Mar 2007 16:30, Oleksiy Kebkal pondered:
> >> > 2007/3/7, Robin Getz <rgetz@blackfin.uclinux.org>:
> >> > > Right - so the question is where to manage the default state? I was
> >> > > thinking in the resource might be a good idea, but there isn't 
> >really a
> >> > > good place for it. (You could re-use some bits if flags, but I think 
> >that
> >> > > would not be a good idea).
> >> >
> >> > /proc/tty/driver/uartN/settings?
> >> >
> >>
> >> That would let you change things are run time, but the problem is at boot
> >> time. A default setting needs to be set, so when things initialize, and 
> >proc
> >> does not exist yet, it is still set properly...
> >
> >I disagree.  "proc does not exist yet" - the only time that applies is
> >long before userspace as active.
> >
> >As I've said already, having a console on the same port as your application
> >program is just asking for trouble.  All bets are off - the kernel _will_
> >corrupt your data stream in random places.
> >
> >Don't do it - it will _NEVER_ be reliable.
> >
> >Never, ever, mix kernel consoles with application serial ports.
> 
> Ok. I understand now one of the sources of misunderstanding. I don't
> want to mix console and application serial port.

It's not a misunderstanding if you realise that email is threaded and
you _follow_ the individual threads.  Robin has a similar concern to
you but _additionally_ wants something that you don't.

So really to remove the "confusion" from this discussion you should
avoid trying to correct replies to Robin's emails.

> The other problem is how to open serial port with correct settings
> _after_ booting. In this case /proc could be applicable, isn't it?

Doubt it with todays opinions about /proc contents.  Probably more
appropriate in sysfs, if someone can be bothered to do the work
required to properly integrate tty and sysfs.

Don't look at me; I'm not doing very much with serial anymore.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
