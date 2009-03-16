Return-Path: <linux-kernel-owner+w=401wt.eu-S1760486AbZCPVNY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760486AbZCPVNY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 17:13:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753887AbZCPVNK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 17:13:10 -0400
Received: from [213.79.90.228] ([213.79.90.228]:1983 "EHLO
	buildserver.ru.mvista.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753811AbZCPVNJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 17:13:09 -0400
Date: Tue, 17 Mar 2009 00:13:06 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Pierre Ossman <drzeus-sdhci@drzeus.cx>
Cc: Ben Dooks <ben-linux@fluff.org>, Arnd Bergmann <arnd@arndb.de>,
       Kumar Gala <galak@kernel.crashing.org>,
       Liu Dave <DaveLiu@freescale.com>, sdhci-devel@list.drzeus.cx,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: [PATCH v3 0/11] FSL eSDHC support
Message-ID: <20090316211306.GA1736@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1251
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Here comes another version, let's hope that one is final. ;-)

Changes since v2:
- Introduced MMC_SDHCI_IO_ACCESSORS Kconfig symbol. If not selected,
  SDHCI will just use PCI memory accessors unconditionally.
- Added MAINTAINERS entry.

Changes since v1:
- "Add support for bus-specific IO memory accessors" patch no longer
  touches sdhci-pci. The changes were no longer needed since I dropped
  "Add type checking ..." patch back in RFCv2;
- Patch "Add support for hosts with strict 32 bit addressing" dropped.
  Now we handle the 32 bit magic in eSDHC's writew() accessor;
- Patch "Add quirk for controllers with max. block size up to 4096 bytes"
  replaced by "Add quirk for forcing maximum block size to 2048 bytes";
- SDHCI_INT_ALL_MASK changed to (unsigned int)-1;
- Addressed Pierre's comments in "Add support for card-detection polling"
  patch.

Changes since the third RFC:
- Use uninitialized_var() (suggested by Laurent Pinchart);
- Fixed a bug in eSDHC SDCLK prescaler calculations because of which
  we were over-clocking the SDCLK, and that caused CRC errors using some
  SD cards;
- Not a change, but some status: SDHS (50 MHz) cards were tested to
  NOT work (at least on MPC837x boards) -- this is to be investigated
  further. SDHC (> 4 GB) cards were not tested, yet.

Changes since the second RFC:
- Addressed all comments that were raised by Pierre Ossman.
  There were too many to mention them all, so here is the link:
  http://lkml.org/lkml/2009/2/6/320

Changes since the first RFC:
- Use of_iomap() in sdhci-of.c (suggested by Arnd Bergmann). Also added
  Arnd's Acked-by: line for the sdhci-of patch.
- Kconfig help text improved (thanks to Matt Sealey and M. Warner Losh).
- In "sdhci: Add quirk to suppress PIO interrupts during DMA transfers"
  patch: sdhci_init() now clears SDHCI_PIO_DISABLED flag, otherwise we
  won't disable PIO interrupts after suspend.
- New patch: "sdhci: Add type checking for IO memory accessors"

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
