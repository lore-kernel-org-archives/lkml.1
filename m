Return-Path: <linux-kernel-owner+w=401wt.eu-S1752620AbZHYNUd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752620AbZHYNUd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 09:20:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752447AbZHYNUb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 09:20:31 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:34108 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752426AbZHYNUb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 09:20:31 -0400
To: Pablo Bitton <pablo.bitton@gmail.com>
Cc: davinci-linux-open-source@linux.davincidsp.com,
       linux-kernel@vger.kernel.org, s-paulraj@ti.com,
       David Brownell <david-b@pacbell.net>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2] SPI: DaVinci: Adding SPI driver for DaVinci
References: <20090817172612.1dfa74a5.pablo.bitton@gmail.com>
	<7448ec710908250504v1c5eb12fl109481a5d7716747@mail.gmail.com>
From: Kevin Hilman <khilman@deeprootsystems.com>
Organization: Deep Root Systems, LLC
Date: Tue, 25 Aug 2009 16:20:27 +0300
In-Reply-To: <7448ec710908250504v1c5eb12fl109481a5d7716747@mail.gmail.com> (Pablo Bitton's message of "Tue\, 25 Aug 2009 15\:04\:08 +0300")
Message-ID: <87skfgdo84.fsf@deeprootsystems.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pablo Bitton <pablo.bitton@gmail.com> writes:

> The patch has received no comments so far (here and on spi-general-devel).
>
> Can someone test it on davinci's other that the DM6446 to see that support for
> others has not broken?
>
> Kevin - Is there anything that keeps it from merging upstream to this tree?

Hi Pablo,

Sorry for the delay, I've been travelling and not able to watch
DaVinci closely enough...

This driver should be merged via the SPI subsystem (maintained by
David Brownell), not the Davinci core code which I maintain.

That being said, in my view, here's why this driver is not ready for
upstream:

1) The original driver from Sandeep that you based yours on was still
   going through revisions.  The last review comments[1] from David
   Brownell had not yet been addressed by Sandeep.  I hope that
   Sandeep will have a chance to address the existing review comments
   on his code, and then review yours.  However, you've made it
   rather difficult to do that because...

2) You should have your patch apply on top of Sandeep's series, not
   just absorb it.  That way we can clearly see what you are adding
   and/or changing from Sandeeps original driver.  To make this part
   easier, I created a 'temp/spi' branch of davinci git where I've
   pushed the latest versions of the patches from Sandeep.  Any
   additions/updates/fixes you have should be posted as patches
   against that for easier discussion and review.

3) As Sandeep did, you should keep the changes to the board/SoC code
   (arch/arm/mach-davinci/*) as a separate patch from the driver code
   (drivers/spi/*)

4) this driver needs more testing

> So far, the patch has been added to the -mm tree - http://git.zen-sources.org/?
> p=mmotm.git;a=commit;h=b693ea09ae2fb5c382ef7f2772d6115af1f9b4fc.
> Its filename is spi-davinci-adding-spi-driver-for-davinci.patch.

Andrew, I would recommend dropping this from -mm until the 
above issues are addressed.

Thanks,

Kevin  (maintainer: arch/arm/mach-davinci/*)

[1] http://linux.omap.com/pipermail/davinci-linux-open-source/2009-July/014828.html

> On Mon, Aug 17, 2009 at 5:26 PM, Pablo Bitton <pablo.bitton@gmail.com> wrote:
>
>
>     This patch adds support for SPI in DaVinci DM6446
>      (and tries to keep support for DM355/DM365/DM6467 and DA8xx).
>     Mostly the same as the patch by Sandeep Paulraj.
>
>     This has been tested on the DM6446 by defining a spidev device and using a
>     scope (to check correctness) and a hardware loopback.
>     This was NOT tested on DM355, DM365 and DM6467 - in fact, it will probably
>     not work "as is" because its default mode is CS low-inactive (default mode
>     of SPI in kernel) - need to set CS_HIGH mode to work as in the previous
>     patch.
>
>     Changes from the patch by Sandeep Paulraj:
>
>     Bug fixes:
>      * Additional word written with chip select up after each transfer.
>       Particulary problematic with NO_CS mode where this word can't be
>       distiguished from correct words. Problem was in davinci_chip_select.
>      * setup() for one chip select may interfere with transfer for another
>      * Small nitpicks (bits that can be changed only on VERSION_2)
>
>     Features added:
>      * Support DM6446
>      * Support CS_HIGH mode (using SPIDEF register). Note that CS low is
>     default.
>
>     Other:
>      * Less accesses to registers used.
>      * Once-per-device configuration is done only in probe(), not each
>     transfer.
>
>     Uglyness still there:
>      * VERSION_X definitions for different SPI controllers - added VERSION_3
>       for the dm6446, which is ugly.
>
>     NOTE:
>     This patch is based on following patches:
>
>     SPI: DaVinci: Adding SPI driver for DM3xx/DM6467/DA8xx
>
>      The patch adds support for SPI in DaVinci
>      DM355/DM365/DM6467 and DA8xx.
>
>      This has been tested on the DM355, DM365 and DM6467 EVMs using
>      the EEPROM connected to SPI0
>
>      Signed-off-by: Sandeep Paulraj <s-paulraj@ti.com>
>
>     DaVinci: DM646x: Adding Support for SPI
>
>      The patch does the following
>
>      1) Adds a clock for SPI
>      2) Defines resources specific to DM646x SOC
>
>      Signed-off-by: Sandeep Paulraj <s-paulraj@ti.com>
>
>
>     Signed-off-by: Pablo Bitton <pablo.bitton@gmail.com>
>
