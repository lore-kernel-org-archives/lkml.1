Return-Path: <linux-kernel-owner+w=401wt.eu-S1755510AbXFNURW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755510AbXFNURW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 16:17:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752381AbXFNURP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 16:17:15 -0400
Received: from smtp01.cdmon.com ([86.109.99.230]:60621 "EHLO smtp01.cdmon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752025AbXFNURO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 16:17:14 -0400
Date: Thu, 14 Jun 2007 22:17:14 +0200
From: DervishD <lkml@dervishd.net>
To: =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: ext2 on flash memory
Message-ID: <20070614201714.GC1928@DervishD>
Mail-Followup-To: =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
	Linux-kernel <linux-kernel@vger.kernel.org>
References: <20070611101319.GA14284@DervishD> <20070614174509.GB31984@lazybastard.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070614174509.GB31984@lazybastard.org>
User-Agent: Mutt/1.4.2.3i
Organization: DervishD
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

    Hi Jörn :)

 * Jörn Engel <joern@logfs.org> dixit:
> So let us look at the problems and how they interact with filesystems.
> 
> 1. Write overhead
> 
> If a filesystem only writes a small amount of data, typically 512 or
> 4096 bytes, smartmedia has to erase and write a full block.  Most
> flashes used in embedded systems has block sizes of 128KiB or so.  Most
> flashes used for smartmedia have 16KiB.  Writing 16KiB when the
> filesystem only requests writing 4KiB increases the wear 4x and reduces
> performance 4x.

    But this is not easily addressable by ext2... or FAT. Even if you
use 16KiB blocks in ext2, sometimes you will be writing only 512 bytes.
And FAT will be even worse, I imagine, when using 512-byte blocks. Won't
buffer cache (under Linux) alleviate this problem?

> 2. Wear leveling
> 
> Wear leveling happens implicitly by picking a different physical block
> from the spares on each write.  However, some blocks are never used.  If
> a physical block is mapped to a logical block that never gets written,
> it is out of the rotation.  Two seperate 1024-block areas have their
> internal wear leveling each, but nothing is spreading high wear from one
> area to another.

    I thought that wear leveling wasn't local to a group of blocks. This
means that you can destroy a flash memory by writing to the same
positions... which is a very common usage pattern.

> 4. FAT requirement
> 
> When I claimed there was nothing more to smartmedia, I was actually
> lying.  Smartmedia has the odd requirement that only FAT is supported as
> a filesystem.  In fact, the specifications describe FAT in great detail.

    Right, but I've seen many people using their pendrives with ext2
with no problems (e.g. for SLAX). So, what do you mean by "supported"?
If a filesystem can be used with the memory, do you mean that wear
leveling and other characteristics of the flash memory are tailored for
FAT? or do you mean you cannot use reliably (read: you will lose data)
other filesystems?

> a) Do wear leveling!
> 
> Smartmedia wear leveling is limited to within areas.  Any cross-device
> wear leveling must be done by the filesystem.  FAT does that fairly
> well.  The Ext family doesn't.

    Cross-device wear leveling? I don't understand, sorry O:)

    Thanks for your explanation, it has been very educational :)

    Raúl Núñez de Arenas Coronado

-- 
Linux Registered User 88736 | http://www.dervishd.net
It's my PC and I'll cry if I want to... RAmen!
