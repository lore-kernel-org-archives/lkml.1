Return-Path: <linux-kernel-owner+w=401wt.eu-S1755541AbZCEH7w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755541AbZCEH7w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 02:59:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751291AbZCEH7o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 02:59:44 -0500
Received: from vervifontaine.sonytel.be ([80.88.33.193]:38962 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750711AbZCEH7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 02:59:44 -0500
Date: Thu, 5 Mar 2009 08:59:40 +0100 (CET)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Olaf Hering <olaf@aepfle.de>
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jens Axboe <axboe@kernel.dk>, Jim Paris <jim@jtan.com>,
       Arnd Bergmann <arnd@arndb.de>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Linux/PPC Development <linuxppc-dev@ozlabs.org>,
       linux-mtd@lists.infradead.org,
       Vivien Chappelier <vivien.chappelier@free.fr>,
       David Woodhouse <dwmw2@infradead.org>,
       Cell Broadband Engine OSS Development 
	<cbe-oss-dev@ozlabs.org>
Subject: Re: [PATCH/RFC] ps3/block: Add ps3vram-ng driver for accessing video
 RAM as block device
In-Reply-To: <AA44F8E7-5FBC-4378-A86D-C094ECABD625@aepfle.de>
Message-ID: <alpine.LRH.2.00.0903050856490.26681@vixen.sonytel.be>
References: <alpine.LRH.2.00.0903041444300.32279@vixen.sonytel.be> <AA44F8E7-5FBC-4378-A86D-C094ECABD625@aepfle.de>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Mar 2009, Olaf Hering wrote:
> Am 04.03.2009 um 14:57 schrieb Geert Uytterhoeven:
> >Ideally, we think it would be best if the existing MTD-based ps3vram driver
> >would be replaced by the new block-based ps3vram driver before 2.6.29 is
> >released. This would relieve the burden of supporting two different swap
> >space
> >schemes on PS3 (swap on /dev/mtdblock0 vs. /dev/ps3vram) from the distro
> >maintainer's shoulders, as in that case there would never have been a stable
> >kernel version containing the MTD-based ps3vram driver.
> 
> openSuSE already ships with the ps3vram driver since a two releases.
> A simple name based udev rule could symlink ps3vram to mtdblock0, so an
> upgrade
> will not break existing setups.

OK.

> >+obj-$(CONFIG_PS3_VRAM)		+= ps3vram_ng.o
> 
> Please give the driver the obvious name "ps3vram", that way upgrading will be
> smooth.

Sure, as I said:

| I'll submit a patch to remove the MTD
| ps3vram and add the new driver as ps3vram (instead of ps3vram-ng).

> I see our old mtddriver does not have modalias support for autoloading.

You forgot to backport commit 0a2d15b928e0b1673d4ed5f48d95af211b6fcc06
("mtd/ps3vram: Add modalias support to the ps3vram driver") to the openSuSE
tree?

> Hopefully the new driver has this feature.

Yes, it has.

With kind regards,

Geert Uytterhoeven
Software Architect

Sony Techsoft Centre Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium

Phone:    +32 (0)2 700 8453
Fax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

A division of Sony Europe (Belgium) N.V.
VAT BE 0413.825.160 · RPR Brussels
Fortis · BIC GEBABEBB · IBAN BE41293037680010
