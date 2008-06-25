Return-Path: <linux-kernel-owner+w=401wt.eu-S1756036AbYFYJKf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756036AbYFYJKf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 05:10:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754196AbYFYJK1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 05:10:27 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39451 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754116AbYFYJK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 05:10:26 -0400
Date: Wed, 25 Jun 2008 10:09:53 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, jgarzik@pobox.com,
       bzolnier@gmail.com
Cc: Linux Kernel List <linux-kernel@vger.kernel.org>, ben-linux@fluff.org
Subject: Removal of BAST IDE driver
Message-ID: <20080625090953.GA26556@flint.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Referring to this commit in mainline:

commit ac1623625c5818bbdf5c68973098ba386ba7a004
Author: Ben Dooks <ben-linux@fluff.org>
Date:   Fri Jun 20 20:53:35 2008 +0200

    BAST: Remove old IDE driver

    Remove the old BAST IDE driver, as we are now using the platform-pata
    support.

    Signed-off-by: Ben Dooks <ben-linux@fluff.org>
    Cc: Jeff Garzik <jgarzik@pobox.com>
    Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

I've recieved a couple of patches for the next merge window from Ben
which say:

>  Subject: [patch 20/32] BAST/VR1000: Move to using ata_platform (libata)
>
>  Use the pata_platform driver to provide the IDE port
>  drivers on the Simntec BAST and Thorcom VR1000 machines
>  as a precursor to removing drivers/ide/arm/bast-ide.c

And when I queried Ben on this, he responded thusly:

09:58 < fluffy> yes, bart was rather quicker at applying the removal patch
09:59 < fluffy> i send 'for next kernel release' and he shoved it in his -rc6
                sub

So, quite clearly we have a regression - we have platforms which have
lost IDE support.

There's two ways to resolve this.  Either the above commit can be
reverted restoring old IDE support, or the patches to add libata
support for these platforms can be submitted.  Given where we are in
the -rc, I think reverting the bad commit would be more sensible.

The question also has to be asked - what are maintainers doing putting
driver removals into -rc kernels?  Surely they are only merge-window
candidates?

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
