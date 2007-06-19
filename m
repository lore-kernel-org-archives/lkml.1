Return-Path: <linux-kernel-owner+w=401wt.eu-S1755572AbXFSF5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755572AbXFSF5S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 01:57:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751327AbXFSF5G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 01:57:06 -0400
Received: from verein.lst.de ([213.95.11.210]:36374 "EHLO mail.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752730AbXFSF5D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 01:57:03 -0400
Date: Tue, 19 Jun 2007 07:56:29 +0200
From: Christoph Hellwig <hch@lst.de>
To: David Miller <davem@davemloft.net>
Cc: James.Bottomley@SteelEye.com, axboe@kernel.dk, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org, paulus@samba.org,
       Geert.Uytterhoeven@sonycom.com, dwmw2@infradead.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [patch 4/6] ps3: Disk Storage Driver
Message-ID: <20070619055629.GE18542@lst.de>
References: <20070615171545.316dfac7@the-village.bc.nu> <20070615.141917.85409547.davem@davemloft.net> <1181947242.3600.8.camel@mulgrave.il.steeleye.com> <20070615.160858.26276547.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070615.160858.26276547.davem@davemloft.net>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 15, 2007 at 04:08:58PM -0700, David Miller wrote:
> That's not gonna work, it's a totally different model.
> 
> I have a predefined protocol over hypervisor provided "channels" and
> page flipping also done by the hypervisor for the bulk data transfer.
> For the client side I cannot change the hypervisor nor the server
> speaking on the other end.  And when I do write a server I do want
> it to be able to speak to all of the existing clients.
> 
> There's SCSI command pass through as well, as I keep mentioning as
> it's an important reason I don't want to go with any of the non-SCSI
> solutions (other than perhaps ATA) being suggested.

A SCSI pass through is of course perfectly fine.  If you have a separate
block passthrough that has additional magic a separate block driver is
the way to go because it actually is simpler than a scsi driver decoding
command blocks and translating them to deep magic.  The ps3 storage
drivers this thread discussed are a good example for that.  We now
have a very nice and simple disk, scsi and flash chardev driver each
that don't include abstractions layers and cruft.  Combine that with
their initial scsi layer driver that was full of internal dispatches
because each of these device types speaks a completely different command
set.
