Return-Path: <linux-kernel-owner+w=401wt.eu-S1756926AbYFYLeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756926AbYFYLeR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 07:34:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753821AbYFYLeG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 07:34:06 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:58952 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752774AbYFYLeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 07:34:04 -0400
Date: Wed, 25 Jun 2008 12:32:06 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel List <linux-kernel@vger.kernel.org>, ben-linux@fluff.org
Subject: Re: Removal of BAST IDE driver
Message-ID: <20080625113206.GB12304@flint.arm.linux.org.uk>
References: <20080625090953.GA26556@flint.arm.linux.org.uk> <200806251214.14749.bzolnier@gmail.com> <48621E83.3060608@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48621E83.3060608@pobox.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2008 at 06:31:31AM -0400, Jeff Garzik wrote:
> Ben's change merely adds a knob that a platform may set, in order to 
> enable the existing pata_platform driver, which is pretty safe by itself.
> 
> The next piece -- once not in 2.6.26 AFAIK -- is arch-specific code 
> selecting HAVE_PATA_PLATFORM.  BAST IDE, I assume, can go away once 
> relevant platforms start turning on HAVE_PATA_PLATFORM.

There's a bit more than just turning on HAVE_PATA_PLATFORM - there's
also the relevant arch code to register the PATA platform device and
provide the resources and platform data to properly configure the
PATA platform driver.

So there's a number of patches required:
- the addition of HAVE_PATA_PLATFORM (already merged by Jeff)
- "BAST/VR1000: Move to using ata_platform (libata)" to add the
  arch specific bits
- "ANUBIS: Move to using ata_platform driver (libata)" for another
  arch bit (which the following patch needs)
- "LIBATA: update Kconfig to allow new ata_platform dependencies" so
  that the converted platforms select HAVE_PATA_PLATFORM

then, and only then, should drivers/ide/arm/bast-ide.c be removed -
that's the earliest point at which PATA becomes usable in mainline.

A note for Ben: I think the libata patch above should be rolled into
the other two patches so that bast can use the PATA code as soon as
the arch support code has been merged, rather than the current approach
where the libata patch enables the feature for all platforms.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
