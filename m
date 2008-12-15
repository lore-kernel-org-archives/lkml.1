Return-Path: <linux-kernel-owner+w=401wt.eu-S1754081AbYLOW0Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754081AbYLOW0Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 17:26:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751844AbYLOW0R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 17:26:17 -0500
Received: from mho-01-bos.mailhop.org ([63.208.196.178]:55878 "EHLO
	mho-01-bos.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810AbYLOW0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 17:26:16 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 69.181.40.92
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18WO/kVVvj4sF/+nZtvLX9B
Date: Mon, 15 Dec 2008 14:26:13 -0800
From: Tony Lindgren <tony@atomide.com>
To: drzeus-mmc@drzeus.cx, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk
Cc: linux-omap@vger.kernel.org
Subject: git pull request for omap mmc init changes (Re: [PATCH 0/5] Omap
	MMC init updates and new controller for 2.6.29 merge window)
Message-ID: <20081215222612.GA19551@atomide.com>
References: <20081207213617.10456.43951.stgit@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="YZ5djTAD1cGYuMQK"
Content-Disposition: inline
In-Reply-To: <20081207213617.10456.43951.stgit@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--YZ5djTAD1cGYuMQK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

* Tony Lindgren <tony@atomide.com> [081207 13:45]:
> Hi Pierre & Russell,
> 
> This series contains a better platform init for omap MMC as discussed earlier
> on the linux-omap mailing list. The last patch in the series adds support for
> a newer omap MMC controller available on 2430 and 34xx omaps.
> 
> The first four patches should get merged via Russell. The last one adding
> the new controller depends on comments from Pierre, so I can separate
> that out if desired.
> 
> The third patch in the series depends on the "Omap3 updates for 2.6.29
> merge window" series for the changes to Pandora board support.
> 
> Comments welcome as always!

Russell, here's a pull request for the first four patches in this
series for the mmc init changes. This depends on the omap3-upstream
pull request posted earlier today.

I'm not including the actual driver in this series, that should go via
Pierre. Or at least we should have an ack from Pierre first.

Regards,

Tony

--YZ5djTAD1cGYuMQK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="pull-mmc-init.txt"

The following changes since commit 2619bc327417f549f1c89d5ef9b4a4aa768f41a2:
  Arun KS (1):
        ARM: OMAP3: Pin multiplexing updates for 24xx and 34xx

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap-2.6.git hsmmc-init

Kevin Hilman (1):
      omap mmc: force MMC module reset on boot

Tony Lindgren (3):
      omap mmc: Remove broken MMC init code
      omap mmc: Add better MMC low-level init
      omap mmc: Add low-level initialization for hsmmc controller

 arch/arm/mach-omap1/board-h2-mmc.c         |   89 +++----
 arch/arm/mach-omap1/board-h2.c             |   25 +-
 arch/arm/mach-omap1/board-h3-mmc.c         |  100 ++-----
 arch/arm/mach-omap1/board-h3.c             |   10 -
 arch/arm/mach-omap1/board-innovator.c      |   50 +++-
 arch/arm/mach-omap1/board-nokia770.c       |   74 ++++-
 arch/arm/mach-omap1/board-palmte.c         |    1 -
 arch/arm/mach-omap1/board-palmz71.c        |   11 -
 arch/arm/mach-omap1/board-sx1-mmc.c        |   80 +-----
 arch/arm/mach-omap1/board-sx1.c            |   10 -
 arch/arm/mach-omap1/board-voiceblue.c      |   10 +-
 arch/arm/mach-omap1/clock.h                |    3 +-
 arch/arm/mach-omap1/devices.c              |   90 ++++++
 arch/arm/mach-omap2/Makefile               |   15 +-
 arch/arm/mach-omap2/board-2430sdp.c        |   48 ++++
 arch/arm/mach-omap2/board-apollon.c        |   11 -
 arch/arm/mach-omap2/board-generic.c        |   11 -
 arch/arm/mach-omap2/board-h4.c             |   11 -
 arch/arm/mach-omap2/board-ldp.c            |   40 +++-
 arch/arm/mach-omap2/board-omap3beagle.c    |   90 ++++++
 arch/arm/mach-omap2/board-omap3pandora.c   |   32 +++
 arch/arm/mach-omap2/board-overo.c          |   43 +++
 arch/arm/mach-omap2/clock24xx.h            |    9 +-
 arch/arm/mach-omap2/clock34xx.h            |   10 +-
 arch/arm/mach-omap2/devices.c              |  169 ++++++++++++
 arch/arm/mach-omap2/mmc-twl4030.c          |  408 ++++++++++++++++++++++++++++
 arch/arm/mach-omap2/mmc-twl4030.h          |   29 ++
 arch/arm/plat-omap/devices.c               |  225 +++-------------
 arch/arm/plat-omap/include/mach/board-h2.h |    6 +-
 arch/arm/plat-omap/include/mach/board.h    |   22 --
 arch/arm/plat-omap/include/mach/control.h  |   17 ++
 arch/arm/plat-omap/include/mach/mmc.h      |   74 +++++-
 drivers/mmc/host/omap.c                    |    7 +-
 33 files changed, 1282 insertions(+), 548 deletions(-)
 create mode 100644 arch/arm/mach-omap2/mmc-twl4030.c
 create mode 100644 arch/arm/mach-omap2/mmc-twl4030.h

--YZ5djTAD1cGYuMQK--
