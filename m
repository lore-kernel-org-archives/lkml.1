Return-Path: <linux-kernel-owner+w=401wt.eu-S1763063AbYFGRVW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763063AbYFGRVW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2008 13:21:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756815AbYFGRVP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jun 2008 13:21:15 -0400
Received: from lana.hrz.tu-chemnitz.de ([134.109.132.3]:36466 "EHLO
	lana.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754892AbYFGRVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2008 13:21:14 -0400
X-Greylist: delayed 1871 seconds by postgrey-1.27 at vger.kernel.org; Sat, 07 Jun 2008 13:21:14 EDT
From: Stefan Bauer <stefan.bauer@cs.tu-chemnitz.de>
Organization: Chemnitz University of Technology
To: linux-kernel@vger.kernel.org
Subject: [RFC] quirk_ich4_lpc_acpi() clarification
Date: Sat, 7 Jun 2008 18:49:50 +0200
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 2939
Cc: "Nakajima, Jun" <jun.nakajima@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200806071849.51192.stefan.bauer@cs.tu-chemnitz.de>
X-Spam-Score: -1.4 (-)
X-Spam-Report: --- Start der SpamAssassin 3.2.4 Textanalyse (-1.4 Punkte)
	Fragen an/questions to:  Postmaster TU Chemnitz <postmaster@tu-chemnitz.de>
	-1.4 ALL_TRUSTED            Nachricht wurde nur ueber vertrauenswuerdige Rechner
	weitergeleitet
	--- Ende der SpamAssassin Textanalyse
X-Scan-Signature: 67388a68055134b384ea872eafacefb2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


I was wondering why my quite ancient i815-based machine with ICH (not ICH4) 
southbridge told me on startup:

pci 0000:00:1f.0: quirk: region 4000-407f claimed by ICH4 ACPI/GPIO/TCO
pci 0000:00:1f.0: quirk: region 4080-40bf claimed by ICH4 GPIO

Some search brought up that this quirk was originally registered for ICH4 and
ICH5 [1], but later extended to apply for ICH to ICH3, too [2].

The comment added by Linus in [2], telling "Intel LPC interface bridges all 
have 128 bytes of magic ACPI/TCO regs and 64 bytes of GPIO", unfortunately 
got lost with [3].

So in current state we have some uncertainty: Does "all" mean "all until now" 
or "all ever using LPC"? In the last case not only comments, but also 
DECLARE_PCI_FIXUP_HEADERs for the past-ICH5 chipsets would be missing.

I would like to fix this by...
- mentioning all affected ICHs in the comment
- probably give a better 'name' parameter then "ICH4 ..." to quirk_io_region()
- probably rename quirk_ich4_lpc_acpi()
- add DECLARE_PCI_FIXUP_HEADERs for eventually missing devices

But I need some information, especially if past-ICH5 southbridges have got
this quirk, too.


Regards, Stefan Bauer

[1] Add a quirk for the Intel ICH-[45] to add special ACPI regions.
http://git.kernel.org/?p=linux/kernel/git/torvalds/old-2.6-bkcvs.git;a=blobdiff;f=drivers/pci/quirks.c;h=0fe0f7656939ba8b2b55e55d2ac4fbe12dee59fa;hp=29313362a8b663ee85a43bcd7f70220bd64598e4;hb=0b7baee8e18d8d309b3918769fc4b60dc075baa5;hpb=7886b5151d14bde184e490201ad51a3f413df8d9

[2] All the Intel LPC bridges have the same PCI quirks.
http://git.kernel.org/?p=linux/kernel/git/torvalds/old-2.6-bkcvs.git;a=blobdiff;f=drivers/pci/quirks.c;h=b82a1c31e1df64a8aedb5c868d4e62979cc5fc19;hp=2a2a2f11f3d1a6732c4d119efc62cf74a174b4f8;hb=ca2a9e5a6a068b446ba0829385f9785695df9182;hpb=3b4871d830f2ace4c6dafe33272e0bb2ec8f83fb

[3] Merge http://nfsclient.bkbits.net/linux-2.6
http://git.kernel.org/?p=linux/kernel/git/torvalds/old-2.6-bkcvs.git;a=blobdiff;f=drivers/pci/quirks.c;h=164f738df6a7cb1c58f1033382530780a211e039;hp=6e7c350133becd05268d1cb6fa6073019c63457b;hb=ee66a188d8cd63c8baf60f7be2a24faf9d556bbd;hpb=9a1ad97be320d53eba3cdb6a69fbbea27a862461
