Return-Path: <linux-kernel-owner+w=401wt.eu-S1752565AbXIDDZA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752565AbXIDDZA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 23:25:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751686AbXIDDYw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 23:24:52 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:39856 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599AbXIDDYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 23:24:51 -0400
X-IronPort-AV: i="4.20,203,1186372800"; 
   d="scan'208"; a="50456936:sNHT28487102"
Subject: Re: [PATCH] Blackfin BF54x NAND Flash Controller driver
From: Bryan Wu <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: bryan.wu@analog.com, David Woodhouse <dwmw2@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
In-Reply-To: <8bd0f97a0709031057u1f4608f6y36bd20a8f6910a32@mail.gmail.com>
References: <1188804323.29566.6.camel@roc-laptop>
	 <8bd0f97a0709031057u1f4608f6y36bd20a8f6910a32@mail.gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Inc.
Date: Tue, 04 Sep 2007 11:21:49 +0800
Message-Id: <1188876109.6319.9.camel@roc-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
X-OriginalArrivalTime: 04 Sep 2007 03:24:50.0738 (UTC) FILETIME=[27284920:01C7EEA3]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-09-03 at 13:57 -0400, Mike Frysinger wrote:
> On 9/3/07, Bryan Wu <bryan.wu@analog.com> wrote:
> > --- a/drivers/mtd/nand/Kconfig
> > +++ b/drivers/mtd/nand/Kconfig
> > @@ -131,6 +131,24 @@ config MTD_NAND_AU1550
> > +config MTD_NAND_BF54X
> > +       tristate "NAND Flash support for Blackfin BF54X SoC DSP"
> 
> i'd just describe it as "Blackfin on-chip NAND" rather than sticking
> in exact part numbers as i imagine we can extend it down the line
> 
> > +         This enables the NAND flash controller on the BF54X SoC DPSs
> 
> "BF54X SoC DPSs" -> "BF54x SoC DSPs"
> 
> > +         No board specific support is done by this driver, each board
> > +         must advertise a platform_device for the driver to attach.
> 
> should mention the module name when built as a module
> 

I will get rid of this BF54X and use BF5XX for (BF54x and BF52x and
future processor)

> > +config MTD_NAND_BF54X_HWECC
> > +       bool "BF54X NAND Hardware ECC"
> > +       depends on MTD_NAND_BF54X
> > +       help
> > +         Enable the use of the BF54X's internal ECC generator when
> > +         using NAND. Early versions of the chip have had problems with
> > +         incorrect ECC generation, and if using these, the default of
> > +         software ECC is preferable.
> 
> rather than advertising this, i'd just keep it in the driver ...
> presumably there are anomaly #'s for when the ECC is wrong, so we can
> make the code depend on those
> -mike

This option is quite common in the NAND driver. If there are anomaly
#'s, code can still depend on those by using hardware_ecc varible. This
option is very useful when someone need software_ecc.

Thanks
- Bryan Wu
