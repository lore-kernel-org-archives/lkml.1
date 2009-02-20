Return-Path: <linux-kernel-owner+w=401wt.eu-S1756500AbZBTRcn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756500AbZBTRcn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 12:32:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755728AbZBTRcd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 12:32:33 -0500
Received: from rtsoft3.corbina.net ([85.21.88.6]:2926 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752990AbZBTRcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 12:32:32 -0500
Date: Fri, 20 Feb 2009 20:32:28 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Pierre Ossman <drzeus-sdhci@drzeus.cx>
Cc: Ben Dooks <ben-linux@fluff.org>, Arnd Bergmann <arnd@arndb.de>,
       Kumar Gala <galak@kernel.crashing.org>,
       Liu Dave <DaveLiu@freescale.com>, sdhci-devel@list.drzeus.cx,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: [PATCH 0/13] FSL eSDHC support
Message-ID: <20090220173228.GA5091@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1251
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Some updates for the eSDHC support:

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
