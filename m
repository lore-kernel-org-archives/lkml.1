Return-Path: <linux-kernel-owner+w=401wt.eu-S1758560AbYF0Rjb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758560AbYF0Rjb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 13:39:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751197AbYF0RjX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 13:39:23 -0400
Received: from mail.queued.net ([207.210.101.209]:2022 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751930AbYF0RjW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 13:39:22 -0400
Date: Fri, 27 Jun 2008 13:42:14 -0400
From: Andres Salomon <dilinger@queued.net>
To: Pierre Ossman <drzeus@drzeus.cx>
Cc: akpm@linux-foundation.org, sdhci-devel@list.drzeus.cx,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [OLPC] sdhci: add quirk for the Marvell CaFe's
 interrupt timeout
Message-ID: <20080627134214.422b11f7@xo-debian>
In-Reply-To: <20080627193001.5925f664@mjolnir.drzeus.cx>
References: <20080623101352.3bbaf5b0@xo-debian>
	<20080627193001.5925f664@mjolnir.drzeus.cx>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Jun 2008 19:30:01 +0200
Pierre Ossman <drzeus@drzeus.cx> wrote:

> On Mon, 23 Jun 2008 10:13:52 -0400
> Andres Salomon <dilinger@queued.net> wrote:
> 
> > 
> > The CaFe chip has a hardware bug that ends up with us getting a
> > timeout value that's too small, causing the following sorts of
> > problems:
> > 
> > [   60.525138] mmcblk0: error -110 transferring data
> > [   60.531477] end_request: I/O error, dev mmcblk0, sector 1484353
> > [   60.533371] Buffer I/O error on device mmcblk0p2, logical block
> > 181632 [   60.533371] lost page write due to I/O error on mmcblk0p2
> > 
> > Presumably this is an off-by-one error in the hardware.
> > Incrementing the timeout count value that we stuff into the
> > TIMEOUT_CONTROL register gets us a value that works.  This bug was
> > originally discovered by Pierre Ossman, I believe.
> > 
> > [thanks to Robert Millan for proving that this was still a problem]
> > 
> > Signed-off-by: Andres Salomon <dilinger@debian.org>
> 
> Hmm... I'm not entirely sure about the specifics of the workaround
> here. It's likely that we'll have an off-by-minus-one in another
> controller, and off-by-two in a third.
> 
> Perhaps we should just have "broken timeout" and set the timeout to
> 0xE. It doesn't cause any side-effects except that the user will have
> to wait slightly longer for requests to fail if the card has decided
> to crap out.
> 

That would be fine.  OFW actually just hardcodes the timeout to 0xc,
with Mitch citing the same logic.  Just setting it to the upper bound
would certainly make it more applicable hardware other than the cafe.

