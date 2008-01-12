Return-Path: <linux-kernel-owner+w=401wt.eu-S1760831AbYALSRh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760831AbYALSRh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 13:17:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756518AbYALSR3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 13:17:29 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:42466 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756218AbYALSR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 13:17:28 -0500
Date: Sat, 12 Jan 2008 11:17:22 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>, Greg KH <greg@kroah.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Jeff Garzik <jeff@garzik.org>, linux-pci@atrey.karlin.mff.cuni.cz,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Martin Mares <mj@ucw.cz>, Tony Camuso <tcamuso@redhat.com>,
       Loic Prylli <loic@myri.com>
Subject: Re: [Patch v2] Make PCI extended config space (MMCONFIG) a driver opt-in
Message-ID: <20080112181722.GU18741@parisc-linux.org>
References: <alpine.LFD.1.00.0801111224090.3148@woody.linux-foundation.org> <20080111204228.GP18741@parisc-linux.org> <alpine.LFD.1.00.0801111311170.3148@woody.linux-foundation.org> <20080111211753.GR18741@parisc-linux.org> <alpine.LFD.1.00.0801111326120.3148@woody.linux-foundation.org> <20080111213803.GS18741@parisc-linux.org> <20080111235856.GA16079@jurassic.park.msu.ru> <20080112002638.GA18710@kroah.com> <20080112144030.GA19279@jurassic.park.msu.ru> <20080112094557.71f5382a@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080112094557.71f5382a@laptopd505.fenrus.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 12, 2008 at 09:45:57AM -0800, Arjan van de Ven wrote:
> btw this is my main objection to your patch; it intertwines the conf1 and mmconfig code even more.
> When (and I'm saying "when" not "if") systems arrive that only have MMCONFIG for some of the devices,
> we'll have to detangle this again, and I'm really not looking forward to that.

I think this will be OK.  We'll end up with three pci_ops, one for
mmconfig-only, one for mixed mmconfig-conf1 and one for conf1.  We could
do with that now actually -- the machines which will definitely go beserk
if you try to use mmconfig could have the conf1 ops on those busses.

Let's take Ivan's patch for now, and do that patch for 2.6.26.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
