Return-Path: <linux-kernel-owner+w=401wt.eu-S1760044AbYHCWdx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760044AbYHCWdx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 18:33:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757409AbYHCWdp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 18:33:45 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:43042 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757306AbYHCWdo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 18:33:44 -0400
Date: Sun, 3 Aug 2008 23:16:28 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: linasvepstas@gmail.com
Cc: "John Stoffel" <john@stoffel.org>,
       "Alistair John Strachan" <alistair@devzero.co.uk>,
       linux-kernel@vger.kernel.org
Subject: Re: amd64 sata_nv (massive) memory corruption
Message-ID: <20080803231628.1361b75f@lxorguk.ukuu.org.uk>
In-Reply-To: <3ae3aa420808031523i1d9559d9i19dd5fcc9d5719c7@mail.gmail.com>
References: <3ae3aa420808011030weadc61fvf6f850f0a4cfcb3e@mail.gmail.com>
	<200808012319.05038.alistair@devzero.co.uk>
	<3ae3aa420808011951l58da4010r1ff0876f255565b0@mail.gmail.com>
	<18580.48861.657366.629904@stoffel.org>
	<3ae3aa420808021501k2e871dc0y344dd7f9a7b80614@mail.gmail.com>
	<18581.6873.353028.695909@stoffel.org>
	<3ae3aa420808031523i1d9559d9i19dd5fcc9d5719c7@mail.gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I then did some more debugging, and isolated the original data corruption
> problem to a bad pair of RAM sticks. But this was subtle, so let me recap:
> 
> -- The bad ram passes memtest86+

You are assuming bad RAM then not bad bus loadings, corrosion on the
pins.. ?

> So I'm wondering: can we devise a test to validate system-bus interactions
> like this? Clearly, the memtest86 test validates the RAM and the northbridge
> bus between CPU and system RAM, so that seems OK.

If you have a good enough pile of hardware and the right monitoring stuff
loaded then you should get EDAC event logs from the PCI/PCI-X for PCI
card logged traps, MCE errors for the higher level busses, L1/L2 cache or
CPU parity errors and ECC traps for memory problems either via EDAC or
MCE.

If you are using a generic end user motherboard then you don't.

> doesn't exist. I have no clue about SATA.  Is there possibly some ide or
> scsi command that can be used to loop-back? Some sort of "send bytes
> to disk, but don't actually write them to platter" command? Maybe just
> a write to some scratch ram on the disk drive itself? Even just a few bytes

Yes for SCSI. In theory yes for ATA but I've never tested to see what the
level of actual support is, and I'm not sure you can test it in DMA mode.

> would be enough to implement a loopback test. Maybe some sort of

For the simpler cases perhaps. The more interesting approaches I think
are the fs level ones where you accept the fact that hardware sucks and
do end to end checksumming from the fs or even the app in some
situations. We don't yet have that functionality mainstream although it
might make an interesting device mapper module ...


Alan
