Return-Path: <linux-kernel-owner+w=401wt.eu-S1755674AbZFEO6h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755674AbZFEO6h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 10:58:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752571AbZFEO62
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 10:58:28 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:58736 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751798AbZFEO60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 10:58:26 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] dma-debug: disable DMA_API_DEBUG for now
Date: Fri, 5 Jun 2009 15:57:56 +0100
User-Agent: KMail/1.11.90 (Linux/2.6.30-5-generic; KDE/4.2.85; x86_64; ; )
Cc: joerg.roedel@amd.com, torvalds@linux-foundation.org, mingo@elte.hu,
       lethal@linux-sh.org, just.for.lkml@googlemail.com, hancockrwd@gmail.com,
       jens.axboe@oracle.com, bharrosh@panasas.com,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
References: <20090605173232N.fujita.tomonori@lab.ntt.co.jp> <20090605104132.GE24836@amd.com> <20090605203753K.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20090605203753K.fujita.tomonori@lab.ntt.co.jp>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200906051557.58809.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+6kQ6tG4rJPGcpOc1MkTZtJ2dNWecJQYqEQZ+
 gBcQr2g7zlfgHx2+hlBqeriXHhpjy2mfLLS+kvM3IJ2u+IvtY9
 91jkH9e7xoKAewzxOxUFg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 05 June 2009, FUJITA Tomonori wrote:
> I think that the better fix can handle both cases per device:
> 
> - multiple identical dma addresses should not happen (with devices
>   behind hardware IOMMU)
> - multiple identical dma addresses could happen

I guess you could also have the case where for a given range
of addresses, you use a linear mapping and the dma addresses
can be identical, while for other physical addresses you would
rely on address translation.

For example on PowerPC/Cell with infiniband adapters, you can get
linear mapping behavior for DMA_ATTR_WEAK_ORDERING but IOMMU
translation without that flag, for the same device and same
physical address.

	Arnd <><
