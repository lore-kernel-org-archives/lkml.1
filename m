Return-Path: <linux-kernel-owner+w=401wt.eu-S1754103AbYBEPCY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754103AbYBEPCY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 10:02:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751189AbYBEPCI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 10:02:08 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:37337 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750897AbYBEPCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 10:02:06 -0500
Subject: Re: [PATCH] enclosure: add support for enclosure services
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: ltuikov@yahoo.com
Cc: linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-ide <linux-ide@vger.kernel.org>,
       "Accardi, Kristen C" <kristen.c.accardi@intel.com>
In-Reply-To: <150265.33450.qm@web31808.mail.mud.yahoo.com>
References: <150265.33450.qm@web31808.mail.mud.yahoo.com>
Content-Type: text/plain
Date: Tue, 05 Feb 2008 09:01:56 -0600
Message-Id: <1202223716.3133.10.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-02-04 at 21:35 -0800, Luben Tuikov wrote:
> > > I guess the same could be said for STGT and SCST,
> > right?
> > 
> > You mean both of their kernel pieces are modular? 
> > That's correct.
> 
> No, you know very well what I mean.
> 
> By the same logic you're preaching to include your
> solution part of the kernel, you can also apply to
> SCST.

Ah, but it's not ... the current patch is merely exporting an interface.
The debate in STGT vs SCST is not whether to export an interface but
where to draw the line.

You could also argue in the same vein that sd is redundant because a
filesystem could talk directly to the device via /dev/sgX (in fact OSD
based filesystems already do this).  The argument is true, but misses
the bigger picture that the interfaces exported by sd are more portable
(apply to non-SCSI block devices) and easier to use.

> > > Yes, for which the transport layer, implements the
> > > scsi device node for the SES device.  It doesn't
> > really
> > > matter if the SCSI commands sent to the SES device go
> > > over SGPIO or FC or SAS or Bluetooth or I2C, etc, the
> > > transport layer can implement that and present the
> > > /dev/sgX node.
> > 
> > But it does matter if the enclosure device doesn't
> > speak SCSI.
> 
> Enclosure management isn't as simple as you're
> portraying it here.  The enclosure management
> device speaks either SES or SAF-TE.  The transport
> protocol to access it could be SGPIO or I2C or...

Look, just read the spec; SGPIO is a bus for driving enclosures ... it
doesn't require SES or SAF-TE or even any SCSI protocol.

> >  SGPIO
> > isn't a SCSI protocol ... it's a general purpose
> > serial bus protocol.
> > It's pretty simple and register based, but it might (or
> > might not) be
> > accessible via a SCSI bridge.
> 
> I see.  You've just discovered SGPIO -- good for you.
> 
> At any rate, I told you already that what is needed
> is not what you've provided but a _device node_
> exported by the kernel, either a processor or
> enclosure type.

Wrong ... we don't export non-SCSI devices as SCSI (with the single and
rather annoying exception of ATA via SAT).

James


