Return-Path: <linux-kernel-owner+w=401wt.eu-S1752539AbXL1VMB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752539AbXL1VMB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 16:12:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752234AbXL1VLu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 16:11:50 -0500
Received: from jurassic.park.msu.ru ([195.208.223.243]:60584 "EHLO
	jurassic.park.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752199AbXL1VLu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 16:11:50 -0500
Date: Sat, 29 Dec 2007 00:12:19 +0300
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
To: Loic Prylli <loic@myri.com>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Daniel Barkalow <barkalow@iabervon.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Kai Ruhnau <kai@tragetaschen.dyndns.org>,
       Robert Hancock <hancockr@shaw.ca>, Jeff Garzik <jeff@garzik.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       gregkh@suse.de, linux-pci <linux-pci@atrey.karlin.mff.cuni.cz>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Martin Mares <mj@ucw.cz>, Matthew Wilcox <matthew@wil.cx>
Subject: Re: [Patch v2] Make PCI extended config space (MMCONFIG) a driver
	opt-in
Message-ID: <20071228211219.GA10475@jurassic.park.msu.ru>
References: <alpine.LFD.0.9999.0712271328010.21557@woody.linux-foundation.org> <alpine.LFD.0.9999.0712271338280.21557@woody.linux-foundation.org> <47742498.1060900@tragetaschen.dyndns.org> <alpine.LNX.1.00.0712272204520.13593@iabervon.org> <alpine.LFD.0.9999.0712272129290.21557@woody.linux-foundation.org> <alpine.LNX.1.00.0712280036330.13593@iabervon.org> <20071228103451.GA28694@jurassic.park.msu.ru> <20071228081418.08b60228@laptopd505.fenrus.org> <20071228163841.GA9409@jurassic.park.msu.ru> <47753525.3010701@myri.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47753525.3010701@myri.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 28, 2007 at 12:40:53PM -0500, Loic Prylli wrote:
> The only quirk I see removed is a bitmap with an arbitrary size (that we
> don't really know is sufficient for every system), and that is only
> built using comparison between mmconf and type1 accesses.  IMHO, there
> is zero knowledge in that removed code (no knowledge about specific
> chipsets that work or don't work, or misleading BIOSes).

Precisely.

As a side note: that code also has zero knowledge about what the generic
PCI probe code can do later, like it fails to detect this ATI/CRS breakage.

> One thing that could be changed in pci_cfg_space_size() is to avoid
> making a special case for PCI-X 266MHz/533Mhz (assume cfg_size == 256
> for such devices too, reserve extended cfg-space for pci-express
> devices). There is good reasons to think no such PCI-X 266Mhz/533 device
> will ever have an extended-space (no capability IDs was ever defined in
> the PCI-X 2.0 spec, no new revision is planned). Such a check would
> avoid the possibility of trying extended-conf-space access for PCI-X 2.0
> devices behind a amd-8132 or similar (such accesses would just returnd
> -1, but there was some objections raised about doing anything like that
> other than at initialization time, even if there is ample reasons to
> argue it would be harmless).

I agree, we should remove it. IIRC, this PCI-X check was written
long ago with some draft (not a final spec) in hands. Matthew?

Ivan.
