Return-Path: <linux-kernel-owner+w=401wt.eu-S1755562AbXICR6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755562AbXICR6T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 13:58:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751069AbXICR6E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 13:58:04 -0400
Received: from nz-out-0506.google.com ([64.233.162.239]:23984 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754AbXICR6B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 13:58:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Iz+cX/amz3HDXERPmj/BHQPX2i+7PsaFOdUKDJPpIVhidS9MlqYWXoXjZhuRiIUldZ1iZiaao6l3qTlib+xxjYtG1owcJSnEA8VWs6mceYMfh9O36U8McLkmlK/KOEjJetGIwuRBlCK+zEt+CRtUzlLCXjS/ebsdohbUCMArTBw=
Message-ID: <8bd0f97a0709031057u1f4608f6y36bd20a8f6910a32@mail.gmail.com>
Date: Mon, 3 Sep 2007 13:57:59 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: bryan.wu@analog.com
Subject: Re: [PATCH] Blackfin BF54x NAND Flash Controller driver
Cc: "David Woodhouse" <dwmw2@infradead.org>,
       "Thomas Gleixner" <tglx@linutronix.de>, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
In-Reply-To: <1188804323.29566.6.camel@roc-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1188804323.29566.6.camel@roc-laptop>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/3/07, Bryan Wu <bryan.wu@analog.com> wrote:
> --- a/drivers/mtd/nand/Kconfig
> +++ b/drivers/mtd/nand/Kconfig
> @@ -131,6 +131,24 @@ config MTD_NAND_AU1550
> +config MTD_NAND_BF54X
> +       tristate "NAND Flash support for Blackfin BF54X SoC DSP"

i'd just describe it as "Blackfin on-chip NAND" rather than sticking
in exact part numbers as i imagine we can extend it down the line

> +         This enables the NAND flash controller on the BF54X SoC DPSs

"BF54X SoC DPSs" -> "BF54x SoC DSPs"

> +         No board specific support is done by this driver, each board
> +         must advertise a platform_device for the driver to attach.

should mention the module name when built as a module

> +config MTD_NAND_BF54X_HWECC
> +       bool "BF54X NAND Hardware ECC"
> +       depends on MTD_NAND_BF54X
> +       help
> +         Enable the use of the BF54X's internal ECC generator when
> +         using NAND. Early versions of the chip have had problems with
> +         incorrect ECC generation, and if using these, the default of
> +         software ECC is preferable.

rather than advertising this, i'd just keep it in the driver ...
presumably there are anomaly #'s for when the ECC is wrong, so we can
make the code depend on those
-mike
