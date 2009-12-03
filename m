Return-Path: <linux-kernel-owner+w=401wt.eu-S1755687AbZLCABw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755687AbZLCABw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 19:01:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754575AbZLCABv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 19:01:51 -0500
Received: from h5.dl5rb.org.uk ([81.2.74.5]:48808 "EHLO h5.dl5rb.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754349AbZLCABu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 19:01:50 -0500
Date: Thu, 3 Dec 2009 00:01:27 +0000
From: Ralf Baechle <ralf@linux-mips.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Pull request for MIPS-specific driver bits
Message-ID: <20091203000127.GA2710@linux-mips.org>
References: <20091201174612.GA18799@linux-mips.org>
 <alpine.LFD.2.00.0912021543440.2872@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0912021543440.2872@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 02, 2009 at 03:46:08PM -0800, Linus Torvalds wrote:

> On Tue, 1 Dec 2009, Ralf Baechle wrote:
> > 
> > Please pull them from
> > 
> >     git://ftp.linux-mips.org/pub/scm/upstream-linus.git upstream
> 
> There are no driver updates there. It looks like you overwrote that branch 
> with your other MIPS build fixes that you had a separate pull request for.

Correct - but that pull request was obsolete anyway as one of the driver
patches had independentaly submitted to both me and gregkh and you pulled
Greg's version yesterday.

I spun a new tree which again is at:

  git://ftp.linux-mips.org/pub/scm/upstream-linus.git upstream

Please pull, thanks!

  Ralf

commit 0fdd07f77fd9cc6a7d49076793daef06ea5d8f13
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

commit dbf763a2f1c117cfe45bbbd2c874a150f0e0900b
Author: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Date:   Thu Sep 3 22:59:01 2009 +0900

    SPI: spi_txx9: Fix bit rate calculation
    
    TXx9 SPI bit rate is calculated by:
            fBR = (spi-baseclk) / (n + 1)
    Fix calculation of min_speed_hz, max_speed_hz and n.
    
    Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
    Signed-off-by: Ralf Baechle <ralf@linux-mips.org>

 drivers/spi/spi_txx9.c |   13 ++++++-------
 drivers/video/gbefb.c  |    2 +-
 2 files changed, 7 insertions(+), 8 deletions(-)
