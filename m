Return-Path: <linux-kernel-owner+w=401wt.eu-S1763299AbZEAOJZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763299AbZEAOJZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 10:09:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754154AbZEAOJQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 10:09:16 -0400
Received: from mga05.intel.com ([192.55.52.89]:50091 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751223AbZEAOJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 10:09:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,278,1239001200"; 
   d="scan'208";a="686667783"
Date: Fri, 1 May 2009 07:09:14 -0700
From: Matthew Wilcox <willy@linux.intel.com>
To: Theodore Tso <tytso@mit.edu>, Robert Hancock <hancockrwd@gmail.com>,
       Alex Buell <alex.buell@munted.org.uk>, Jeff Garzik <jeff@garzik.org>,
       linux-kernel@vger.kernel.org,
       Linux IDE mailing list <linux-ide@vger.kernel.org>
Subject: Re: No NCQ support on X61s Ultrabay?  (Intel ICH8 SATA controller
	question)
Message-ID: <20090501140914.GD10704@linux.intel.com>
References: <E1LzLgA-0004j6-9W@closure.thunk.org> <49F90CA2.4080602@garzik.org> <20090430083309.437f9248@lithium.local.net> <20090430113445.GA4809@mit.edu> <20090430113814.GB4809@mit.edu> <49FA55A0.8080303@gmail.com> <20090501025132.GA7275@mit.edu> <49FA78B4.2070900@gmail.com> <20090501113533.GB10704@linux.intel.com> <20090501131459.GA7681@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090501131459.GA7681@mit.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 01, 2009 at 09:14:59AM -0400, Theodore Tso wrote:
> Gaah.... so basically a SATA device (the X25-M) is talking to a
> SATA-PATA bridge chip, which is then talking the IDE port in the ICH8
> chipset, which shows up as piix, which we're then pretending is SATA
> at the OS level via the ata_piix driver.  Did I get that right?
> (Excuse me while I go find a barf bag....)

Well ... libata doesn't pretend that everything is SATA; it uses
taskfiles which work for both PATA and SATA.  Other than that, I think
you've got it right.

> Oh.... and I suspect I know why they did it; I'm guessing they wanted
> to support PATA Ultrabay devices for backwards compatibility on the
> X60, and perhaps they were running out of connector pins on the
> docking station (the Ultrabay slot is on the X61's "media slice"), and
> they didn't have enough wires to run both PATA and SATA interfaces to
> the docking station, *and* they wanted to use the same docking station
> for the X60 and X61 Thinkpads.
> 
> Ah, well.  I hope it made sense to *someone* at Lenovo...  It would be
> interesting to see if they fixed this in the X200 or not.

Backwards compatibility is a pain.  It looks like from this lspci:
https://bugzilla.redhat.com/attachment.cgi?id=317327 that the X200 uses
ICH9M which doesn't appear to have an IDE port on the chip (document
316972-004).  So it must be fixed in the X200 ... unless they've put in
a SATA-PATA bridge in the base, and a PATA-SATA bridge in the ultrabay
...

Even then, it might work.  I don't know enough about the PATA protocol
to say.
