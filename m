Return-Path: <linux-kernel-owner+w=401wt.eu-S1753869AbZESIlS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869AbZESIlS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 04:41:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751804AbZESIlE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 04:41:04 -0400
Received: from cs20.apochromatic.org ([204.152.189.161]:62719 "EHLO
	cs20.apochromatic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713AbZESIlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 04:41:03 -0400
Date: Tue, 19 May 2009 09:41:02 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Wolfgang =?iso-8859-1?Q?M=FCes?= <wolfgang.mues@auerswald.de>
Cc: Pierre Ossman <drzeus@drzeus.cx>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Mike Frysinger <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org,
       Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: Re: [PATCH] mmc_spi: do propper retry managment in the block layer
	- rewritten
Message-ID: <20090519084102.GA28564@console-pimps.org>
References: <20090518203338.GB10274@console-pimps.org> <200905190916.40596.wolfgang.mues@auerswald.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200905190916.40596.wolfgang.mues@auerswald.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[CC'ing Nicolas as he's the at91 mci driver maintainer]

On Tue, May 19, 2009 at 09:16:40AM +0200, Wolfgang Mües wrote:
> Matt,
> 
> Am Montag, 18. Mai 2009 schrieb Matt Fleming:
> > Ah, now I understand. I've also been contacted privately by someone
> > who says that they've been experiencing similar issues and that your
> > patch has fixed them. Clearly there are people out there with flaky
> > hardware ;-)
> 
> Hmmm... Every hardware is flaky. Put a piece of hardware near your 
> refrigerator or DECT base, and you will have EMP or HF problems.
> Or use your finger and generate ESD pulses.
> 
> I am using a piezo where I have the GND pin connected to a wire to generate 
> ESD pulses which have the same results as a 4 KV ESD generator:
> 
> http://www.vega-direct.at/buffet/chafing_dish_mit_zubehoer/gasanzuender/index.hsp
> 
> A software which do not behave gracefully in the presence of errors is not 
> production quality for me.
> 

Oh, wow. I didn't pick up on the fact that you were artificially
generating errors on the bus. I thought you'd seen this sort of
problem in production. I don't understand what sort of fault-tolerance
you expect the MMC/SD subsystem to provide.

I've heard from one person that an earlier version of this patch fixed
issues with their at91 controller. If othe people are experiencing
similar issues and this patch fixes it for them, then it definitely
lends some weight to it.

Nicolas, do you have an opinion on the patch?
