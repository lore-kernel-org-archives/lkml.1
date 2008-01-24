Return-Path: <linux-kernel-owner+w=401wt.eu-S1754372AbYAXJEO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754372AbYAXJEO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 04:04:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753048AbYAXJDy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 04:03:54 -0500
Received: from mail.gmx.net ([213.165.64.20]:53578 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752883AbYAXJDu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 04:03:50 -0500
X-Authenticated: #429267
X-Provags-ID: V01U2FsdGVkX1/jp5sYLlHj385RP8mV8D8dqTL1wDGDMWgH+poMN4
	xDwxWJbWw9K92t
Subject: Re: Silent crash witk 2-6.24-rc8-git4
From: Mattias Nissler <mattias.nissler@gmx.de>
To: chris2553@googlemail.com
Cc: "John W. Linville" <linville@tuxdriver.com>,
       linux-wireless@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <200801240003.31666.chris2553@googlemail.com>
References: <200801220603.02986.chris2553@googlemail.com>
	 <200801231642.58782.chris2553@googlemail.com>
	 <20080123190207.GB3129@tuxdriver.com>
	 <200801240003.31666.chris2553@googlemail.com>
Content-Type: text/plain
Date: Thu, 24 Jan 2008 10:03:42 +0100
Message-Id: <1201165422.7472.8.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-01-24 at 00:03 +0000, Chris Clayton wrote:
> Thanks for the reply, John.
> 
> On Wednesday 23 January 2008, John W. Linville wrote:
> > On Wed, Jan 23, 2008 at 04:42:58PM +0000, Chris Clayton wrote:
> > > On Wednesday 23 January 2008, Chris Clayton wrote:
> > > > Hi again.
> > > > 
> > > > On Tuesday 22 January 2008, Chris Clayton wrote:
> > > > > Hi,
> > > 
> > > and here's another, slightly more complete, one, this time from 2.6.24-rc8-git6
> > > (the none I sent earlier was from -git4, by the way)
> > > 
> > > Call Trace:
> > > [<c011440a>] __update_rq_clock+0x1a/0xf0
> > > [<e08ff59d>] rt2x00lib_txdone+0x9d/0xd0 [rt2x00lib]
> > > [<e0909573>] rt61pci_txdone+0x153/0x1f0 [rt61pci]
> > > [<e09096ad>] rt61pci_interrupt+0x9d/0xb0 [rt61pci]
> > 
> > I suspect this could relate to this commit:
> > 
> > commit 62bc060b8ed5fcdafd87da5ab17bdd59a39ebcc9
> > Author: Mattias Nissler <mattias.nissler@gmx.de>
> > Date:   Mon Nov 12 15:03:12 2007 +0100
> > 
> >     rt2x00: Allow rt61 to catch up after a missing tx report
> > 
> > Could you revert that patch, rebuild, and try to recreate the problem?
> > 
> 
> I've reverted the patch by hand - the original patch on linux-wireless doesn't match the present state of the code
> in rt61pci.c and I'm not a git user. I'm pretty sure I've got it right, however.
> 
> Problem now is that we are back where we were a few weeks ago because my wireless connection dies
> almost immediately after I start the download and from dmesg I see:
> 
> phy0 -> rt2x00pci_write_tx_data: Error - Arrived at non-free entry in the non-full queue 2.
> Please file bug report to http://rt2x00.serialmonkey.com.

As the patches author, I'm not very surprised :-) The patch just adds
additional processing that should have happened in a different call of
the interrupt handler. I don't think it can be related at all to the
trouble you're seeing.

When I find time, I'll try the Linus tree on my rt61 to see what
happens.

Mattias

