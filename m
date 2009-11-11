Return-Path: <linux-kernel-owner+w=401wt.eu-S1758636AbZKKTVA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758636AbZKKTVA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 14:21:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758614AbZKKTVA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 14:21:00 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:61236 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758556AbZKKTU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 14:20:57 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 72.249.23.125
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/83vT95liOoOZqpVsyuT8v
Date: Wed, 11 Nov 2009 11:20:59 -0800
From: Tony Lindgren <tony@atomide.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Greg KH <greg@kroah.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Felipe Balbi <felipe.balbi@nokia.com>,
       linux-omap@vger.kernel.org
Subject: Re: linux-next: manual merge of the usb tree with the omap tree
Message-ID: <20091111192058.GI24837@atomide.com>
References: <20091111193013.9a4bca3e.sfr@canb.auug.org.au>
 <20091111191213.GH24837@atomide.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8t9RHnE3ZwKMSgU+"
Content-Disposition: inline
In-Reply-To: <20091111191213.GH24837@atomide.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--8t9RHnE3ZwKMSgU+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

* Tony Lindgren <tony@atomide.com> [091111 11:12]:
> * Stephen Rothwell <sfr@canb.auug.org.au> [091111 00:29]:
> > Hi Greg,
> > 
> > Today's linux-next merge of the usb tree got a conflict in
> > drivers/usb/host/ehci-omap.c between commit
> > 7cb07f72711d3e10763ca7d7a9fcd7ac788aabf4 ("omap: ehci: Add platform init
> > code") from the omap tree and commit
> > 9e92239693d7010d2e710a445f46d6a738b09171 ("USB: host: ehci: introduce
> > omap ehci-hcd driver") from the usb tree.
> > 
> > Both commits create this file but I used the omap tree version because
> > commit ce491cf85466c3377228c5a852ea627ec5136956 ("omap: headers: Move
> > remaining headers from include/mach to include/plat") from the omap tree
> > moved one included header file (mach/usb.h -> plat/usb.h).
> 
> Oops, sorry. Looks like I accidentally included also drivers/usb/host/ehci-omap.c
> as we were testing it in the linux-omap tree.
> 
> I'll drop the drivers/usb/host/ehci-omap.c part from my queue, it should get
> integrated via Greg's queue. I'll just merge the platform init code.

Dropped anything touching drivers/usb from my patch. So no need for Greg
to do anything, the updated version of the patch below for reference.

Regards,

Tony

--8t9RHnE3ZwKMSgU+
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: inline; filename="ehci-platform-init.patch"

>From 83f75a0c0eca8cdfc41d9a136c57c65e8fd546af Mon Sep 17 00:00:00 2001
From: Felipe Balbi <felipe.balbi@nokia.com>
Date: Tue, 10 Nov 2009 18:24:39 -0800
Subject: [PATCH] omap: Add platform init code for EHCI driver

Add platform init code for EHCI driver.

Various fixes to the original patch by Ajay Kumar Gupta <ajay.gupta@ti.com>
and Anand Gadiyar <gadiyar@ti.com>.

Overo support added by Olof Johansson <olof@lixom.net>
Beagle support added by Koen Kooi <koen@beagleboard.org>
CM-T32 support added by Mike Rapoport <mike@compulab.co.il>

Signed-off-by: Signed-off-by: Olof Johansson <olof@lixom.net>
Acked-by: Steve Sakoman <steve@sakoman.com>
Signed-off-by: Koen Kooi <koen@beagleboard.org>
Signed-off-by: Mike Rapoport <mike@compulab.co.il>
Signed-off-by: Ajay Kumar Gupta <ajay.gupta@ti.com>
Signed-off-by: Anand Gadiyar <gadiyar@ti.com>
Signed-off-by: Felipe Balbi <felipe.balbi@nokia.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>

diff --git a/arch/arm/mach-omap2/Makefile b/arch/arm/mach-omap2/Makefile
index 7468505..03cb4fc 100644
--- a/arch/arm/mach-omap2/Makefile
+++ b/arch/arm/mach-omap2/Makefile
@@ -82,6 +82,7 @@ obj-$(CONFIG_MACH_OMAP_4430SDP)		+= board-4430sdp.o
 # Platform specific device init code
 obj-y					+= usb-musb.o
 obj-$(CONFIG_MACH_OMAP2_TUSB6010)	+= usb-tusb6010.o
+obj-y					+= usb-ehci.o
 
 onenand-$(CONFIG_MTD_ONENAND_OMAP2)	:= gpmc-onenand.o
 obj-y					+= $(onenand-m) $(onenand-y)
diff --git a/arch/arm/mach-omap2/board-3430sdp.c b/arch/arm/mach-omap2/board-3430sdp.c
index a2abac9..a3c1271 100644
--- a/arch/arm/mach-omap2/board-3430sdp.c
+++ b/arch/arm/mach-omap2/board-3430sdp.c
@@ -484,6 +484,18 @@ static void enable_board_wakeup_source(void)
 	omap_cfg_reg(AF26_34XX_SYS_NIRQ); /* T2 interrupt line (keypad) */
 }
 
+static struct ehci_hcd_omap_platform_data ehci_pdata __initconst = {
+
+	.port_mode[0] = EHCI_HCD_OMAP_MODE_PHY,
+	.port_mode[1] = EHCI_HCD_OMAP_MODE_PHY,
+	.port_mode[2] = EHCI_HCD_OMAP_MODE_UNKNOWN,
+
+	.phy_reset  = true,
+	.reset_gpio_port[0]  = 57,
+	.reset_gpio_port[1]  = 61,
+	.reset_gpio_port[2]  = -EINVAL
+};
+
 static void __init omap_3430sdp_init(void)
 {
 	omap3430_i2c_init();
@@ -500,6 +512,7 @@ static void __init omap_3430sdp_init(void)
 	usb_musb_init();
 	board_smc91x_init();
 	enable_board_wakeup_source();
+	usb_ehci_init(&ehci_pdata);
 }
 
 static void __init omap_3430sdp_map_io(void)
diff --git a/arch/arm/mach-omap2/board-cm-t35.c b/arch/arm/mach-omap2/board-cm-t35.c
index e7a29e4..0a39513 100644
--- a/arch/arm/mach-omap2/board-cm-t35.c
+++ b/arch/arm/mach-omap2/board-cm-t35.c
@@ -352,6 +352,17 @@ static struct twl4030_hsmmc_info mmc[] = {
 	{}	/* Terminator */
 };
 
+static struct ehci_hcd_omap_platform_data ehci_pdata = {
+	.port_mode[0] = EHCI_HCD_OMAP_MODE_PHY,
+	.port_mode[1] = EHCI_HCD_OMAP_MODE_PHY,
+	.port_mode[2] = EHCI_HCD_OMAP_MODE_UNKNOWN,
+
+	.phy_reset  = true,
+	.reset_gpio_port[0]  = -EINVAL,
+	.reset_gpio_port[1]  = -EINVAL,
+	.reset_gpio_port[2]  = -EINVAL
+};
+
 static int cm_t35_twl_gpio_setup(struct device *dev, unsigned gpio,
 				 unsigned ngpio)
 {
@@ -377,6 +388,12 @@ static int cm_t35_twl_gpio_setup(struct device *dev, unsigned gpio,
 	cm_t35_vmmc1_supply.dev = mmc[0].dev;
 	cm_t35_vsim_supply.dev = mmc[0].dev;
 
+	/* setup USB with proper PHY reset GPIOs */
+	ehci_pdata.reset_gpio_port[0] = gpio + 6;
+	ehci_pdata.reset_gpio_port[1] = gpio + 7;
+
+	usb_ehci_init(&ehci_pdata);
+
 	return 0;
 }
 
diff --git a/arch/arm/mach-omap2/board-omap3beagle.c b/arch/arm/mach-omap2/board-omap3beagle.c
index 71a3528..6cb99f6 100644
--- a/arch/arm/mach-omap2/board-omap3beagle.c
+++ b/arch/arm/mach-omap2/board-omap3beagle.c
@@ -400,6 +400,18 @@ static void __init omap3beagle_flash_init(void)
 	}
 }
 
+static struct ehci_hcd_omap_platform_data ehci_pdata __initconst = {
+
+	.port_mode[0] = EHCI_HCD_OMAP_MODE_PHY,
+	.port_mode[1] = EHCI_HCD_OMAP_MODE_PHY,
+	.port_mode[2] = EHCI_HCD_OMAP_MODE_UNKNOWN,
+
+	.phy_reset  = true,
+	.reset_gpio_port[0]  = -EINVAL,
+	.reset_gpio_port[1]  = 147,
+	.reset_gpio_port[2]  = -EINVAL
+};
+
 static void __init omap3_beagle_init(void)
 {
 	omap3_beagle_i2c_init();
@@ -413,6 +425,7 @@ static void __init omap3_beagle_init(void)
 	gpio_direction_output(170, true);
 
 	usb_musb_init();
+	usb_ehci_init(&ehci_pdata);
 	omap3beagle_flash_init();
 
 	/* Ensure SDRC pins are mux'd for self-refresh */
diff --git a/arch/arm/mach-omap2/board-omap3evm.c b/arch/arm/mach-omap2/board-omap3evm.c
index 660ef8c..b9b0f4c 100644
--- a/arch/arm/mach-omap2/board-omap3evm.c
+++ b/arch/arm/mach-omap2/board-omap3evm.c
@@ -343,6 +343,18 @@ static struct platform_device *omap3_evm_devices[] __initdata = {
 	&omap3evm_smc911x_device,
 };
 
+static struct ehci_hcd_omap_platform_data ehci_pdata __initconst = {
+
+	.port_mode[0] = EHCI_HCD_OMAP_MODE_UNKNOWN,
+	.port_mode[1] = EHCI_HCD_OMAP_MODE_PHY,
+	.port_mode[2] = EHCI_HCD_OMAP_MODE_UNKNOWN,
+
+	.phy_reset  = true,
+	.reset_gpio_port[0]  = -EINVAL,
+	.reset_gpio_port[1]  = 135,
+	.reset_gpio_port[2]  = -EINVAL
+};
+
 static void __init omap3_evm_init(void)
 {
 	omap3_evm_i2c_init();
@@ -358,6 +370,9 @@ static void __init omap3_evm_init(void)
 	usb_nop_xceiv_register();
 #endif
 	usb_musb_init();
+	/* Setup EHCI phy reset padconfig */
+	omap_cfg_reg(AF4_34XX_GPIO135_OUT);
+	usb_ehci_init(&ehci_pdata);
 	ads7846_dev_init();
 }
 
diff --git a/arch/arm/mach-omap2/board-omap3pandora.c b/arch/arm/mach-omap2/board-omap3pandora.c
index 5a38494..581a18d 100644
--- a/arch/arm/mach-omap2/board-omap3pandora.c
+++ b/arch/arm/mach-omap2/board-omap3pandora.c
@@ -387,6 +387,18 @@ static struct platform_device *omap3pandora_devices[] __initdata = {
 	&pandora_keys_gpio,
 };
 
+static struct ehci_hcd_omap_platform_data ehci_pdata __initconst = {
+
+	.port_mode[0] = EHCI_HCD_OMAP_MODE_PHY,
+	.port_mode[1] = EHCI_HCD_OMAP_MODE_UNKNOWN,
+	.port_mode[2] = EHCI_HCD_OMAP_MODE_UNKNOWN,
+
+	.phy_reset  = true,
+	.reset_gpio_port[0]  = 16,
+	.reset_gpio_port[1]  = -EINVAL,
+	.reset_gpio_port[2]  = -EINVAL
+};
+
 static void __init omap3pandora_init(void)
 {
 	omap3pandora_i2c_init();
@@ -396,6 +408,7 @@ static void __init omap3pandora_init(void)
 	spi_register_board_info(omap3pandora_spi_board_info,
 			ARRAY_SIZE(omap3pandora_spi_board_info));
 	omap3pandora_ads7846_init();
+	usb_ehci_init(&ehci_pdata);
 	pandora_keys_gpio_init();
 	usb_musb_init();
 
diff --git a/arch/arm/mach-omap2/board-overo.c b/arch/arm/mach-omap2/board-overo.c
index 461522c..92f3f3a 100644
--- a/arch/arm/mach-omap2/board-overo.c
+++ b/arch/arm/mach-omap2/board-overo.c
@@ -384,6 +384,18 @@ static struct platform_device *overo_devices[] __initdata = {
 	&overo_lcd_device,
 };
 
+static struct ehci_hcd_omap_platform_data ehci_pdata __initconst = {
+	.port_mode[0] = EHCI_HCD_OMAP_MODE_UNKNOWN,
+	.port_mode[1] = EHCI_HCD_OMAP_MODE_PHY,
+	.port_mode[2] = EHCI_HCD_OMAP_MODE_UNKNOWN,
+
+	.phy_reset  = true,
+	.reset_gpio_port[0]  = -EINVAL,
+	.reset_gpio_port[1]  = OVERO_GPIO_USBH_NRESET,
+	.reset_gpio_port[2]  = -EINVAL
+};
+
+
 static void __init overo_init(void)
 {
 	overo_i2c_init();
@@ -391,6 +403,7 @@ static void __init overo_init(void)
 	omap_serial_init();
 	overo_flash_init();
 	usb_musb_init();
+	usb_ehci_init(&ehci_pdata);
 	overo_ads7846_init();
 	overo_init_smsc911x();
 
@@ -433,14 +446,6 @@ static void __init overo_init(void)
 	else
 		printk(KERN_ERR "could not obtain gpio for "
 					"OVERO_GPIO_USBH_CPEN\n");
-
-	if ((gpio_request(OVERO_GPIO_USBH_NRESET,
-			  "OVERO_GPIO_USBH_NRESET") == 0) &&
-	    (gpio_direction_output(OVERO_GPIO_USBH_NRESET, 1) == 0))
-		gpio_export(OVERO_GPIO_USBH_NRESET, 0);
-	else
-		printk(KERN_ERR "could not obtain gpio for "
-					"OVERO_GPIO_USBH_NRESET\n");
 }
 
 static void __init overo_map_io(void)
diff --git a/arch/arm/plat-omap/include/plat/omap34xx.h b/arch/arm/plat-omap/include/plat/omap34xx.h
index f8d186a..4655707 100644
--- a/arch/arm/plat-omap/include/plat/omap34xx.h
+++ b/arch/arm/plat-omap/include/plat/omap34xx.h
@@ -74,8 +74,12 @@
 
 #define OMAP34XX_IVA_INTC_BASE	0x40000000
 #define OMAP34XX_HSUSB_OTG_BASE	(L4_34XX_BASE + 0xAB000)
-#define OMAP34XX_HSUSB_HOST_BASE	(L4_34XX_BASE + 0x64000)
 #define OMAP34XX_USBTLL_BASE	(L4_34XX_BASE + 0x62000)
+#define OMAP34XX_UHH_CONFIG_BASE	(L4_34XX_BASE + 0x64000)
+#define OMAP34XX_OHCI_BASE	(L4_34XX_BASE + 0x64400)
+#define OMAP34XX_EHCI_BASE	(L4_34XX_BASE + 0x64800)
+#define OMAP34XX_SR1_BASE	0x480C9000
+#define OMAP34XX_SR2_BASE	0x480CB000
 
 #define OMAP34XX_MAILBOX_BASE		(L4_34XX_BASE + 0x94000)
 

--8t9RHnE3ZwKMSgU+--
