Return-Path: <linux-kernel-owner+w=401wt.eu-S1756193AbZFXOq6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756193AbZFXOq6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 10:46:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751339AbZFXOqv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 10:46:51 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:44510 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751240AbZFXOqu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 10:46:50 -0400
Date: Wed, 24 Jun 2009 07:46:46 -0700
From: Gary Hade <garyhade@us.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Len Brown <lenb@kernel.org>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       Gary Hade <garyhade@us.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
       x86 maintainers <x86@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Regression with commit f9cde5f in 2.6.30-gitX
Message-ID: <20090624144646.GA7239@us.ibm.com>
References: <4A418254.9050607@lwfinger.net> <1245845787.3093.3.camel@localhost.localdomain> <20090624122209.GC20564@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090624122209.GC20564@elte.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 24, 2009 at 02:22:09PM +0200, Ingo Molnar wrote:
> 
> * Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:
> 
> > On Tue, 2009-06-23 at 20:33 -0500, Larry Finger wrote:
> > > My latest pull from Linus's tree fails to boot. Bisection leads to the
> > > commit entitled "x86/ACPI: Correct maximum allowed _CRS returned
> > > resources and warn if exceeded" with hash
> > > f9cde5ffed17bf74f6bef042d99edb0622f58576. I have been unable to
> > > capture the first error message as it scrolls off the screen, but the
> > > second hits the WARN_ON at drivers/ata/ahci.c:695 in routine
> > > ahci_enable_ahci() because HOST_AHCI_EN is not set.
> > > 
> > 
> > This patch fixes boot failure on my AMD 64 laptop, can you please test
> > this patch:
> > 
> > [PATCH] x86: fix _CRS resources return handling
> > 
> > We need to check for info->res_num and only handle for < PCI_BUS_NUM_RESOURCES
> > 
> > Also set info->bus->resource[info->res_num] for _CRS resources return handling
> > 
> > Fixed boot failure on some machine.
> > 
> > Reported-by: Larry Finger <Larry.Finger@lwfinger.net>
> > Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> > ---
> >  arch/x86/pci/acpi.c |   16 ++++++++++------
> >  1 files changed, 10 insertions(+), 6 deletions(-)
> 
> Ah, nice! I suspect it was this upstream commit causing it:
> 
> f9cde5f: x86/ACPI: Correct maximum allowed _CRS returned resources and warn if exceeded
> 
> right?

This change was made in conjunction with the previous
"PCI: use ACPI _CRS data by default" 9e9f46c44e487af0a82eb61b624553e2f7118f5b
change to help expose systems that might be incompatible with
that change.  See http://marc.info/?l=linux-pci&m=124345331521386&w=2
for more discussion on this. 

Gary

-- 
Gary Hade
System x Enablement
IBM Linux Technology Center
503-578-4503  IBM T/L: 775-4503
garyhade@us.ibm.com
http://www.ibm.com/linux/ltc

