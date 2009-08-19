Return-Path: <linux-kernel-owner+w=401wt.eu-S1752750AbZHSN21@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752750AbZHSN21 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 09:28:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752639AbZHSN2Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 09:28:24 -0400
Received: from ernst.netinsight.se ([194.16.221.21]:8338 "HELO
	ernst.netinsight.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752638AbZHSN2V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 09:28:21 -0400
X-Greylist: delayed 604 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Aug 2009 09:28:21 EDT
Date: Wed, 19 Aug 2009 15:18:14 +0200
From: Simon Kagstrom <simon.kagstrom@netinsight.net>
To: Dhaval Vasa <dhaval.vasa@einfochips.com>
Cc: nico@cam.org, linux-kernel@vger.kernel.org, rabeeh@marvell.com,
       linux-arm-kernel@lists.arm.linux.org.uk, dhaval.vasa@einfochips.com
Subject: Re: [PATCH v2] [ARM] Kirkwood: Marvell OpenRD-Base board support
 added to v2.6.31-rc5
Message-ID: <20090819151814.7167bad0@marrow.netinsight.se>
In-Reply-To: <1249906054-572-1-git-send-email-dhaval.vasa@einfochips.com>
References: <1249906054-572-1-git-send-email-dhaval.vasa@einfochips.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dhaval!

On Mon, 10 Aug 2009 17:37:34 +0530
Dhaval Vasa <dhaval.vasa@einfochips.com> wrote:

> reference:
> http://open-rd.org
> http://code.google.com/p/openrd
> 
> This patch is tested for:
> 1. Boot from DRAM/NAND flash
> 2. NAND read/write/erase
> 3. GbE0
> 4. USB read/write
> 
> FIXME:
> 1. SD/UART1 selection
> 2. MPP configuration (currently, default)
> 3. PEX
> 
> Signed-off-by: Dhaval Vasa <dhaval.vasa@einfochips.com>

Tested-by: Simon Kagstrom <simon.kagstrom@netinsight.net>

> +static unsigned int openrd_base_mpp_config[] __initdata = {
> +	MPP29_GPIO,	
                   ^^^^^
There is trailing whitespace on this line

Also, I'd suggest merging "[PATCH v2] Kirkwood: Initialise SATA for
OpenRD-Base" into this one and resubmit it.

In my patch, I also called kirkwood_i2c_init (see below), which at
least make the I2C bus appear (not that I've tested it very much).

// Simon

diff --git a/arch/arm/mach-kirkwood/openrd_base-setup.c b/arch/arm/mach-kirkwood/openrd_base-setup.c
index f9a2166..dc0a2fe 100644
--- a/arch/arm/mach-kirkwood/openrd_base-setup.c
+++ b/arch/arm/mach-kirkwood/openrd_base-setup.c
@@ -71,6 +71,8 @@ static void __init openrd_base_init(void)
        kirkwood_ge00_init(&openrd_base_ge00_data);
        kirkwood_sata_init(&openrd_base_sata_data);
        kirkwood_sdio_init(&openrd_base_mvsdio_data);
+
+       kirkwood_i2c_init();
 }
 
 MACHINE_START(OPENRD_BASE, "Marvell OpenRD Base Board")
