Return-Path: <linux-kernel-owner+w=401wt.eu-S1756533AbYKPAF3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756533AbYKPAF3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2008 19:05:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752198AbYKPAFM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Nov 2008 19:05:12 -0500
Received: from aeryn.fluff.org.uk ([87.194.8.8]:57099 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751815AbYKPAFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2008 19:05:11 -0500
Date: Sun, 16 Nov 2008 00:05:08 +0000
From: Ben Dooks <ben-linux@fluff.org>
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
Cc: Ben Dooks <ben-linux@fluff.org>, linux-kernel@vger.kernel.org,
       sdhci-devel@list.drzeus.cx
Subject: Re: [patch 6/7] SDHCI: Check DMA for overruns at end of transfer
Message-ID: <20081116000508.GE9161@fluff.org.uk>
References: <20081103200944.099353331@fluff.org.uk> <20081103201010.820070757@fluff.org.uk> <20081114230026.18513b8a@mjolnir.drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081114230026.18513b8a@mjolnir.drzeus.cx>
X-Disclaimer: These are my own opinions, so there!
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 14, 2008 at 11:00:26PM +0100, Pierre Ossman wrote:
> On Mon, 03 Nov 2008 20:09:50 +0000
> Ben Dooks <ben-linux@fluff.org> wrote:
> 
> > At the end of a transfer, check that the DMA engine in the
> > SDHCI controller actually did what it was meant to and didn't
> > overrun the end of the buffer.
> > 
> > This seems to be triggered by a timeout during an CMD25 (multiple block         
> > write) to a card. The mmc_block module then issues a command to find out        
> > how much data was moved and this seems to end up triggering this DMA            
> > check. The result is the card's queue generates an OOPS as the stack has        
> > been trampled on due to the extra data transfered.
> > 
> > Signed-off-by: Ben Dooks <ben-linux@fluff.org>
> 
> I'm sorry, but I don't see how this is anywhere near acceptable. This
> should be a panic at the very least, and until this can be sorted out
> and avoided the driver should avoid using DMA on these chips.

A panic won't help get the debug logs out of the kernel. This only
turned up whilst debugging the controller, I got the timeout clock
calculation wrong and thus ended up timing out pretty much all the
CMD25s and seeing this problem.

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
