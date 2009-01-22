Return-Path: <linux-kernel-owner+w=401wt.eu-S1756706AbZAVMFr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756706AbZAVMFr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 07:05:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753046AbZAVMFi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 07:05:38 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:56685 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751725AbZAVMFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 07:05:37 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Anton Vorontsov <avorontsov@ru.mvista.com>
Subject: Re: [PATCH 10/10] mmc: Add OpenFirmware bindings for SDHCI driver
Date: Thu, 22 Jan 2009 13:05:28 +0100
User-Agent: KMail/1.9.9
Cc: Pierre Ossman <drzeus-sdhci@drzeus.cx>, Ben Dooks <ben-linux@fluff.org>,
       Kumar Gala <galak@kernel.crashing.org>,
       Liu Dave <DaveLiu@freescale.com>, Xie Xiaobo <X.Xie@freescale.com>,
       Konjin Lai <Konjin.Lai@freescale.com>,
       "Joe D'Abbraccio" <Joe.D'abbraccio@freescale.com>,
       sdhci-devel@list.drzeus.cx, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
References: <20090122015649.GA6835@oksana.dev.rtsoft.ru> <20090122020041.GJ11492@oksana.dev.rtsoft.ru>
In-Reply-To: <20090122020041.GJ11492@oksana.dev.rtsoft.ru>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901221305.29532.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18+6ZlKG2iOCxVcjJ69qEMrmp2HAjT7GXW9U+U
 qRK16+dALxJXqhQ2wg4IyqMiAzKzP0REnCXws0yMMLhaoLLvkG
 RiF66X0BtDXReu2JPZ8Ow==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 22 January 2009, Anton Vorontsov wrote:
> This patch adds a new driver: sdhci-of. The driver is similar to
> the sdhci-pci, it contains common probe code, and controller-specific
> ops and quirks.
> 
> So far there are only Freescale eSDHC ops and quirks.

Looks very good overall.

Acked-by: Arnd Bergmann <arnd@arndb.de>

> +	ret = of_address_to_resource(np, 0, &mem);
> +	if (ret)
> +		goto err_no_addr;
> +
> +	host->ioaddr = ioremap(mem.start, resource_size(&mem));
> +	if (!host->ioaddr) {
> +		ret = -ENOMEM;
> +		goto err_addr_map;
> +	}

Minor improvement: you could use of_iomap to do this in one step.

	Arnd <><
