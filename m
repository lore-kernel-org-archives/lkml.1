Return-Path: <linux-kernel-owner+w=401wt.eu-S1762690AbYAKX6f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762690AbYAKX6f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 18:58:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932166AbYAKX6X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 18:58:23 -0500
Received: from jurassic.park.msu.ru ([195.208.223.243]:42131 "EHLO
	jurassic.park.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932148AbYAKX6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 18:58:22 -0500
Date: Sat, 12 Jan 2008 02:58:56 +0300
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Greg KH <gregkh@suse.de>,
       Arjan van de Ven <arjan@infradead.org>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, Jeff Garzik <jeff@garzik.org>,
       linux-pci@atrey.karlin.mff.cuni.cz,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Martin Mares <mj@ucw.cz>
Subject: Re: [Patch v2] Make PCI extended config space (MMCONFIG) a driver
	opt-in
Message-ID: <20080111235856.GA16079@jurassic.park.msu.ru>
References: <20080111194524.GA17170@suse.de> <20080111194931.GN18741@parisc-linux.org> <alpine.LFD.1.00.0801111156230.3148@woody.linux-foundation.org> <20080111201716.GO18741@parisc-linux.org> <alpine.LFD.1.00.0801111224090.3148@woody.linux-foundation.org> <20080111204228.GP18741@parisc-linux.org> <alpine.LFD.1.00.0801111311170.3148@woody.linux-foundation.org> <20080111211753.GR18741@parisc-linux.org> <alpine.LFD.1.00.0801111326120.3148@woody.linux-foundation.org> <20080111213803.GS18741@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080111213803.GS18741@parisc-linux.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 11, 2008 at 02:38:03PM -0700, Matthew Wilcox wrote:
> On Fri, Jan 11, 2008 at 01:28:30PM -0800, Linus Torvalds wrote:
> > Hmm. Were all those reports root-caused to just that BAR probing? If so, 
> > we may be in better shape than I worried.
> 
> I believe so.

Ditto.

One typical problem is that on "Intel(r) 3 Series Experss Chipset Family"
MMCONFIG probing of the BAR #2 (frame buffer address) of integrated graphics
device locks up the machine (depending on BIOS settings, of course).
This happens because the frame buffer of IGD has higher decode priority
than MMCONFIG range, as stated in Intel docs...

Ivan.
