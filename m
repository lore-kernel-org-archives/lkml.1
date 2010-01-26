Return-Path: <linux-kernel-owner+w=401wt.eu-S1753760Ab0AZCkx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753760Ab0AZCkx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 21:40:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752548Ab0AZCkw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 21:40:52 -0500
Received: from solo.fdn.fr ([80.67.169.19]:42448 "EHLO solo.fdn.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751084Ab0AZCkv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 21:40:51 -0500
X-Greylist: delayed 820 seconds by postgrey-1.27 at vger.kernel.org; Mon, 25 Jan 2010 21:40:51 EST
Date: Tue, 26 Jan 2010 03:40:49 +0100
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: William Hubbs <w.d.hubbs@gmail.com>, linux-kernel@vger.kernel.org,
       linux-serial@vger.kernel.org, gregkh@suse.de,
       Chris Brannon <cmbrannon79@gmail.com>, Kirk Reiser <kirk@reisers.ca>
Subject: Re: request for assistance:  accessing ttys from kernel space
Message-ID: <20100126024049.GQ21492@const.famille.thibault.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	William Hubbs <w.d.hubbs@gmail.com>, linux-kernel@vger.kernel.org,
	linux-serial@vger.kernel.org, gregkh@suse.de,
	Chris Brannon <cmbrannon79@gmail.com>,
	Kirk Reiser <kirk@reisers.ca>
References: <20100126020203.GA23551@linux1> <20100126021306.16809e71@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100126021306.16809e71@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox, le Tue 26 Jan 2010 02:13:06 +0000, a écrit :
> > What I would like to discuss is how we can access ttys from kernel
> > space.  If we could do this, it would definitely make things much easier
> > for us in speakup.
> 
> Basically - use a line discipline, that lets you sit on top of a tty and
> interact with the hardware

The problem is that to my knowledge, to setup a line discipline, you
need to already have a daemon opening /dev/ttySomething and set up the
line discipline.  You could as well just move all the speakup code into
the daemon.  The point of speakup is to have feedback even when it is
not possible to run such daemon.

Is there another way to set up a line discipline from the kernel itself
without the need from userland intervention, even before any / is
mounted?

> > We need to be able to access the ttys as early as possible in the boot
> > sequence.  Any help, suggestions, or guidance you could give us would be
> > greatly appreciated.
> 
> We may need to make some special provision for that aspect - we already
> do so for the early serial console support.

Maybe the early serial console support layer could be extended a bit so
speakup can use it first during the boot?  For now it's quite tied to
just printing the printk logs. drivers/accessibility/braille_console.c
does manage do make something else, but it happens that the
serial_core.c's uart_console_write puts additional \rs before \ns, which
can be a problem.

Also, for proper speech flow, speakup would need to be able to read
characters from the device.

> The ldisc is the start point then there may be some bits that need to
> be extended around it.

To me it seems like the only missing bit is how to setup the line
discipline from the kernel itself (i.e. how to "open" the device?) as
soon as it becomes safe to rely on the tty layer.

> A bigger problem is going to be the fact non USB serial is vanishing bit
> by bit.

Actually that's precisely why the speakup community is pressing for
proper tty support, in order to get PCI & USB support :)

> We do have a USB console but it's truely crazy stuff and extending it
> scares me 8)

Ideally that'll needed :/

Samuel
