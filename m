Return-Path: <linux-kernel-owner+w=401wt.eu-S1754498AbXLFFnW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754498AbXLFFnW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 00:43:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752339AbXLFFnO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 00:43:14 -0500
Received: from mfo32.po.2iij.net ([210.128.50.15]:2565 "EHLO mfo32.po.2iij.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752224AbXLFFnN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 00:43:13 -0500
X-Greylist: delayed 4029 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Dec 2007 00:43:13 EST
Message-Id: <200712060434.lB64YUtc023934@po-mbox305.hop.2iij.net>
Date: Thu, 6 Dec 2007 13:34:32 +0900
From: Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>
To: benh@kernel.crashing.org
Cc: yoichi_yuasa@tripeaks.co.jp,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>, Ralf Baechle <ralf@linux-mips.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Please revert: PCI: fix IDE legacy mode resources
In-Reply-To: <1196899818.7033.11.camel@pasglop>
References: <200710122305.l9CN5tFI008240@hera.kernel.org>
	<1196899818.7033.11.camel@pasglop>
Organization: TriPeaks Corporation
X-Mailer: Sylpheed version 2.3.0beta5 (GTK+ 2.8.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 06 Dec 2007 11:10:18 +1100
Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:

> The commit below that was merged in october looks bogus to me.
> 
> At this stage in the PCI probe, the pci_dev->resource's contain RAW bar
> values, that is bus values..
> 
> A PCI legacy IDE controller that hard decodes 0x1f0 etc...  does such as
> bus values as well. That is, the resources should contain 0x1f0...0x1f7
> etc... -not- some kind of transformed values, because that's exactly
> what a BAR would contain if it had been read from the device by
> pci_read_bases() and we haven't performed any fixup yet.
> 
> If the platform offsets resources, like powerpc does, it should do so
> later on in a fixup pass (on ppc, we use either a header quirk or
> fixup_bus depending on the phase of the moon) and that should work
> fine. 
> 
> I don't understand how his fix can work on MIPS nor why the previous
> code didn't, but I don't know how MIPS does its remapping tricks,
> however it will definitely -not- work on powerpc (and will break a
> couple of machines out there).

MIPS pcibios_fixup_bus() converts RAW BAR values(including offset) to resource values.
How does it fix up on powerpc?

Yoichi 
