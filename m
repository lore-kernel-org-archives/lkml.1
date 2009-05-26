Return-Path: <linux-kernel-owner+w=401wt.eu-S1755846AbZEZMf7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755846AbZEZMf7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 08:35:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752125AbZEZMfw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 08:35:52 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:61688 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086AbZEZMfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 08:35:51 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] asm-generic: add a dma-mapping.h file
Date: Tue, 26 May 2009 13:35:41 +0100
User-Agent: KMail/1.11.90 (Linux/2.6.30-5-generic; KDE/4.2.85; x86_64; ; )
References: <200905221607.34025.arnd@arndb.de> <200905221705.54426.arnd@arndb.de> <20090526122423S.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20090526122423S.fujita.tomonori@lab.ntt.co.jp>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?iso-8859-1?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60?=
 =?iso-8859-1?q?Y=2Ea=5E3zb?=)
 =?iso-8859-1?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5C?=
 =?iso-8859-1?q?wg=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200905261335.41643.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/MZCvIx9GoPIbivzPpwSr8vW968JnCE8z2w5f
 C73WleNT9mKGc+P4cC5lOIFlQBbq3jGn1TuzZ7FGSMtBLkTvdN
 IzK4lGguxhk1LogdolyW7cWOQLDvxnl
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 26 May 2009, FUJITA Tomonori wrote:
> > dma_get_cache_alignment() is still less generic than
> > the other functions, as this is still architecture
> > specific. Should I leave that out as well then?
> 
> Yes, I think that only adding generic functions is a better
> approach. Overriding with #ifdef is really ugly.
> 

Ok, will do.

[trimming Cc list a bit, as the subject has changed]

Could you be more specific as to why you think the #ifdef
in this file is ugly? I agree that we should always avoid
#ifdef in a device driver file or around the usage of an
API, but we use it everywhere when defining an optional
API, e.g.

#ifdef CONFIG_DMA_API_DEBUG
extern void dma_debug_add_bus(struct bus_type *bus);
#else
static inline void dma_debug_add_bus(struct bus_type *bus)
{
{
#endif

or

#ifndef clear_user_highpage
static inline void clear_user_highpage(struct page *page, unsigned long vaddr)
{
	void *addr = kmap_atomic(page, KM_USER0);
	clear_user_page(addr, vaddr, page);
	kunmap_atomic(addr, KM_USER0);
}
#endif

This has always made a lot of sense to me when you are defining
something that you want to become a No-op in certain configurations
or that only needs special handling in a few cases. IIRC, Linus
has stated that he prefers the second of the two styles above when
you have the choice, which is why I started out that way, while
for the dma_debug stuff, the CONFIG_ symbol clearly makes sense.

	Arnd <><
