Return-Path: <linux-kernel-owner+w=401wt.eu-S1755228Ab0A2XYg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755228Ab0A2XYg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 18:24:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754863Ab0A2XYe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 18:24:34 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:52950 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754422Ab0A2XY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 18:24:29 -0500
Date: Fri, 29 Jan 2010 23:25:40 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jeff Garzik <jeff@garzik.org>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/68] ide2libata
Message-ID: <20100129232540.41f6c4f6@lxorguk.ukuu.org.uk>
In-Reply-To: <4B6355DF.9050001@garzik.org>
References: <20100129160308.21495.14120.sendpatchset@localhost>
	<4B6355DF.9050001@garzik.org>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I'm fine with applying patches 2-5, but I am definitely interested to 
> hear what others think about this.  Clearly, LOC is reduced, but that's 
> not the only factor in code maintenance.

I think it will be a nightmare for maintenance with all the includes and
the like plus the ifdefs making it very hard to read the drivers and
maintain them.

Some of it could be cleanly split. The 40wire lists for example could all
be merged into one with a function taking the pci_dev of the controller
which did a lookup based on vendor/dev/svid/sdid. That would put them all
in one logical clean C file and makes sense as a split point for the code.

> En masse backporting bug fixes is what's known as a one-time cost.  Once 
> the majority of libata PATA drivers reach bugfix and feature parity, the 
> need for code sharing is reduced greatly.

One problem is telling which of the bits in the old IDE stack are

- bug fixes
- bugs
- cargo culting
- irrelevant

So I think its an extremely useful exercise to figure out what subtle
differences there are between the drivers. It's not then a trivial
assumption that they can just be pasted over. The include stuff though is
too ugly to merge even if its an excellent research project to identify
the differences and quirks.

The old IDE "maintenance mode" seems to be drifting - the rate of change
is rather high for that claim.

Alan
