Return-Path: <linux-kernel-owner+w=401wt.eu-S1757957AbZJBOjK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757957AbZJBOjK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 10:39:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757954AbZJBOjJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 10:39:09 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:42170 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757933AbZJBOjI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 10:39:08 -0400
X-IronPort-AV: E=Sophos;i="4.44,494,1249272000"; 
   d="scan'208";a="5269144"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH v2] mfd: ADP5520 Multifunction LCD Backlight and Keypad Input Device Driver
Date: Fri, 2 Oct 2009 15:39:09 +0100
Message-ID: <8A42379416420646B9BFAC9682273B6D0E33B2C0@limkexm3.ad.analog.com>
In-Reply-To: <20091002131546.GB7575@sortiz.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
thread-topic: [PATCH v2] mfd: ADP5520 Multifunction LCD Backlight and Keypad Input Device Driver
thread-index: AcpDYk15HVRYTM/GRzKY1ddFQVDR0QAC6fhQ
References: <1253212036-29445-1-git-send-email-vapier@gentoo.org> <1253682664-27040-1-git-send-email-vapier@gentoo.org> <20091001140948.GD10199@sortiz.org> <8A42379416420646B9BFAC9682273B6D0E33AC35@limkexm3.ad.analog.com> <20091002131546.GB7575@sortiz.org>
From: "Hennerich, Michael" <Michael.Hennerich@analog.com>
To: "Samuel Ortiz" <sameo@linux.intel.com>
CC: "Mike Frysinger" <vapier@gentoo.org>, <linux-kernel@vger.kernel.org>,
       <uclinux-dist-devel@blackfin.uclinux.org>,
       "Bryan Wu" <cooloney@kernel.org>
X-OriginalArrivalTime: 02 Oct 2009 14:39:12.0056 (UTC) FILETIME=[1B83B380:01CA436E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>With 2 of those devices, your board file would look like that:
>
>static struct i2c_board_info __initdata board_i2c_board_info[] = {
>	{	/* APD5520 #1 */
>		I2C_BOARD_INFO("pmic-adp5520", SLAVE_ADDR_1),
>		.platform_data	= &apd5520_platform_1,
>	},
>	{	/* APD5520 #2 */
>		I2C_BOARD_INFO("pmic-adp5520", SLAVE_ADDR_2),
>		.platform_data	= &apd5520_platform_2,
>	},
>};
>
>and your platform data would be an aggregation of all subdevices
platform data
>structures:
>
>struct adp5520_platform_data {
>	struct adp5520_leds_platfrom_data *leds;
>	struct adp5520_keys_platfrom_data *keyp;
>	struct adp5520_gpio_platfrom_data *gpio;
>}
>
>Then, your mfd/adp5520.c will have that piece of code:
>
>static struct platform_device adp5520_gpio_device = {
>	.name	= "adp5520-gpio",
>	.id	= -1,
>}
>
>static struct platform_device *adp5520_subdevs[] = {
>	&adp5520_gpio_device,
>	&adp5520_leds_device,
>	&adp5520_keyp_device,
>}
>
>Finally, your i2c probe routine would assign platform_data pointers to
te
>right devices:
>
>static int __devinit adp5520_probe(struct i2c_client *client,
>					const struct i2c_device_id *id)
>{
>	struct adp5520_platform_data *pdata = client->dev.platform_data;
>[...]
>	for (i = 0; i < ARRAY_SIZE(adp5520_subdevs); i++) {
>		adp5520_subdevs[i]->dev.parent = &client->dev;
>		adp5520_assign_pdata(&adp5520_subdevs[i], pdata);
>	}
>
>	platform_add_devices(adp5520_subdevs,
>			ARRAY_SIZE(adp5520_subdevs));
>}
>
>Where adp5520_assign_pdata() is a routine setting the platform_device's
>platform_data pointer according e.g. to the platform_device name field.
>
>Would that make sense to you ?
>
>Cheers,
>Samuel.

I think that should work.
Thanks,

Michael



