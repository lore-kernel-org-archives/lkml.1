Return-Path: <linux-kernel-owner+w=401wt.eu-S1754531AbZEOL5P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754531AbZEOL5P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 07:57:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753198AbZEOL4z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 07:56:55 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:53100 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751108AbZEOL4x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 07:56:53 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH] ata: libata depends on HAS_DMA
Date: Fri, 15 May 2009 13:55:08 +0200
User-Agent: KMail/1.9.9
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, hancockrwd@gmail.com,
       alan@lxorguk.ukuu.org.uk, flar@allandria.com,
       schmitz@biophys.uni-duesseldorf.de, linux-kernel@vger.kernel.org,
       jgarzik@pobox.com, linux-ide@vger.kernel.org, takata@linux-m32r.org,
       geert@linux-m68k.org, linux-m68k@vger.kernel.org,
       ysato@users.sourceforge.jp
References: <20090513043409.GA13577@cynthia.pants.nu> <200905151316.31521.arnd@arndb.de> <4A0D5051.90708@gmail.com>
In-Reply-To: <4A0D5051.90708@gmail.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905151355.09888.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+ZjH5ejIpBCx5a88laAP7XGrqHGWJSNDtzTSx
 G6eVwy4PnkMiZC4zg6rXqGOXgiSsBYP0BSKAmMuh7QaWgkg2F0
 GrszUksW7EuyqIE5ZCCDA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 15 May 2009, Tejun Heo wrote:
> Don't know much history here but I don't wanna sprinkle ifdefs around
> in libata so I would much prefer dummy implementation which doesn't
> fail compile.

My original patch did that by adding 'depends on HAS_DMA'.

The only architectures that don't have that are m68k, m32r,
h8300, s390 and microblaze. More research has shown that
they all found a different way to disable the ATA drivers
already, except microblaze.

Alan, you objected the patch initially (and loudly), but
maybe you can reconsider this. The only actual effect
that my patch has is to allow an allyesconfig build on
microblaze and that will implement dma-mapping.h in the
next version.

All existing architectures do not care at all about this
change, unless I'm missing something.

Besides, all the other users of the DMA mapping API
also depend on CONFIG_HAS_DMA.

	Arnd <><
