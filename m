Return-Path: <linux-kernel-owner+w=401wt.eu-S1758124AbZA2CVv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758124AbZA2CVv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 21:21:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753979AbZA2CVl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 21:21:41 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:34322 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752667AbZA2CVk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 21:21:40 -0500
From: "Woodruff, Richard" <r-woodruff2@ti.com>
To: Paul Walmsley <paul@pwsan.com>,
       "linux-arm-kernel@lists.arm.linux.org.uk" 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       Tony Lindgren <tony@atomide.com>
Date: Wed, 28 Jan 2009 20:21:18 -0600
Subject: RE: [PATCH B 06/10] OMAP3 pwrdm: add CORE SAR handling (for USBTLL
 module)
Thread-Topic: [PATCH B 06/10] OMAP3 pwrdm: add CORE SAR handling (for USBTLL
 module)
Thread-Index: AcmBhnLYe5oDZ7X8SeW1PvSu48njVAAMaGUg
Message-ID: <13B9B4C6EF24D648824FF11BE89671620376DEB7A5@dlee02.ent.ti.com>
References: <20090128024301.27240.39391.stgit@localhost.localdomain>
 <20090128024421.27240.95450.stgit@localhost.localdomain>
In-Reply-To: <20090128024421.27240.95450.stgit@localhost.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id n0T2LtwM011540

> 34xx TRM Delta G->H notes that the CORE powerdomain has a hardware
> save-and-restore (SAR) control bit for the USBTLL module, similar to
> the USBHOST powerdomain SAR bit.  Split the existing core_34xx struct
> powerdomain into two structs, one for ES1 and one for ES2, and add the
> PWRDM_HAS_HDWR_SAR flag to the ES2 powerdomain.
>
> Signed-off-by: Paul Walmsley <paul@pwsan.com>
> Signed-off-by: Tony Lindgren <tony@atomide.com>
> +
> +/* No wkdeps or sleepdeps for 34xx core apparently */
> +static struct powerdomain core_34xx_es2_pwrdm = {
> +     .name             = "core_pwrdm",
> +     .prcm_offs        = CORE_MOD,
> +     .omap_chip        = OMAP_CHIP_INIT(CHIP_IS_OMAP3430ES2),
>       .pwrsts           = PWRSTS_OFF_RET_ON,
>       .dep_bit          = OMAP3430_EN_CORE_SHIFT,
> +     .flags            = PWRDM_HAS_HDWR_SAR, /* for USBTLL only */
>       .banks            = 2,
>       .pwrsts_mem_ret   = {
>               [0] = PWRSTS_OFF_RET,    /* MEM1RETSTATE */

TLLSAR is not functional till ES3.1 (and beyound).  Is it possible to flag it this way?

If you try and use it your system will deadlock on 2nd OFF mode transition due to hardware bug.

Regards,
Richard W.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
