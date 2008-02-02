Return-Path: <linux-kernel-owner+w=401wt.eu-S934054AbYBBTZN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934054AbYBBTZN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 14:25:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753041AbYBBTYz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 14:24:55 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:35632 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751503AbYBBTYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 14:24:53 -0500
Date: Sat, 2 Feb 2008 11:19:30 -0800
From: Greg KH <greg@kroah.com>
To: Christer Weinigel <christer@weinigel.se>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: mark USB drivers as being GPL only
Message-ID: <20080202191930.GA19826@kroah.com>
References: <20080125180232.GA4613@kroah.com> <20080202123710.42df1aa0@weinigel.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080202123710.42df1aa0@weinigel.se>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 02, 2008 at 12:37:10PM +0100, Christer Weinigel wrote:
> On Fri, 25 Jan 2008 10:02:32 -0800
> Greg KH <greg@kroah.com> wrote:
> 
> > FYI, this is a patch that will be sent out in the next round to Linus
> > for inclusion in 2.6.25.
> > 
> > If anyone has any objections about it, please let me know.
> 
> Yes, I have objections and I've told you before.  

You sent one message on this topic to me, back in Feb of 2007,
disagreeing that you could write a userspace USB driver running at full
speed in a non-racey manner.

Unfortunately, many other userspace USB drivers seem to disprove your
statement, including a number of vision systems running in military
applications (tanks running Linux!).  Perhaps this is just a matter of
using the api properly :)

I do know that the current usbfs interface is a major pain, hence the
work to create usbfs2.  I know those developers could use the help in
getting that cleaned up and into the kernel tree.

Also see the rapid development these days in wrappers around usbfs.
There is competing projects right now with OpenUSB and the
revitalization of the old libusb project.  I know those developers are
looking for examples where their new frameworks do not meet the needs of
developers for stuff exactly like you describe (lots of threads, async
callbacks, high throughput, cross-platform portability, etc.)

> > Over two years ago, the Linux USB developers stated that they believed
> > there was no way to create a USB kernel driver that was not under the
> > GPL.  This patch moves the USB apis to enforce that decision.
> > 
> > There are no known closed source USB drivers in the wild, so this
> > patch should cause no problems.
> 
> This is a bit disingenuous.   Of course there are closed source USB
> drivers out there.

Again, I have asked for examples, and only received 2.  One (sound
driver) is totally not needed at all, as the kernel provides that
capability, and the other hasn't run in a modern distro for years.

> I've written multiple of them during my life as a consultant.  The
> nature of closed source drivers is that they quite often are written
> for custom hardware that isn't used by that many people, so you have
> probably not seen them, but they are definitely out there in the wild.

It comes down to the simple fact, if you wish to use Linux, abide by the
license it comes under.  To do otherwise is both disenginous and
illegal[1].

> For some of these drivers, being in kernel space is very important
> since they transfer large amounts of data with very tight latency
> requirements.  It may, in theory, be possible to do the same thing in
> userspace with multiple cooperative threads and libusb, but it would be
> much more complex and much more error prone (it's hard to do control
> loops where you need about 40 us turnaround time). 

See statement above about vision systems in tanks, it can, and is done
all the time...

If a company wants to keep a driver closed, then use another operating
system, it's not like there isn't other options out there.  I hear the
BSDs and Microsoft are quite comfortable with things like that.  :)

thanks,

greg k-h

[1]  This is the public position of my personal lawyers, my employer's
lawyers, and a number of other companies whom hold copyright on the
Linux kernel tree.  So it's not like this is a minority decision these
days...
