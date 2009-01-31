Return-Path: <linux-kernel-owner+w=401wt.eu-S1753607AbZAaV3a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753607AbZAaV3a (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 16:29:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751380AbZAaV3V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 16:29:21 -0500
Received: from mailrelay007.isp.belgacom.be ([195.238.6.173]:25473 "EHLO
	mailrelay007.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751211AbZAaV3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 16:29:20 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgUFAC9RhEnCTtAn/2dsb2JhbACBbsVzhBQGhT8
Date: Sat, 31 Jan 2009 22:29:15 +0100
From: Philippe De Muyter <phdm@macqel.be>
To: linux-kernel@vger.kernel.org, abelay@mit.edu, bjorn.helgaas@hp.com
Subject: [BUG] pnpbios breaks floppy support
Message-ID: <20090131212915.GA19276@frolo.macqel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello linux experts,

Today I tried to upgrade a PC's kernel from 2.6.11 to 2.6.22, and
I saw some strange messages when booting :

	Floppy drive(s): fd0 is 1.44M
	floppy0: Floppy io-port 0x03f2 in use

Previously, I had :

	Floppy drive(s): fd0 is 1.44M
	FDC 0 is a post-1991 82077

Needless to say, my floppy hardware works perfectly, and my floppy
was usable with the old kernel, while the floppy is now inaccessible
with the new kernel.  Even /dev/fd0 does not exist anymore.

Searching for a cause to that problem, I saw the following messages
before the floppy probe in the new kernel :

	PnPBIOS: Scanning system for PnP BIOS support...
	PnPBIOS: Found PnP BIOS installation structure at 0xc00fd5e0
	PnPBIOS: PnP BIOS version 1.0, entry 0xf0000:0x5ba3, dseg 0xf0000
	PnPBIOS: 17 nodes reported by PnP BIOS; 17 recorded by driver
	[...]
	pnp: 00:07: ioport range 0x3f0-0x3f1 has been reserved
	pnp: 00:07: ioport range 0x3f3-0x3f3 has been reserved
	[...]

Searching the web and the outdated pnp kernel documentation, I
finally found an option to add to my kernel parameters line :

	pnpbios=off

Now my floppy works again, but I am not really satisfied.

What do I loose with the 'pnpbios=off' option ?

Isn't there a smoother option to allow pnpbios but avoiding to reserve
floppy's io-ports ?

Should I modify rather /drivers/block/floppy.c or /drivers/pnp/*.c
to make pnpbios and floppy driver coexist peacefully ? And is there
an example of such modifications for other standard peripherals ?

Thanks for reading this far

Philippe
