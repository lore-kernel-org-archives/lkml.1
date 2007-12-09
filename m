Return-Path: <linux-kernel-owner+w=401wt.eu-S1752781AbXLIH10@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752781AbXLIH10 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 02:27:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751164AbXLIH1S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 02:27:18 -0500
Received: from gate.crashing.org ([63.228.1.57]:56519 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750732AbXLIH1R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 02:27:17 -0500
Subject: Re: Please revert: PCI: fix IDE legacy mode resources
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Ralf Baechle <ralf@linux-mips.org>
Cc: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <20071209021231.GA13729@linux-mips.org>
References: <200710122305.l9CN5tFI008240@hera.kernel.org>
	 <1196899818.7033.11.camel@pasglop>
	 <200712060434.lB64YUtc023934@po-mbox305.hop.2iij.net>
	 <1196917447.7033.17.camel@pasglop>
	 <200712060558.lB65wAFu016256@po-mbox304.hop.2iij.net>
	 <1196922262.7033.33.camel@pasglop>  <20071209021231.GA13729@linux-mips.org>
Content-Type: text/plain
Date: Sun, 09 Dec 2007 18:24:51 +1100
Message-Id: <1197185091.6572.38.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 2007-12-09 at 02:12 +0000, Ralf Baechle wrote:
> So where do we stand with this?
> 
> As I understand the Cobalt system controller it is not possible to address
> ioport addresses below 0x10000000 at all on the PCI bus of the GT-64111.
> As such I think the best solution is a GT-64111-specific PCI fixup to
> clear out legacy resources.  The IDE controller in the VIA VT82C586 could
> then be used only by its normal that is non-legacy address and
> commit fd6e732186ab522c812ab19c2c5e5befb8ec8115 could be reverted and PPC
> would be happy too?

If that is the case though (that is it can't issue low ioport cycles),
how would have the fd6e7321...  worked in the first place ? Hrm...
strange. My understanding is that all that patch does is put junk in the
pci_dev resource structures :-) Maybe that's enough to cause the PCI
layer later on to be unhappy about them and reassign the BARs to some
place that works ? In which case, you are right, a better approach is a
quirk on this specific platform, or even better, mark 0...0x10000000
busy in ioport_resources and let the generic code clash & re-assign...

I must admit I'm a bit confused tho...

Anyway, so far, nobody is arguing in favor of keeping this patch in nor
so far trying and explanation on why it wouldn't be totally bogus, so I
suggest we revert it :-)

Cheers,
Ben.





