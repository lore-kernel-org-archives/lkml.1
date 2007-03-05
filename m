Return-Path: <linux-kernel-owner+w=401wt.eu-S1752827AbXCER4O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752827AbXCER4O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 12:56:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752830AbXCER4O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 12:56:14 -0500
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:3895 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752827AbXCER4N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 12:56:13 -0500
Date: Mon, 5 Mar 2007 17:56:04 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-serial@vger.kernel.org, Robin Getz <rgetz@blackfin.uclinux.org>
Subject: Re: should RTS init in serial core be tied to CRTSCTS
Message-ID: <20070305175604.GB18548@flint.arm.linux.org.uk>
Mail-Followup-To: Mike Frysinger <vapier.adi@gmail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-serial@vger.kernel.org,
	Robin Getz <rgetz@blackfin.uclinux.org>
References: <8bd0f97a0703011603m794e00f5x875eb68ad0db05de@mail.gmail.com> <20070304194632.GC30345@flint.arm.linux.org.uk> <8bd0f97a0703050909n18386114kd2c0b2a108591641@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8bd0f97a0703050909n18386114kd2c0b2a108591641@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 05, 2007 at 12:09:20PM -0500, Mike Frysinger wrote:
> On 3/4/07, Russell King <rmk+lkml@arm.linux.org.uk> wrote:
> >On Thu, Mar 01, 2007 at 07:03:02PM -0500, Mike Frysinger wrote:
> >> the console= bootcmd allows for controlling of the initial state of
> >> flow control by adding/omitting the 'r' suffix ...
> >
> >The console command *only* sets the state for the kernel's use of one
> >serial port.  It does not affect any other serial port, so tying
> >random RTS behaviours into that command line option is absolutely
> >silly.
> 
> true ... so ignoring the original motivation for change i posted, is
> it really correct for the serial core to be forcing TIOCM_RTS at uart
> startup even though the uart doesnt have CTSRTS flow control enabled ?
> in other words, my change is agnostic of the console, and is done for
> all uarts ... it should prob have a similar change in uart_shutdown()
> though ...

No idea - it's something that Linux has always done.  Neither do I have
any idea if changing it will break anyones setup.  However, since I don't
maintain serial anymore, I'm not about to start playing about with this
trying to find out.

Feel free to submit a patch to akpm to leave RTS alone when CRTSCTS is
not set.  I'd recommend that it sits in -mm for about 6 months to really
get an idea if it breaks anything.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
