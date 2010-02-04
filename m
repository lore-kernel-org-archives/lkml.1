Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754189Ab0BDIRH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 03:17:07 -0500
Received: from trinity.fluff.org ([89.16.178.74]:47295 "EHLO trinity.fluff.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751072Ab0BDIRB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 03:17:01 -0500
Date: Thu, 4 Feb 2010 08:16:54 +0000
From: Ben Dooks <ben-linux@fluff.org>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org,
       Nios2 development list <nios2-dev@sopc.et.ntust.edu.tw>,
       linux-kernel@vger.kernel.org, Ian Abbott <abbotti@mev.co.uk>,
       Thomas Abraham <thomas.ab@samsung.com>,
       Thomas Chou <thomas@wytron.com.tw>, ben-linux@fluff.org,
       linux-arm-kernel@lists.infradead.org
Subject: Re: [git patches] new hardware support for atang tree
Message-ID: <20100204081654.GD13267@trinity.fluff.org>
References: <201002031940.20129.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201002031940.20129.bzolnier@gmail.com>
X-Disclaimer: These are my views alone.
X-URL: http://www.fluff.org/
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@trinity.fluff.org
X-SA-Exim-Scanned: No (on trinity.fluff.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 03, 2010 at 07:40:20PM +0100, Bartlomiej Zolnierkiewicz wrote:
> 
> Since I haven't seen any progress on mainstreaming of s3c-ide and
> pata_altera_cf patches in the recent months I decided to merge them
> into staging section of my tree in order to help in keeping them
> in-sync with ongoing changes..

Please be aware the plat-s3c64xx and plat-s3c is currently in the process
of being removed, the s3c64xx is an development dead-end and thus we know
exactly what has to be supported, plat-s3c is getting so empty i've shoved
the stuff either up into plat-s3c24xx or down into plat-samsung.

Quite a lot of this change is currently in RMK's trees, the rest is just
being finalised for submission next week.

I might be interested in taking the platform definitions into my tree
as the registers should be usable either for libata or ide.
 
> DISCLAIMER: the fact of getting patches merged into atang tree means
> that from now on they will be getting updates for changes happening
> in atang tree and it should not be treated as an indication regarding
> decisions taken by 'upstream' kernel trees
> 
> 
> The following changes since commit 18c77417cbb9c595935d5ccb2e55309f0fb75a06:
>   Bartlomiej Zolnierkiewicz (1):
>         ide: remove hwif_chipset_t type
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/bart/misc.git atang-v4.4
> 
> Thomas Abraham (8):
>       S3C64XX: Add physical address definition for Compact Flash controller.
>       S3C64XX: Add MEM_SYS_CFG register definition.
>       S3C64XX: Add IDE controller register definitions.
>       S3C64XX: Add clock source definition for IDE controller.
>       S3C64XX: Add platform data and driver resources for IDE controller driver.
>       S3C6410: Add platform data for S3C IDE controller driver
>       S3C64XX: Include IDE device code in compilation.
>       drivers/staging: Add Samsung S3C IDE controller driver
> 
> Thomas Chou (1):
>       drivers/staging: New PATA driver for Altera CompactFlash.
> 
>  arch/arm/mach-s3c6400/include/mach/map.h        |    4 +
>  arch/arm/mach-s3c6410/mach-smdk6410.c           |   14 +-
>  arch/arm/plat-s3c/include/plat/devs.h           |    1 +
>  arch/arm/plat-s3c/include/plat/ide.h            |   36 +
>  arch/arm/plat-s3c/include/plat/regs-ide.h       |   56 ++
>  arch/arm/plat-s3c64xx/Makefile                  |    1 +
>  arch/arm/plat-s3c64xx/clock.c                   |    6 +
>  arch/arm/plat-s3c64xx/dev-ide.c                 |   88 +++
>  arch/arm/plat-s3c64xx/include/plat/regs-clock.h |    3 +
>  drivers/staging/Kconfig                         |    4 +
>  drivers/staging/Makefile                        |    2 +
>  drivers/staging/pata_altera_cf/Kconfig          |   11 +
>  drivers/staging/pata_altera_cf/Makefile         |    1 +
>  drivers/staging/pata_altera_cf/TODO             |    5 +
>  drivers/staging/pata_altera_cf/pata_altera_cf.c |  582 ++++++++++++++++
>  drivers/staging/s3c-ide/Kconfig                 |    8 +
>  drivers/staging/s3c-ide/Makefile                |    1 +
>  drivers/staging/s3c-ide/TODO                    |    6 +
>  drivers/staging/s3c-ide/s3c-ide.c               |  822 +++++++++++++++++++++++
>  19 files changed, 1650 insertions(+), 1 deletions(-)
>  create mode 100644 arch/arm/plat-s3c/include/plat/ide.h
>  create mode 100644 arch/arm/plat-s3c/include/plat/regs-ide.h
>  create mode 100644 arch/arm/plat-s3c64xx/dev-ide.c
>  create mode 100644 drivers/staging/pata_altera_cf/Kconfig
>  create mode 100644 drivers/staging/pata_altera_cf/Makefile
>  create mode 100644 drivers/staging/pata_altera_cf/TODO
>  create mode 100644 drivers/staging/pata_altera_cf/pata_altera_cf.c
>  create mode 100644 drivers/staging/s3c-ide/Kconfig
>  create mode 100644 drivers/staging/s3c-ide/Makefile
>  create mode 100644 drivers/staging/s3c-ide/TODO
>  create mode 100644 drivers/staging/s3c-ide/s3c-ide.c
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

-- 
-- 
Ben

Q:      What's a light-year?
A:      One-third less calories than a regular year.

