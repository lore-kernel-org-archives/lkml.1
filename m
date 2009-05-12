Return-Path: <linux-kernel-owner+w=401wt.eu-S1760573AbZELLOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760573AbZELLOU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 07:14:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759021AbZELLN6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 07:13:58 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:52842 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759364AbZELLN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 07:13:56 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] ata: libata depends on HAS_DMA
Date: Tue, 12 May 2009 11:23:20 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>,
       linux-ide@vger.kernel.org, takata@linux-m32r.org, geert@linux-m68k.org,
       linux-m68k@vger.kernel.org, ysato@users.sourceforge.jp
References: <20090511222702.352192505@arndb.de> <200905112238.55404.arnd@arndb.de> <20090512090602.65722342@lxorguk.ukuu.org.uk>
In-Reply-To: <20090512090602.65722342@lxorguk.ukuu.org.uk>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905121123.21436.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+SAyt5VQKNfy0ybLtM7LyT0Gvtlbk7dAPH8HE
 L0/WXOfagiiekgm8gICfJBWkhYFeiUMS4KPJNJFhJHPEVrABeN
 jCHGoGF8AAO8tiVSzac3A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 12 May 2009, Alan Cox wrote:
> Nakked-by: Alan Cox <alan@linux.intel.com>
> 
> Almost every PATA adapter can fall back to PIO, many are PIO only. We
> need a rather cleaner way to sort this.

Currently, the only architectures that don't set HAS_DMA are h8300, m32r
m68k (except SUN3 and Coldfire), microblaze and s390.
s390 will never get it, microblaze is currently implementing dma-mapping.h.

The other three are still using drivers/ide instead of drivers/ata.

One way to fix this would be to implement dma-mapping.h in h8300, m32r and
m68k and leave !HAS_DMA as the obscure s390 case (this one already can't
use ATA because of !HAS_MMIO).

The other way would be to add some #ifdef CONFIG_HAS_DMA in libata-core.c
and sas_ata.c.

	Arnd <><

	Arnd <><

