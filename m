Return-Path: <linux-kernel-owner+w=401wt.eu-S1754276AbZEOLST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754276AbZEOLST (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 07:18:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752592AbZEOLR7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 07:17:59 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:51762 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956AbZEOLR6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 07:17:58 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH] ata: libata depends on HAS_DMA
Date: Fri, 15 May 2009 13:16:30 +0200
User-Agent: KMail/1.9.9
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, hancockrwd@gmail.com,
       alan@lxorguk.ukuu.org.uk, flar@allandria.com,
       schmitz@biophys.uni-duesseldorf.de, linux-kernel@vger.kernel.org,
       jgarzik@pobox.com, linux-ide@vger.kernel.org, takata@linux-m32r.org,
       geert@linux-m68k.org, linux-m68k@vger.kernel.org,
       ysato@users.sourceforge.jp
References: <20090513043409.GA13577@cynthia.pants.nu> <20090514091928R.fujita.tomonori@lab.ntt.co.jp> <4A0CFE1F.5080409@gmail.com>
In-Reply-To: <4A0CFE1F.5080409@gmail.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200905151316.31521.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX193nZ5mTixXcBwTaX5pgSTA0ziV1N549JvUnel
 A24eTawpnSdRUZo6M8nbmPNYl4QR6qtOjk5iyJtDL3dq0lolMV
 1zH3EM9HFzwfUMVc7ijyg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 15 May 2009, Tejun Heo wrote:
> FUJITA Tomonori wrote:
> > Can libata call dma_supported() per device to decide DMA or PIO mode?
> > Then, we can solve this problem by add dummy DMA API (just calls BUG)
> > on such architectures, without Kconfig magic or adding ifdef (like the
> > old ide stack does), I think.

That would be the !CONFIG_PCI half of the old
include/asm-generic/dma-mapping.h file that you just removed,
right?

In general, I'd prefer keeping the asm-generic/dma-mapping-broken.h
implementation that gives us a compile-time error, but maybe there
is an even better option based on the mn10300 implementation which
basically pretends everything works with just page_to_phys() mappings.

> Sure it can.  Which specific drivers are we talking about?

The main problem is libata-core.c, which references DMA mapping
API calls that are only implemented on architectures setting
CONFIG_HAS_DMA.

	Arnd <><
