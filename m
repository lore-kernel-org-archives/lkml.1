Return-Path: <linux-kernel-owner+w=401wt.eu-S1754887AbYDTWp5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754887AbYDTWp5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 18:45:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752928AbYDTWpt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 18:45:49 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:34658 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753181AbYDTWps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 18:45:48 -0400
Date: Sun, 20 Apr 2008 23:40:08 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Jeff Garzik <jeff@garzik.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-arm-kernel@lists.arm.linux.org.uk, kernel@wantstofly.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/15] ARM minor irq handler cleanups
Message-ID: <20080420224008.GB8733@flint.arm.linux.org.uk>
References: <d7afbccda111e535bb14ad8082b208c7a2cd9833.1208559659.git.jgarzik@redhat.com> <20080418164411.b1e1628d.akpm@linux-foundation.org> <48093AF3.2080807@garzik.org> <20080418181741.d6f365c5.akpm@linux-foundation.org> <480BC0FC.8020908@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <480BC0FC.8020908@garzik.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 20, 2008 at 06:17:32PM -0400, Jeff Garzik wrote:
> Andrew Morton wrote:
> >If we had a migration plan (ie: request_irq_new(), above) then this of
> >course wouldn't be a problem.
> 
> A fair comment...

Then we'll be stuck with request_irq_new() for the next 10 years or so.

FWIW (and appologies for hijacking the topic), Jeffs discussion about
changing the ARM integrator RTC driver has triggered a number of cleanups
in the ARM tree:

- converting the ARM integrator PL030 RTC driver to a RTC class driver

  ... which triggered:

- removal of the ARM dyntick code and the unused generic changes
  (including the s390 and sh bits which look like they've never been
   functional.)

  ... which triggered:

- attempting to fix a circular include dependency involving linux/irq.h
  and asm-arm/mach/irq.h

  ... which then triggered:

- allowing PXA platform class to build for more than one PXA platform
  at a time, so I don't have to run 20 (!) separate kernel builds to
  check them all for breakage caused by the elimination of the
  circular dependency.

  ... which also allowed me to find several PXA platform build bugs.

Thanks Jeff. ;)

I'm not intending pushing this stuff into mainline for a bit, although
it will appear in my public tree for others to start looking at and for
them to be aware of.

That does mean that, unfortunately, akpm's going to see those changes
and it might cause Andrew some headaches - sorry about that.  You may
wish to avoid pulling the ARM 'devel' branch until the dust settles.

(Obviously the appropriate fixes will be head towards Linus at the
appropriate time.)

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
