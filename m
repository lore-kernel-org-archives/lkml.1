Return-Path: <linux-kernel-owner+w=401wt.eu-S1754367AbYAZUYQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754367AbYAZUYQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 15:24:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754105AbYAZUX7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 15:23:59 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:4877 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753417AbYAZUX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 15:23:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=LVOY/puMMfnT/zg39bNFPouwwDrsaIV5KDiCe6h9wq7KB9mrgtTvGaAgcXKURH0y5q3wcYi6Jch/0iKvh9GXB51kOIeS3b4weDGotZ8VMfIMSUn9X3x4ux02810O5op3YPWFrWfzYtZpc+hYplTdG0YGkTOjL1V9bcrzKR2fPbs=
From: Chris Clayton <chris2553@googlemail.com>
Reply-To: chris2553@googlemail.com
To: Mattias Nissler <mattias.nissler@gmx.de>
Subject: Re: Silent crash witk 2-6.24-rc8-git4
Date: Sat, 26 Jan 2008 20:23:19 +0000
User-Agent: KMail/1.9.7
Cc: "John W. Linville" <linville@tuxdriver.com>,
       linux-wireless@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
References: <200801220603.02986.chris2553@googlemail.com> <200801240003.31666.chris2553@googlemail.com> <1201165422.7472.8.camel@localhost>
In-Reply-To: <1201165422.7472.8.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801262023.19918.chris2553@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 24 January 2008, Mattias Nissler wrote:
> 
> On Thu, 2008-01-24 at 00:03 +0000, Chris Clayton wrote:
> > Thanks for the reply, John.
> > 
> > On Wednesday 23 January 2008, John W. Linville wrote:
> > > On Wed, Jan 23, 2008 at 04:42:58PM +0000, Chris Clayton wrote:
> > > > On Wednesday 23 January 2008, Chris Clayton wrote:
> > > > > Hi again.
> > > > > 
> > > > > On Tuesday 22 January 2008, Chris Clayton wrote:
> > > > > > Hi,
> > > > 
> > > > and here's another, slightly more complete, one, this time from 2.6.24-rc8-git6
> > > > (the none I sent earlier was from -git4, by the way)
> > > > 
> > > > Call Trace:
> > > > [<c011440a>] __update_rq_clock+0x1a/0xf0
> > > > [<e08ff59d>] rt2x00lib_txdone+0x9d/0xd0 [rt2x00lib]
> > > > [<e0909573>] rt61pci_txdone+0x153/0x1f0 [rt61pci]
> > > > [<e09096ad>] rt61pci_interrupt+0x9d/0xb0 [rt61pci]
> > > 
> > > I suspect this could relate to this commit:
> > > 
> > > commit 62bc060b8ed5fcdafd87da5ab17bdd59a39ebcc9
> > > Author: Mattias Nissler <mattias.nissler@gmx.de>
> > > Date:   Mon Nov 12 15:03:12 2007 +0100
> > > 
> > >     rt2x00: Allow rt61 to catch up after a missing tx report
> > > 
> > > Could you revert that patch, rebuild, and try to recreate the problem?
> > > 
> > 
> > I've reverted the patch by hand - the original patch on linux-wireless doesn't match the present state of the code
> > in rt61pci.c and I'm not a git user. I'm pretty sure I've got it right, however.
> > 
> > Problem now is that we are back where we were a few weeks ago because my wireless connection dies
> > almost immediately after I start the download and from dmesg I see:
> > 
> > phy0 -> rt2x00pci_write_tx_data: Error - Arrived at non-free entry in the non-full queue 2.
> > Please file bug report to http://rt2x00.serialmonkey.com.
> 
> As the patches author, I'm not very surprised :-) The patch just adds
> additional processing that should have happened in a different call of
> the interrupt handler. I don't think it can be related at all to the
> trouble you're seeing.
> 
> When I find time, I'll try the Linus tree on my rt61 to see what
> happens.
> 

OK, thanks. I look forward to seeing how things go. In the meantime, I'll use the out-of-tree module from serialmonkey.

Chris
> Mattias
> 
> 



-- 
Beer is proof that God loves us and wants us to be happy - Benjamin Franklin
