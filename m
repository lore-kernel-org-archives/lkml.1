Return-Path: <linux-kernel-owner+w=401wt.eu-S1422806AbXBALQf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422806AbXBALQf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 06:16:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422805AbXBALQe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 06:16:34 -0500
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:3904 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422808AbXBALQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 06:16:33 -0500
Date: Thu, 1 Feb 2007 11:16:18 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Aubrey Li <aubreylee@gmail.com>
Cc: Alan <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       linux-serial@vger.kernel.org
Subject: Re: [BUG]: 2.6.19.2: Weird serial core issue
Message-ID: <20070201111618.GA3462@flint.arm.linux.org.uk>
Mail-Followup-To: Aubrey Li <aubreylee@gmail.com>,
	Alan <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
	linux-serial@vger.kernel.org
References: <6d6a94c50701310249o2b2c8024i4d3f28ec1601246a@mail.gmail.com> <20070131162123.67e22e23@localhost.localdomain> <6d6a94c50701311833m5952c6fdn8e1f0db28d674e79@mail.gmail.com> <20070201094522.GA24608@flint.arm.linux.org.uk> <6d6a94c50702010209t94964ew1aebfad2677aa315@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6d6a94c50702010209t94964ew1aebfad2677aa315@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 01, 2007 at 06:09:24PM +0800, Aubrey Li wrote:
> On 2/1/07, Russell King <rmk+lkml@arm.linux.org.uk> wrote:
> >On Thu, Feb 01, 2007 at 10:33:40AM +0800, Aubrey Li wrote:
> >> On 2/1/07, Alan <alan@lxorguk.ukuu.org.uk> wrote:
> >> >What code is running on that console at the time. Most likely that user
> >> >code is also saving/restoring terminal settings so overwrite yours
> >> >
> >>
> >> I implemented the serial driver by myself, :). See the attachment.
> >> I didn't save/restore terminal setting in the my_set_termios().
> >>
> >> I trace this back till tty_tioctl(..., unsigned long arg), everytime I
> >> type "ENTER" key,
> >> the argument "arg" passed into tty_ioctl() is the address of a termios
> >> structure, which include wrong c_cflag.
> >
> >If userspace is issuing an ioctl to re-enable crtscts, and the kernel
> >is obliging, how can this be a kernel bug?
> 
> But the fact is not.
> 1) kernel boot up and enable crtscts by default
> 2) issue an ioctl to disable crtscts.
> 3) not do anything but type "ENTER", kernel re-enable crtscts.
> 
> That's wrong. Terminal setting seems not be recorded by the serial core.

serial core does not and should not "record" the terminal settings.
That's the job of the tty layer.

> Is it clear?

No.  You haven't analysed the call path causing tty_ioctl() to be
invoked, so you have no basis to point the finger *anywhere* at the
moment.

Find out from where tty_ioctl() is called - maybe by adding a call
to dump_stack().  I think you'll find it is coming from userspace.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
