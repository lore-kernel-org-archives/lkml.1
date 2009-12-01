Return-Path: <linux-kernel-owner+w=401wt.eu-S1754333AbZLARqY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754333AbZLARqY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 12:46:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754311AbZLARqW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 12:46:22 -0500
Received: from h5.dl5rb.org.uk ([81.2.74.5]:35736 "EHLO h5.dl5rb.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753555AbZLARqV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 12:46:21 -0500
Date: Tue, 1 Dec 2009 17:46:12 +0000
From: Ralf Baechle <ralf@linux-mips.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Pull request for MIPS-specific driver bits
Message-ID: <20091201174612.GA18799@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below three patches for MIPS-specific drivers that I can't get anybody
else interested in merging.  To be accurate drivers/video/gbefb.c is
shared with SGI's x86-based Visual Workstation which is more or less
the same system architecture than the MIPS-based O2.

Please pull them from

    git://ftp.linux-mips.org/pub/scm/upstream-linus.git upstream

This would be the last MIPS-related patches I have pending for 2.6.32.

Thanks,

  Ralf

commit 3063ae66aa9024d92d613e41264b590838a56a92
Author: Maxime Bizon <mbizon@freebox.fr>
Date:   Wed Nov 4 14:11:15 2009 +0100

    MIPS: BCM63xx: Fix serial driver compile breakage.
    
    The driver missed an API change.
    
    Signed-off-by: Maxime Bizon <mbizon@freebox.fr>
    Cc: linux-mips@linux-mips.org
    Signed-off-by: Ralf Baechle <ralf@linux-mips.org>

commit 6a830e0a79a530328fb24aca0dc1682db9e163e0
Author: Julia Lawall <julia@diku.dk>
Date:   Sun Aug 9 11:42:32 2009 +0200

    VIDEO: Correct use of request_region/request_mem_region
    
    request_region should be used with release_region, not request_mem_region.
    
    Geert Uytterhoeven pointed out that in the case of drivers/video/gbefb.c,
    the problem is actually the other way around; request_mem_region should be
    used instead of request_region.
    
    The semantic patch that finds/fixes this problem is as follows:
    (http://coccinelle.lip6.fr/)
    
    // <smpl>
    @r1@
    expression start;
    @@
    
    request_region(start,...)
    
    @b1@
    expression r1.start;
    @@
    
    request_mem_region(start,...)
    
    @depends on !b1@
    expression r1.start;
    expression E;
    @@
    
    - release_mem_region
    + release_region
      (start,E)
    // </smpl>
    
    Signed-off-by: Julia Lawall <julia@diku.dk>
    Signed-off-by: Ralf Baechle <ralf@linux-mips.org>

commit 5a635a204e649d997b9f67c62d6e7d0e615d2619
Author: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Date:   Thu Sep 3 22:59:01 2009 +0900

    SPI: spi_txx9: Fix bit rate calculation
    
    TXx9 SPI bit rate is calculated by:
            fBR = (spi-baseclk) / (n + 1)
    Fix calculation of min_speed_hz, max_speed_hz and n.
    
    Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
    Signed-off-by: Ralf Baechle <ralf@linux-mips.org>

 drivers/serial/bcm63xx_uart.c |    4 ++--
 drivers/spi/spi_txx9.c        |   13 ++++++-------
 drivers/video/gbefb.c         |    2 +-
 3 files changed, 9 insertions(+), 10 deletions(-)
