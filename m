Return-Path: <linux-kernel-owner+w=401wt.eu-S934933AbXHNToa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934933AbXHNToa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 15:44:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765666AbXHNToE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 15:44:04 -0400
Received: from straum.hexapodia.org ([64.81.70.185]:41374 "EHLO
	straum.hexapodia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759559AbXHNToB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 15:44:01 -0400
Date: Tue, 14 Aug 2007 12:43:56 -0700
From: Andy Isaacson <adi@hexapodia.org>
To: Andi Kleen <ak@suse.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Christoph Lameter <clameter@sgi.com>,
       Mel Gorman <mel@skynet.ie>, Lee.Schermerhorn@hp.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       linux-mips@linux-mips.org
Subject: Re: [PATCH 3/4] Embed zone_id information within the zonelist->zones pointer
Message-ID: <20070814194356.GL21492@hexapodia.org>
References: <Pine.LNX.4.64.0708131506030.28502@schroedinger.engr.sgi.com> <20070813230801.GH3406@bingen.suse.de> <Pine.LNX.4.64.0708131536340.29946@schroedinger.engr.sgi.com> <20070813234322.GJ3406@bingen.suse.de> <Pine.LNX.4.64.0708131553050.30626@schroedinger.engr.sgi.com> <20070814000041.GL3406@bingen.suse.de> <20070814002223.2d8d42c5@the-village.bc.nu> <20070814001441.GN3406@bingen.suse.de> <20070814191158.GB14093@hexapodia.org> <20070814202350.GT3406@bingen.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070814202350.GT3406@bingen.suse.de>
User-Agent: Mutt/1.4.2.2i
X-GPG-Fingerprint: 1914 0645 FD53 C18E EEEF C402 4A69 B1F3 68D2 A63F
X-GPG-Key-URL: http://web.hexapodia.org/~adi/gpg.txt
X-Domestic-Surveillance: money launder bomb tax evasion
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 14, 2007 at 10:23:51PM +0200, Andi Kleen wrote:
> > bcm43xx hardware does show up on low-end MIPS boxes (wrt54g anybody?)
> > that would be sorely hurt by excess copies.
> 
> Lowend boxes don't have more than 1GB of RAM. With <= 1GB you don't
> need to copy on bcm43xx.

OK, that makes sense and is reassuring, but note that some MIPS boxes
have only part of their physical memory below 1GB; IIRC the
BCM4704/BCM5836 supports up to 512MB of physical memory, with 256MB in
the first GB and the second 256MB located above the 1GB line.  (But it's
been a while since I've run such a machine, so I could be misremembering
the sizes and offsets.)

Yeah, if you stick a PCI chip with a 30-bit PCI DMA mask into a machine
with memory above 1GB, then copying has to happen.  Unless the memory
allocator can avoid returning memory in the un-dma-able region...

-andy
