Return-Path: <linux-kernel-owner+w=401wt.eu-S1754480AbZHTNNo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754480AbZHTNNo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 09:13:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754465AbZHTNNm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 09:13:42 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:39817 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754456AbZHTNNj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 09:13:39 -0400
From: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
To: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
       Tony Lindgren <tony@atomide.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>
CC: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Syed, Rafiuddin" <rafiuddin.syed@ti.com>,
       Russell King <rmk@arm.linux.org.uk>, Kalle Valo <kalle.valo@iki.fi>
Date: Thu, 20 Aug 2009 18:43:15 +0530
Subject: RE: linux-next: manual merge of the omap tree with the arm tree
Thread-Topic: linux-next: manual merge of the omap tree with the arm tree
Thread-Index: AcohiFzi9dSVtprDTqGlY31ypQuYKQAAfjmgAANIebA=
Message-ID: <EAF47CD23C76F840A9E7FCE10091EFAB02BA29B961@dbde02.ent.ti.com>
References: <20090819150433.4c12c612.sfr@canb.auug.org.au>
 <20090820102004.GD12309@atomide.com>
 <EAF47CD23C76F840A9E7FCE10091EFAB02BA29B949@dbde02.ent.ti.com>
In-Reply-To: <EAF47CD23C76F840A9E7FCE10091EFAB02BA29B949@dbde02.ent.ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Resending with a correction)

> -----Original Message-----
> From: linux-omap-owner@vger.kernel.org [mailto:linux-omap-
> owner@vger.kernel.org] On Behalf Of Shilimkar, Santosh
> Sent: Thursday, August 20, 2009 6:33 PM
> To: Tony Lindgren; Stephen Rothwell
> Cc: linux-omap@vger.kernel.org; linux-next@vger.kernel.org; linux-
> kernel@vger.kernel.org; Syed, Rafiuddin; Russell King; Kalle Valo
> Subject: RE: linux-next: manual merge of the omap tree with the arm tree
> 
> > > Today's linux-next merge of the omap tree got a conflict in
> > > arch/arm/mach-omap2/board-4430sdp.c between commit
> > > 085b54d99b8ee999e7905b8f16e201e0da8ba369 ("ARM: OMAP4: Add UART4
> > > support") from the arm tree and commit
> > > 4c29fa3e47342666e12e46f35f40dd90b12cd1a4 ("OMAP: remove
> OMAP_TAG_UART")
> > > from the omap tree.
> > >
> > > Just context changes (I think).  I fixed it up (see below) and can
> carry
> > > the fix as necessary.
> >
> > Thanks yeh the fix looks right. I'll take a look if I can squeeze
> > something
> > like that into my queue so the merge conflict disappears.
> 
> There is another issue with the same merge I noticed which not seems to be
> correct.
> http://git.kernel.org/?p=linux/kernel/git/sfr/linux-
> next.git;a=commit;h=a11128de5baf523cf73176170659902fe1335527
> 
> < Code snippet >
> 
> 102 static struct plat_serial8250_port serial_platform_data2[] = {
> 103         {
> 104                 .membase        = OMAP2_IO_ADDRESS(OMAP_UART3_BASE),
> 105                 .mapbase        = OMAP_UART3_BASE,
> 106                 .irq            = 74,
> 107                 .flags          = UPF_BOOT_AUTOCONF,
> 108                 .iotype         = UPIO_MEM,
> 109                 .regshift       = 2,
> 110                 .uartclk        = OMAP24XX_BASE_BAUD * 16,
> 111         }, {
> 112 #ifdef CONFIG_ARCH_OMAP4
> 113                 .membase        = IO_ADDRESS(OMAP_UART4_BASE),
> 114                 .mapbase        = OMAP_UART4_BASE,
> 115                 .irq            = 70,
> 116                 .flags          = UPF_BOOT_AUTOCONF,
> 117                 .iotype         = UPIO_MEM,
> 118                 .regshift       = 2,
> 119                 .uartclk        = OMAP24XX_BASE_BAUD * 16,
> 120         }, {
> 121 #endif
> 122                 .flags          = 0
> 123         }
> 124 };
> 
> This patch (ARM: OMAP4: Add UART4) was generated when there was single
> structure holding all three UARTs and fourth UART was added accordingly.
> And now it's been merged with serial.c which has UART's structures
> separated already.
> Below patch fixes the same but don't know what is the way to get merged in
> such cases.
> 
> Tony,
> Could you please review it?

>From c8be9f1b5d4fe1dce06b6f33be33fe57f376ea7f Mon Sep 17 00:00:00 2001
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
Date: Thu, 20 Aug 2009 18:33:43 +0530
Subject: [PATCH] OMAP4: UART4 : Reworked patch to fix merge conflicts.

This patch adds UART4 support on OMAP4430 development platform.
The serial omap patches has split the UART platform
data into separate structure hence needs rework.

Without this patch omap_serial_init() would produce kernel crash
on OMAP4430 platform while looping for the 4 th UART platform
data.

Signed-off-by: Syed Rafiuddin <rafiuddin.syed@ti.com>
Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
---
 arch/arm/mach-omap2/board-4430sdp.c |    2 +-
 arch/arm/mach-omap2/serial.c        |   27 ++++++++++++++++++++++++++-
 2 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-omap2/board-4430sdp.c b/arch/arm/mach-omap2/board-4430sdp.c
index b0c7402..1b22307 100644
--- a/arch/arm/mach-omap2/board-4430sdp.c
+++ b/arch/arm/mach-omap2/board-4430sdp.c
@@ -39,7 +39,7 @@ static struct platform_device *sdp4430_devices[] __initdata = {
 };
 
 static struct omap_uart_config sdp4430_uart_config __initdata = {
-	.enabled_uarts	= (1 << 0) | (1 << 1) | (1 << 2),
+	.enabled_uarts	= (1 << 0) | (1 << 1) | (1 << 2) | (1 << 3),
 };
 
 static struct omap_lcd_config sdp4430_lcd_config __initdata = {
diff --git a/arch/arm/mach-omap2/serial.c b/arch/arm/mach-omap2/serial.c
index a7421a5..b96cac4 100644
--- a/arch/arm/mach-omap2/serial.c
+++ b/arch/arm/mach-omap2/serial.c
@@ -112,7 +112,21 @@ static struct plat_serial8250_port serial_platform_data2[] = {
 		.flags		= 0
 	}
 };
-
+#ifdef CONFIG_ARCH_OMAP4
+static struct plat_serial8250_port serial_platform_data3[] = {
+	{
+		.membase	= IO_ADDRESS(OMAP_UART4_BASE),
+		.mapbase	= OMAP_UART4_BASE,
+		.irq		= 70,
+		.flags		= UPF_BOOT_AUTOCONF,
+		.iotype		= UPIO_MEM,
+		.regshift	= 2,
+		.uartclk	= OMAP24XX_BASE_BAUD * 16,
+	}, {
+		.flags		= 0
+	}
+};
+#endif
 static inline unsigned int serial_read_reg(struct plat_serial8250_port *up,
 					   int offset)
 {
@@ -550,6 +564,17 @@ static struct omap_uart_state omap_uart[OMAP_MAX_NR_PORTS] = {
 			},
 		},
 	},
+#ifdef CONFIG_ARCH_OMAP4
+	{
+		.pdev = {
+			.name			= "serial8250",
+			.id			= PLAT8250_DEV_PLATFORM2,
+			.dev			= {
+				.platform_data	= serial_platform_data3,
+			},
+		},
+	},
+#endif
 };
 
 void __init omap_serial_init(void)
-- 
1.5.4.7

Regards,
Santosh
