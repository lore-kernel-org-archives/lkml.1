Return-Path: <linux-kernel-owner+w=401wt.eu-S1752453AbYKXBpY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752453AbYKXBpY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 20:45:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751570AbYKXBpJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 20:45:09 -0500
Received: from ns2.suse.de ([195.135.220.15]:54999 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751310AbYKXBpJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 20:45:09 -0500
Date: Sun, 23 Nov 2008 17:40:54 -0800
From: Greg KH <gregkh@suse.de>
To: "Hans J. Koch" <hjk@linutronix.de>
Cc: linux-kernel@vger.kernel.org, Mike Frysinger <vapier@gentoo.org>,
       John Ogness <jogness@linutronix.de>,
       Benedikt Spranger <b.spranger@linutronix.de>
Subject: Re: [PATCH RFC] UIO: Pass information about ioports to userspace
Message-ID: <20081124014054.GA14143@suse.de>
References: <20081123121419.GA3087@local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081123121419.GA3087@local>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 23, 2008 at 01:14:20PM +0100, Hans J. Koch wrote:
> Devices sometimes have memory where all or parts of it can not be mapped to
> userspace. But it might still be possible to access this memory from
> userspace by other means. An example are PCI cards that advertise not only
> mappable memory but also ioport ranges. On x86 architectures, these can be
> accessed with ioperm, iopl, inb, outb, and friends. Mike Frysinger (CCed)
> reported a similar problem on Blackfin arch where it doesn't seem to be easy
> to mmap non-cached memory but it can still be accessed from userspace.
> 
> This patch allows kernel drivers to pass information about such ports to
> userspace. Similar to the existing mem[] array, it adds a port[] array to
> struct uio_info. Each port range is described by start, size, and porttype.
> 
> If a driver fills in at least one such port range, the UIO core will simply
> pass this information to userspace by creating a new directory "portio"
> underneath /sys/class/uio/uioN/. Similar to the "mem" directory, it will
> contain a subdirectory (portX) for each port range given.

This is good, but it would really be nice to provide a way for userspace
to access individual ports without having to have access to all ports in
the system.  Lots of times we don't want to give root privileges to some
programs that only need to read and write simple data to a single
device.

thanks,

greg k-h
