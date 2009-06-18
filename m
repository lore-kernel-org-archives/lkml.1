Return-Path: <linux-kernel-owner+w=401wt.eu-S1754901AbZFRQ5V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754901AbZFRQ5V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 12:57:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752170AbZFRQ5J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 12:57:09 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:47373 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750989AbZFRQ5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 12:57:08 -0400
Date: Thu, 18 Jun 2009 18:59:26 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Matthew Wilcox <matthew@wil.cx>, Changli Gao <xiaosuo@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-scsi@vger.kernel.org
Subject: Re: [PATCH] SCSI: explain the hidden scsi_wait_scan Kconfig variable
Message-ID: <20090618165926.GA13229@uranus.ravnborg.org>
References: <4A384FE4.9090703@gmail.com> <20090617021254.GQ19977@parisc-linux.org> <tkrat.ad6f8fb712020451@s5r6.in-berlin.de> <1245338486.7586.13.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1245338486.7586.13.camel@mulgrave.site>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 18, 2009 at 03:21:26PM +0000, James Bottomley wrote:
> On Wed, 2009-06-17 at 12:07 +0200, Stefan Richter wrote:
> > People keep sending patches to expose CONFIG_SCSI_WAIT_SCAN as a tunable
> > item.  These patches aren't accepted upstream, so let's stop the ongoing
> > irritation of people due to this obscure and strange installed module
> > and its Kconfig option.
> > 
> > Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
> > ---
> >  drivers/scsi/Kconfig |   17 ++++++++++++++++-
> >  1 file changed, 16 insertions(+), 1 deletion(-)
> > 
> > Index: b/drivers/scsi/Kconfig
> > ===================================================================
> > --- a/drivers/scsi/Kconfig
> > +++ b/drivers/scsi/Kconfig
> > @@ -259,10 +259,25 @@ config SCSI_SCAN_ASYNC
> >  	  or async on the kernel's command line.
> >  
> >  config SCSI_WAIT_SCAN
> > -	tristate
> > +	tristate  # No prompt here, this is a hidden option.
> 
> Adding comments explaining this is good, I think.
> 
> >  	default m
> >  	depends on SCSI
> >  	depends on MODULES
> > +	help
> > +	  Wait until all the async scans are complete.  The idea is to use
> > +	  it in initrd/ initramfs scripts.  You modprobe it after all the
> > +	  modprobes of the root SCSI drivers and it will wait until they
> > +	  have all finished scanning their buses before allowing the boot
> > +	  to proceed.
> > +
> > +	  Of course this does not work if targets boot independently of and
> > +	  in parallel with the initiator, and/ or with transports with non-
> > +	  deterministic target discovery schemes, and/ or if a transport
> > +	  driver does not support scsi_wait_scan.
> > +
> > +	  Still, this option is not exposed as a prompt because little is
> > +	  to be gained by disabling it, whereas people who accidentally
> > +	  switch it off may wonder why their mkinitrd gets into trouble.
> 
> But not a help text that can never be shown.  Turn this into a comment
> and I'll apply the patch.
> 
> The reason is the fact that this could be construed as a detectable bug
> (option with help that can never be displayed) and someone with too much
> time on their hands someday might make a static checker for it.

In another thread we discussed that the help text should be visible when
searching for an invisible symbol.
There are arguments both ways.

Personally I like the help syntax that we one day can benefit from
and would not accept a warning for help text on symbols with no prompt.

	Sam
