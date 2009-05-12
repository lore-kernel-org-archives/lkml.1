Return-Path: <linux-kernel-owner+w=401wt.eu-S1754462AbZELNGW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754462AbZELNGW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 09:06:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752917AbZELNGG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 09:06:06 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:56915 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752521AbZELNGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 09:06:05 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] ata: libata depends on HAS_DMA
Date: Tue, 12 May 2009 15:05:45 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <20090511222702.352192505@arndb.de> <4A08C9C0.6040202@pobox.com> <200905121440.09315.arnd@arndb.de>
In-Reply-To: <200905121440.09315.arnd@arndb.de>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Disposition: inline
Message-Id: <200905121505.46063.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18FTbf4VddauLm1gGb3ulhJf9A0tXzi5l4h2Rm
 Q9MFD7KtJfaUiyiWbkK5f9jO/svBES3bmGJ4w3v6vLA475EeB0
 5LWfPo/qKosl0ETXif6/w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id n4CD6nlL006008

On Tuesday 12 May 2009, Arnd Bergmann wrote:> +#ifdef CONFIG_HAS_DMA>         ap->prd = dmam_alloc_coherent(dev, ATA_PRD_TBL_SZ, &ap->prd_dma,>                                       GFP_KERNEL);> +#else> +       ap->prd = devres_alloc(dev, ATA_PRD_TBL_SZ, GFP_KERNEL);> +#endif /* CONFIG_HAS_DMA */>         if (!ap->prd)>                 return -ENOMEM;
this should have been devm_kzalloc, not devres_alloc.
	Arnd <><ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éÝ¶¥Šwÿº{.nÇ+‰·¥Š{±þG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŽŠÝ¢j"ú¶m§ÿÿ¾«þG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
