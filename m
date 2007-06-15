Return-Path: <linux-kernel-owner+w=401wt.eu-S1757309AbXFOXhR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757309AbXFOXhR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 19:37:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752183AbXFOXhE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 19:37:04 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55842
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751557AbXFOXhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 19:37:00 -0400
Date: Fri, 15 Jun 2007 16:37:18 -0700 (PDT)
Message-Id: <20070615.163718.55726640.davem@davemloft.net>
To: James.Bottomley@SteelEye.com
Cc: alan@lxorguk.ukuu.org.uk, Geert.Uytterhoeven@sonycom.com,
       dwmw2@infradead.org, axboe@kernel.dk, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org, paulus@samba.org
Subject: Re: [patch 4/6] ps3: Disk Storage Driver
From: David Miller <davem@davemloft.net>
In-Reply-To: <1181950083.3600.18.camel@mulgrave.il.steeleye.com>
References: <1181947242.3600.8.camel@mulgrave.il.steeleye.com>
	<20070615.160858.26276547.davem@davemloft.net>
	<1181950083.3600.18.camel@mulgrave.il.steeleye.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: James Bottomley <James.Bottomley@SteelEye.com>
Date: Fri, 15 Jun 2007 16:28:03 -0700

> On Fri, 2007-06-15 at 16:08 -0700, David Miller wrote:
> > From: James Bottomley <James.Bottomley@SteelEye.com>
> > Date: Fri, 15 Jun 2007 15:40:42 -0700
> > 
> > > On Fri, 2007-06-15 at 14:19 -0700, David Miller wrote:
> > > > Another quirk I have to deal with is that under LDOMs you
> > > > can export full disks and also just slices.  So I'll have
> > > > to get down into the partition machinery to support that
> > > > somehow.
> > > 
> > > For this, it sounds like you might find nbd a more enticing
> > > proposition ... it already is partition independent and is basically a
> > > block to net socket exporter.
> > 
> > That's not gonna work, it's a totally different model.
> > 
> > I have a predefined protocol over hypervisor provided "channels" and
> > page flipping also done by the hypervisor for the bulk data transfer.
> > For the client side I cannot change the hypervisor nor the server
> > speaking on the other end.  And when I do write a server I do want
> > it to be able to speak to all of the existing clients.
> > 
> > There's SCSI command pass through as well, as I keep mentioning as
> > it's an important reason I don't want to go with any of the non-SCSI
> > solutions (other than perhaps ATA) being suggested.
> 
> Then sure, use SCSI ... the ibmvscsi client originally talked to some
> type of hypervisor interface too before IBM extracted it and open
> sourced the server.  If actual SCSI commands are going in somewhere ...
> be it a real device, a RAID firmware emulation or a hypervisor input,
> then I'm happy with the driver being in SCSI.

For normal block I/O it's just raw copies over the provided protocol.

But the service exports a service by which raw SCSI commands can be
sent, for things like disk fault probing and stuff like that.  It's
not for block I/O, it's for "all the funny stuff" scsi comands are
used for outside of actual data transfers.
