Return-Path: <linux-kernel-owner+w=401wt.eu-S1754167AbYAMGCM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754167AbYAMGCM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2008 01:02:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751310AbYAMGB5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jan 2008 01:01:57 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:37548 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301AbYAMGB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2008 01:01:56 -0500
Date: Sat, 12 Jan 2008 23:01:54 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Loic Prylli <loic@myri.com>, Arjan van de Ven <arjan@infradead.org>,
       Daniel Barkalow <barkalow@iabervon.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Kai Ruhnau <kai@tragetaschen.dyndns.org>,
       Robert Hancock <hancockr@shaw.ca>, Jeff Garzik <jeff@garzik.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       gregkh@suse.de, linux-pci <linux-pci@atrey.karlin.mff.cuni.cz>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Martin Mares <mj@ucw.cz>
Subject: Re: [Patch v2] Make PCI extended config space (MMCONFIG) a driver opt-in
Message-ID: <20080113060154.GZ18741@parisc-linux.org>
References: <alpine.LFD.0.9999.0712271338280.21557@woody.linux-foundation.org> <47742498.1060900@tragetaschen.dyndns.org> <alpine.LNX.1.00.0712272204520.13593@iabervon.org> <alpine.LFD.0.9999.0712272129290.21557@woody.linux-foundation.org> <alpine.LNX.1.00.0712280036330.13593@iabervon.org> <20071228103451.GA28694@jurassic.park.msu.ru> <20071228081418.08b60228@laptopd505.fenrus.org> <20071228163841.GA9409@jurassic.park.msu.ru> <47753525.3010701@myri.com> <20071228211219.GA10475@jurassic.park.msu.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071228211219.GA10475@jurassic.park.msu.ru>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 29, 2007 at 12:12:19AM +0300, Ivan Kokshaysky wrote:
> On Fri, Dec 28, 2007 at 12:40:53PM -0500, Loic Prylli wrote:
> > One thing that could be changed in pci_cfg_space_size() is to avoid
> > making a special case for PCI-X 266MHz/533Mhz (assume cfg_size == 256
> > for such devices too, reserve extended cfg-space for pci-express
> > devices). There is good reasons to think no such PCI-X 266Mhz/533 device
> > will ever have an extended-space (no capability IDs was ever defined in
> > the PCI-X 2.0 spec, no new revision is planned). Such a check would
> > avoid the possibility of trying extended-conf-space access for PCI-X 2.0
> > devices behind a amd-8132 or similar (such accesses would just returnd
> > -1, but there was some objections raised about doing anything like that
> > other than at initialization time, even if there is ample reasons to
> > argue it would be harmless).
> 
> I agree, we should remove it. IIRC, this PCI-X check was written
> long ago with some draft (not a final spec) in hands. Matthew?

I have what I believe to be the released version of PCI-X 2.0a (July
22, 2003).  It is quite clear that Mode 2 devices (ie those running at
266MHz or 533MHz) are required to support all 4096 bytes of extended
config space.

More to the point, I don't think we have any bug reports suggesting that
PCI-X Mode 2 devices/bridges have any problems.  There are relatively
few of them in existance, and my impression is that PCI-X2 is only being
implemented on server-class machines.  'Consumer grade' equipment is
where all the problems lie anyway.

While the PCI-X 2.0a spec does not define any Extended Capability IDs,
it simply states that "This field is a PCI-SIG defined ID number that
indicates the nature and format of the Extended Capabilities List item".
The PCIe spec does define Extended Capability IDs, and I would think
it's entirely appropriate to use the same IDs for PCI-X Mode 2 devices.

So I don't believe any change in this area is appropriate.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
