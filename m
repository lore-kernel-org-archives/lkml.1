Return-Path: <linux-kernel-owner+w=401wt.eu-S970248AbXHMU4u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S970248AbXHMU4u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 16:56:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939278AbXHMUzg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 16:55:36 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:52256 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752137AbXHMUza (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 16:55:30 -0400
Date: Mon, 13 Aug 2007 16:55:23 -0400
To: Brad Campbell <brad@wasp.net.au>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: Advice on a userspace tty serial driver
Message-ID: <20070813205523.GA9412@csclub.uwaterloo.ca>
References: <46BC59E3.2010402@wasp.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46BC59E3.2010402@wasp.net.au>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 10, 2007 at 04:28:19PM +0400, Brad Campbell wrote:
> I'm building a bit of hardware. It's basically a serial multiplexer that 
> communicates to the PC using a single usb-serial port. It has the ability 
> to run between 2 and 8 standard async ports over this single interface.
> 
> I'd rather not write a kernel driverif possible as I figure this would be a 
> perfect application for a userspace daemon to do the control and mux/demux. 
> I'd prefer to present standard serial style devices (/dev/ttySxx) to 
> userspace giving me the ability to run unmodified software to talk to the 
> multiplexed ports.
> 
> I think tty/pty pairs looks roughly what I'm after, but will they allow me 
> to use standard IOCTLS for conveying baud rate and other standard serial 
> parameters to the daemon?
> 
> I've spotted several userspace serial driver projects in the last 7 or so 
> years, but I can't seem to find any that made it into the kernel.
> 
> Am I on the right track with tty/pty or is there a better way?

I don't think you can do any serial specific stuff, like parity and stop
bits and the like across a pty.  You might have to actually write a
serial driver to present the devices and handle the ioctls, even if you
have a user space process handle the mux/demux between the real serial
port and the fake ports.

I am curious how you are going to pass the data to the external device,
and indicate which port the data should go through.  What will you do
when there is too much data being sent for the real serial port to
handle?  I guess if you had a single high speed port, that would be a
start.

--
Len Sorensen
