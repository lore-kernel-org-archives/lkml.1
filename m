Return-Path: <linux-kernel-owner+w=401wt.eu-S1753703AbYHLXSb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753703AbYHLXSb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 19:18:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752081AbYHLXSX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 19:18:23 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:38557 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754AbYHLXSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 19:18:22 -0400
Date: Tue, 12 Aug 2008 16:16:02 -0700
From: Greg KH <greg@kroah.com>
To: Kenneth Goldman <kgoldman@us.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, Mimi Zohar <zohar@us.ibm.com>
Subject: Re: [PATCH 1/4] integrity: TPM internel kernel interface
Message-ID: <20080812231602.GB12838@kroah.com>
References: <20080812193031.GD18034@infradead.org> <OF6C940C00.249617D7-ON852574A3.0071F8B0-852574A3.00732160@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OF6C940C00.249617D7-ON852574A3.0071F8B0-852574A3.00732160@us.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 12, 2008 at 04:57:31PM -0400, Kenneth Goldman wrote:
> Christoph Hellwig <hch@infradead.org> wrote on 08/12/2008 03:30:31 PM:
> 
> > On Mon, Aug 11, 2008 at 05:13:51PM -0400, Mimi Zohar wrote:
> > >
> > > I assume the concern here is that between looking up the chip and
> actually
> > >
> > > using the chip, the TPM chip is disabled/deactivated.  Based on
> > > discussions
> > > with Kenneth Goldman, the TCG main specification part2: structures,
> > > require
> > > that even if the TPM is disabled/deactivated, the command to extend the
> 
> > > PCR
> > > will succeed, but the command to read the PCR will fail with an
> > > appropriate
> > > error code.
> >
> > And what happens when the chip simply goes away due to a hotplug action?
> > Or not even the actual chip goes away but just the chip driver and you
> > now dereference freed memory?
> 
> Being a TCG/TPM person, I can only address the first question.  The
> intent is that the TPM is soldered to the planar/motherboard (the TCG
> uses the phrase "bound to the platform").  I can't imagine
> any manufacturer designing a pluggable TPM.  It would subvert PCR
> measurements and thus attestation, data sealing, etc.

Load up the fake-php hotplug pci driver and "soft" disconnect it from
the system :)

That was easy...

Note, just because you think your device is always going to be soldered
to the motherboard, doesn't mean it can't be disconnected at any point
in time with the kernel running.

Or the module could just be unloaded, that's also a very common thing to
have happen, right?

thanks,

greg k-h
