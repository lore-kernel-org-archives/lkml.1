Return-Path: <linux-kernel-owner+w=401wt.eu-S1751440AbYAMHJi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751440AbYAMHJi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2008 02:09:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750918AbYAMHJ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jan 2008 02:09:29 -0500
Received: from gate.crashing.org ([63.228.1.57]:45381 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750903AbYAMHJ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2008 02:09:28 -0500
Subject: Re: [Patch v2] Make PCI extended config space (MMCONFIG) a driver
	opt-in
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Greg KH <greg@kroah.com>, Matthew Wilcox <matthew@wil.cx>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <gregkh@suse.de>, Arjan van de Ven <arjan@infradead.org>,
       linux-kernel@vger.kernel.org, Jeff Garzik <jeff@garzik.org>,
       linux-pci@atrey.karlin.mff.cuni.cz, Martin Mares <mj@ucw.cz>,
       Tony Camuso <tcamuso@redhat.com>, Loic Prylli <loic@myri.com>
In-Reply-To: <20080112144030.GA19279@jurassic.park.msu.ru>
References: <alpine.LFD.1.00.0801111156230.3148@woody.linux-foundation.org>
	 <20080111201716.GO18741@parisc-linux.org>
	 <alpine.LFD.1.00.0801111224090.3148@woody.linux-foundation.org>
	 <20080111204228.GP18741@parisc-linux.org>
	 <alpine.LFD.1.00.0801111311170.3148@woody.linux-foundation.org>
	 <20080111211753.GR18741@parisc-linux.org>
	 <alpine.LFD.1.00.0801111326120.3148@woody.linux-foundation.org>
	 <20080111213803.GS18741@parisc-linux.org>
	 <20080111235856.GA16079@jurassic.park.msu.ru>
	 <20080112002638.GA18710@kroah.com>
	 <20080112144030.GA19279@jurassic.park.msu.ru>
Content-Type: text/plain
Date: Sun, 13 Jan 2008 18:08:05 +1100
Message-Id: <1200208085.6896.134.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2008-01-12 at 17:40 +0300, Ivan Kokshaysky wrote:
> 
> Actually I'm strongly against Arjan's patch. First, it's based on
> assumption that the MMCONFIG thing is sort of fundamentally broken
> on some systems, but none of the facts we have so far does confirm
> that.
> And second, I really don't like the implementation as it breaks all
> non-x86 arches (or forces them to add a set of totally meaningless
> PCI functions).

I agree, I quite dislike it too. Even If the breakage on x86 makes us
want to totally disable it there, it can be done within the existing PCI
ops I believe.

I think Arjan's problem is to try to do it per-device since the
"standard" PCI ops don't get a pci_dev structure (for obvious reasons).

But from what I read in this thread, this per-device enabling/disabling
doesn't seem very useful at all.

Cheers,
Ben.


