Return-Path: <linux-kernel-owner+w=401wt.eu-S1751100AbZA2SfT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751100AbZA2SfT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 13:35:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751328AbZA2SfF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 13:35:05 -0500
Received: from mail.perle.com ([216.129.13.248]:4518 "EHLO MAILV6.PERLE.COM"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751171AbZA2SfE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 13:35:04 -0500
In-Reply-To: <20090128204705.7140d5fd@lxorguk.ukuu.org.uk>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 60/80] tty: extract the pty init time special cases
MIME-Version: 1.0
X-Mailer: Lotus Notes Release 6.5 September 26, 2003
Message-ID: <OFD0116D1D.5061D2AB-ON8525754D.005C6317-8525754D.00661977@perle.com>
From: bmckinlay@perle.com
Date: Thu, 29 Jan 2009 13:30:26 -0500
X-MIMETrack: Serialize by Router on MAILV6/Perle(Release 6.5.6FP3|March 27, 2008) at 01/29/2009
 01:30:05 PM,
	Serialize complete at 01/29/2009 01:30:05 PM
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > my driver to be a module instead of statically linked with the kernel 
like
> > pty is.

> Sure - although it might make more sense to add any neede features to 
the
> generic pty driver - hard to tell when you don't seem interested in
> discussing that.

It's not necessarily that I'm not interested but more that I'm a little
reluctant to do it for the following reasons:

The unknown:
  - have never personally submitted anything to the kernel, need to find 
out 
    what the requirements are, how much documentation you need etc
  - no guarantee how long this will take and that my submission will even 
be 
    accepted.  The longer it takes the more kernel releases that will be
    released where my driver no longer works
Loss of control:
  - my ptyx driver is just one part of the product, it has a daemon part 
and
    of coarse configurators. If the driver is put in the kernel then we 
lose
    the guarantee that a customer will be using compatible versions of 
these 
    3 parts of the product.  Now they are all packaged together
Work involved: 
  - my current ptyx driver is conditionally compiled up the whazoo since 
it 
    works on 2.2.x, 2.4.x and 2.6.x kernels.  Will have to pull out the 
2.6.x
    specific code in order to submit it.
  - will have to add the driver to the kernel config as a configurable 
module
  - any required documentation explaining how the driver works and 
describing
    the API for the master side of the PTY driver ?
  - actually creating the patch and submitting it.

> > By not exporting these symbols it means that the Linux kernel is now
> > forcing anyone who wants to develop a PTY type TTY driver to be merged 

> > into the kernel tree by not exporting these TTY functions. This 
doesn't 
> > seem very "open and flexible".

> No you can provide the GPL symbol exports with the same patch as your 
pty
> driver. There are millions of Linux users and each unused EXPORT_SYMBOL
> costs memory to all those people - why should they carry that burden ?

Given the fact that it in this day and age it is unaceptable to require 
customers to recompile their kernel in order to use a new driver I beleive
my point was lost here.  I was referring to "out of kernel tree" driver
development.
I'll explain my point another way.
As mentioned above the Linux kernel has supported "out of tree" PTY type 
TTY 
drivers all the way back to kernel 2.2.x and up to 2.6.27. To do this the 
kernel exports symbols like 
  - alloc_tty_driver(), tty_set_operations() or tty_register_driver() used 

    in TTY driver's module init functions
  - tty_hangup() used in driver close operations/methods
  - tty_insert_flip_char() or tty_flip_buffer_push() used in ioctl 
    operations/methods.
  - tty_unregister_driver() used in TTY driver module exit functions
 
Now in this patch it was decided to push some of the PTY specific logic 
from 
tty_init_dev() down to the PTY driver by introducing a new install method 
for
PTY drivers.  This new install method for the PTY driver needs to allocate 
the
slave's TTY and initialize it but the TTY functions required to do this 
were not
exported.
All I'm asking is for the Linux kernel to maintain it's support for "out 
of tree" 
PTY type drivers.






