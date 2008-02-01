Return-Path: <linux-kernel-owner+w=401wt.eu-S1757980AbYBASg1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757980AbYBASg1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 13:36:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751718AbYBASgT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 13:36:19 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:49851 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751121AbYBASgS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 13:36:18 -0500
Date: Fri, 1 Feb 2008 19:36:21 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: Tejun Heo <htejun@gmail.com>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       Mark Lord <liml@rtr.ca>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH #upstream] libata: implement libata.force module parameter
Message-ID: <20080201183621.GC14759@uranus.ravnborg.org>
References: <47A3375F.80101@gmail.com> <47A356C3.3010904@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47A356C3.3010904@garzik.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 01, 2008 at 12:28:35PM -0500, Jeff Garzik wrote:
> Tejun Heo wrote:
> >This patch implements libata.force module parameter which can
> >selectively override ATA port, link and device configurations
> >including cable type, SATA PHY SPD limit, transfer mode and NCQ.
> >
> >For example, you can say "use 1.5Gbps for all fan-out ports attached
> >to the second port but allow 3.0Gbps for the PMP device itself, oh,
> >the device attached to the third fan-out port chokes on NCQ and
> >shouldn't go over UDMA4" by the following.
> >
> > libata.force=2:1.5g,2.15:3.0g,2.03:noncq,udma4
> >
> >Signed-off-by: Tejun Heo <htejun@gmail.com>
> >---
> >I guess it's about time we add something like this.  More than
> >anything else this should help debugging and can serve as a last
> >resort to work around problems.
> >
> >Thanks.
> >
> > Documentation/kernel-parameters.txt |   35 +++
> > drivers/ata/libata-core.c           |  375 
> > +++++++++++++++++++++++++++++++++++-
> > drivers/ata/libata-eh.c             |    8 
> > drivers/ata/libata.h                |    1 
> > 4 files changed, 415 insertions(+), 4 deletions(-)
> 
> ACK, but it breaks the build due to section type conflicts:
> 
> drivers/ata/libata-core.c:108: error: ata_force_param_buf causes a 
> section type conflict
> 
> Given that the data is marked __initdata and the code is marked __init, 
> I cannot see the problem.

I have lost the actual patch.
But what you see is what happens when you mix const and non-const data
in the same section.

Look for use of __initdata for const data and replace it with __initconst.

And modpost cannot warn about it as gcc errors out before we look at the
.o file with modpost.

	Sam
