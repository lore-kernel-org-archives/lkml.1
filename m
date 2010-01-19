Return-Path: <linux-kernel-owner+w=401wt.eu-S1753033Ab0ASVmg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753033Ab0ASVmg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 16:42:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752191Ab0ASVmf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 16:42:35 -0500
Received: from mail.perches.com ([173.55.12.10]:1292 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752174Ab0ASVme (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 16:42:34 -0500
Subject: Re: [RFC] [PATCH] watchdog_info separation and constify
From: Joe Perches <joe@perches.com>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Florian Fainelli <florian@openwrt.org>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       LKML <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org,
       uclinux-dist-devel@blackfin.uclinux.org, linux-omap@vger.kernel.org
In-Reply-To: <20100119211759.GE3804@infomag.iguana.be>
References: <20100119211759.GE3804@infomag.iguana.be>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 19 Jan 2010 13:42:31 -0800
Message-ID: <1263937351.18117.69.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-01-19 at 22:17 +0100, Wim Van Sebroeck wrote:
> -static struct watchdog_info at32_wdt_info = {
> +static const struct watchdog_info at32_wdt_info = {

It'd be good to use a consistent structure name:

static const struct watchdog_info ident = {
	etc...
}

$ grep -Poh "struct\s*watchdog_info\s*\w+" *.[ch] | sort | uniq -c | sort -rn
     65 struct watchdog_info ident
      8 struct watchdog_info __user
      4 struct watchdog_info info
      2 struct watchdog_info sh_wdt_info
      2 struct watchdog_info bfin_wdt_info
      2 struct watchdog_info at91_wdt_info
      1 struct watchdog_info zf_info
      1 struct watchdog_info wdinfo
      1 struct watchdog_info twl4030_wd_ident
      1 struct watchdog_info s3c2410_wdt_ident
      1 struct watchdog_info nuc900_wdt_info
      1 struct watchdog_info ks8695_wdt_info
      1 struct watchdog_info bcm47xx_wdt_info
      1 struct watchdog_info at32_wdt_info
      1 struct watchdog_info adx_wdt_info

firmware_version doesn't have to be initialized to 0.

It might be good to standardize .identity to include
either "WDT" or "watchdog" or exclude both of those.

Maybe a standard #define WATCHDOG_NAME <foo>

.identity = WATCHGOD_NAME

$ grep -Poh "\.identity\s*=\s*.*$" *.[ch] | sed -r -e 's/\s+/ /g' | sort 
.identity = "ALi M1535 WatchDog Timer",
.identity = "ALiM7101",
.identity = "at32ap700x watchdog",
.identity = "at91 watchdog",
.identity = "Avionic Design Xanthos Watchdog",
.identity = "Blackfin Watchdog",
.identity = "COH 901 327 Watchdog",
.identity = "CPU5 WDT",
.identity = "DaVinci Watchdog",
.identity = DRIVER_NAME,
.identity = DRIVER_NAME,
.identity = DRIVER_NAME,
.identity = DRV_NAME,
.identity = DRV_NAME,
.identity = DRV_NAME,
.identity = DRV_NAME,
.identity = DRV_NAME,
.identity = "EP93xx Watchdog",
.identity = ESB_MODULE_NAME,
.identity = "Footbridge Watchdog",
.identity = "GE Fanuc watchdog",
.identity = "Hardware Watchdog for PNX833x",
.identity = "Hardware Watchdog for SGI IP22",
.identity = "Hardware Watchdog for TXx9",
.identity = "HP iLO2 HW Watchdog Timer",
.identity = "IB700 WDT",
.identity = "IBM ASR",
.identity = "iop watchdog",
.identity = "IT8712F Watchdog",
.identity = "IXP2000 Watchdog",
.identity = "IXP4xx Watchdog",
.identity = "ks8695 watchdog",
.identity = LONGNAME,
.identity = "MixCOM watchdog",
.identity = "MPC8xxx",
.identity = "MPcore Watchdog",
.identity = "MTX-1 WDT",
.identity = "MV64x60 watchdog",
.identity = "NatSemi SCx200 Watchdog",
.identity = "nuc900 watchdog",
.identity = "OMAP Watchdog",
.identity = "Orion Watchdog",
.identity = "PC87307/PC97307",
.identity = "PC87413(HF/F) watchdog",
.identity = "PCI-WDT500/501",
.identity = "PCWD",
.identity = "PNX4008 Watchdog",
.identity = "PowerPC Book-E Watchdog",
.identity = "RC32434_WDT Watchdog",
.identity = "RDC321x WDT",
.identity = "S3C2410 Watchdog",
.identity = "SA1100/PXA255 Watchdog",
.identity = "SBC60xx",
.identity = "SBC7240",
.identity = "SC520",
.identity = "SH WDT",
.identity = "SiByte Watchdog",
.identity = "SMsC 37B787 Watchdog",
.identity = "Software Watchdog",
.identity = "STMP3XXX Watchdog",
.identity = "TWL4030 Watchdog",
.identity = "W83627HF WDT",
.identity = "W83697HF WDT",
.identity = "W83697UG WDT",
.identity = "W83877F",
.identity = "Wafer 5823 WDT",
.identity = WATCHDOG_DRIVER_NAME,
.identity = WATCHDOG_NAME,
.identity = WATCHDOG_NAME,
.identity = WATCHDOG_NAME,
.identity = WATCHDOG_NAME,
.identity = WATCHDOG_NAME,
.identity = WATCHDOG_NAME,
.identity = WATCHDOG_NAME,
.identity = "wdrtas",
.identity = "WDT500/501",
.identity = "WDT Eurotech CPU-1220/1410",
.identity = "Winsystems EPX-C3 H/W Watchdog",
.identity = "WM831x Watchdog",
.identity = "WM8350 Watchdog",
.identity = "ZF-Logic watchdog",

Maybe a DECLARE_WATCHDOG_IDENT() macro?

