Return-Path: <linux-kernel-owner+w=401wt.eu-S1752168AbZERI3n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752168AbZERI3n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 04:29:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751466AbZERI33
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 04:29:29 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:61438 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768AbZERI32 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 04:29:28 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH] asm-generic: add a dma-mapping.h file
Date: Mon, 18 May 2009 10:28:00 +0200
User-Agent: KMail/1.9.9
Cc: Jeff Garzik <jgarzik@pobox.com>, Robert Hancock <hancockrwd@gmail.com>,
       Tejun Heo <htejun@gmail.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       alan@lxorguk.ukuu.org.uk, flar@allandria.com,
       schmitz@biophys.uni-duesseldorf.de, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, takata@linux-m32r.org,
       linux-m68k@vger.kernel.org, ysato@users.sourceforge.jp
References: <20090513043409.GA13577@cynthia.pants.nu> <200905172245.23774.arnd@arndb.de> <10f740e80905172303n4ef3cfc2j9922e19c281d471b@mail.gmail.com>
In-Reply-To: <10f740e80905172303n4ef3cfc2j9922e19c281d471b@mail.gmail.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200905181028.01914.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18hgXsQxAgPyB7uqCm9GbSch3K/rhuKD3Mv/kk
 Pav3N8IQgd2wYtmtu6ac0mG6YEwcopjCSA2MTgVgyIZ+vy77Yu
 64mgvvSQq/BNJBBCeW7SQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 18 May 2009, Geert Uytterhoeven wrote:

> > +#ifndef dma_alloc_coherent
> > +static inline void *
> > +dma_alloc_coherent(struct device *dev, size_t size, dma_addr_t *dma_handle,
> > +                  gfp_t flag)
> > +{
> > +       void *virt = kmalloc(size, flag);
> 
> kmalloc() may fail.
> 
> > +       *dma_handle = virt_to_phys(virt);
> 
> Not all variants of virt_to_phys() may handle the NULL case very well.
> I took a statistically invalid sample: some just cast to unsigned
> long, other subtract PAGE_OFFSET.

Right. It should not really hurt, because all users need to check virt
before using dma_handle, but I can fix it just to be sure.

I'll wait for comments from Fujita Tomonori and others before I repost.

	Arnd <><
