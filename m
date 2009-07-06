Return-Path: <linux-kernel-owner+w=401wt.eu-S1754626AbZGFEun@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754626AbZGFEun (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 00:50:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750703AbZGFEud
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 00:50:33 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:44470 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750695AbZGFEuc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 00:50:32 -0400
From: "Pandita, Vikram" <vikram.pandita@ti.com>
To: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
       Jonathan McDowell <noodles@earth.li>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Tony Lindgren <tony@atomide.com>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
       "linux-arm-kernel@lists.arm.linux.org.uk" 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 6 Jul 2009 10:19:34 +0530
Subject: RE: [PATCH v2] OMAP1: AMS_DELTA: add modem support
Thread-Topic: [PATCH v2] OMAP1: AMS_DELTA: add modem support
Thread-Index: Acn9eZuhHfMxrk4ISCGVoFSdsfF5bwAesm9Q
Message-ID: <FCCFB4CDC6E5564B9182F639FC35608702F5568724@dbde02.ent.ti.com>
References: <200907051601.49194.jkrzyszt@tis.icnet.pl>
In-Reply-To: <200907051601.49194.jkrzyszt@tis.icnet.pl>
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

Janusz/Alan 

>-----Original Message-----
>From: linux-omap-owner@vger.kernel.org [mailto:linux-omap-owner@vger.kernel.org] On Behalf Of Janusz
>Krzysztofik
>
+static int __init ams_delta_modem_init(void)
>+{
>+	omap_cfg_reg(M14_1510_GPIO2);
>+	ams_delta_modem_ports[0].irq = gpio_to_irq(2);
>+	set_irq_type(gpio_to_irq(2), IRQ_TYPE_EDGE_RISING);

There is a recent change on specifying irqflags as example:
http://patchwork.kernel.org/patch/31888/

There is a dependency for Alan Cox to push this patch first though:
http://patchwork.kernel.org/patch/31884/

Reference:
http://lkml.indiana.edu/hypermail/linux/kernel/0906.2/02827.html


>+
>+	ams_delta_latch2_write(
>+		AMS_DELTA_LATCH2_MODEM_NRESET | AMS_DELTA_LATCH2_MODEM_CODEC,
>+		AMS_DELTA_LATCH2_MODEM_NRESET | AMS_DELTA_LATCH2_MODEM_CODEC);
>+
>+	return platform_device_register(&ams_delta_modem_device);
>+}
>+arch_initcall(ams_delta_modem_init);
>+
> static void __init ams_delta_map_io(void)
> {
> 	omap1_map_common_io();
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-omap" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html

