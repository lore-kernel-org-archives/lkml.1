Return-Path: <linux-kernel-owner+w=401wt.eu-S1753069AbYAMPjA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753069AbYAMPjA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2008 10:39:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751637AbYAMPiw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jan 2008 10:38:52 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:57503 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751561AbYAMPiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2008 10:38:51 -0500
Subject: Re: PROBLEM REMAINS: [sata_nv ADMA breaks ATAPI]
	Crash	on	accessing DVD-RAM
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Robert Hancock <hancockr@shaw.ca>, Alexander <aledin@mail.ru>,
       linux-kernel@vger.kernel.org, ide <linux-ide@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>, Tejun Heo <htejun@gmail.com>
In-Reply-To: <20080113133317.50ad4bda@lxorguk.ukuu.org.uk>
References: <fa.krOVfyFmB2aqGjJIoHCLmQxecWc@ifi.uio.no>
	 <478702C7.80401@shaw.ca> <47887982.6050805@mail.ru>
	 <47891426.1020604@shaw.ca> <1200170117.3656.66.camel@localhost.localdomain>
	 <47894785.2050508@shaw.ca> <1200180440.3656.76.camel@localhost.localdomain>
	 <47896BA8.4030609@shaw.ca>  <20080113133317.50ad4bda@lxorguk.ukuu.org.uk>
Content-Type: text/plain
Date: Sun, 13 Jan 2008 09:38:45 -0600
Message-Id: <1200238725.3179.16.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 (2.12.2-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 2008-01-13 at 13:33 +0000, Alan Cox wrote:
> > Other than that, I guess the solutions would be to just set a 32-bit 
> > mask on the device if either port has an ATAPI device connected (which 
> > is fairly ugly, considering that you could do things like hotplug an 
> > ATAPI device when the other port was in use, for example), or do 
> > something to prevent requests from reaching this point with >4GB 
> > addresses in the first place..
> 
> With 2.6.24 almost released I think that is a must do for the moment and
> since we also have hotplugging fo devices it might be easier for .24 to
> just set a 32bit DMA mask and be done with it, then fix it later.

Yes, I concur for the short term.  The other two possible courses of
action either involve long discussions (the different device one) or
you'll never quite be sure you got all the paths (the GFP_DMA32 one).
At least with this one, you know everything will work.

James


