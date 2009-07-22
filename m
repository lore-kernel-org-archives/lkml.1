Return-Path: <linux-kernel-owner+w=401wt.eu-S1752495AbZGVIfz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752495AbZGVIfz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 04:35:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751706AbZGVIfz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 04:35:55 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:59057 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751476AbZGVIfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 04:35:54 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: Do cpu-endian MMIO accessors exist?
Date: Wed, 22 Jul 2009 10:35:49 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-3-generic; KDE/4.2.96; x86_64; ; )
Cc: Pekka Paalanen <pq@iki.fi>, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@infradead.org>, lethal@linux-sh.org,
       linux-sh@vger.kernel.org
References: <20090721234243.1928d9e2@daedalus.pq.iki.fi> <200907220005.27583.arnd@arndb.de> <4A66BEAD.3080404@gmail.com>
In-Reply-To: <4A66BEAD.3080404@gmail.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200907221035.50025.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/VoiC+7qMF/lXyoPvoOsZOqR1n2AM810HPn5/
 cie/0XevuSQ04BV6Zsl7JXRUmT6g3LXg6QfaeuhrHwFYSlDF0e
 iXqPIFsxwpOQRXOgdETyBT6tGzfQs0R
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 22 July 2009, Jiri Slaby wrote:
> No, I should have written this explicitly. I meant read* have a barrier,
> whereas ioread* do not. Similarly for writes. Is this expected?
> 
> For example:
> #define __raw_readl(a) (__chk_io_ptr(a), *(volatile u32 __force *)(a))
> #define readl(a)       ({ u32 r_ = __raw_readl(a); mb(); r_; })
> #define ioread32(a)    __raw_readl(a)

No, this looks like a bug. I would have expected

#define ioread32(a)    readl(a)

in this case. Also, ioread32 should actually multiplex between
readl() and inl() based on the address token, as the code in
lib/iomap.c does. It's probably easy enough to enable
CONFIG_GENERIC_IOMAP on sh, and remove the ioread*/iowrite*
macros from arch/sh/include/asm/io.h.

	Arnd <><
