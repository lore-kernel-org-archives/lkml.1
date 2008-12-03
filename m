Return-Path: <linux-kernel-owner+w=401wt.eu-S1753836AbYLCMOX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753836AbYLCMOX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 07:14:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753016AbYLCMOK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 07:14:10 -0500
Received: from moutng.kundenserver.de ([212.227.126.188]:60374 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751662AbYLCMOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 07:14:09 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] Clean up namespace in kmap_types.h
Date: Wed, 3 Dec 2008 13:13:57 +0100
User-Agent: KMail/1.9.9
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
References: <20081203003620.GA32069@basil.nowhere.org> <200812031140.02338.arnd@arndb.de> <20081203112049.GI6703@one.firstfloor.org>
In-Reply-To: <20081203112049.GI6703@one.firstfloor.org>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812031313.57754.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX194kiIJc+LO0iASXu69vVaX6Y/57B1xCU3nDen
 M1aAailCJgRhhel8RSFH/8yZ9KPKt9oRApsV9tPU84sCG4uKQ5
 cltRrTVkzrgWLv/EAM6Bw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 03 December 2008, Andi Kleen wrote:

> > The patch looks ok, but it seems wrong to do this only on one architecture,
> > because kmap_types.h is mostly identical across all architectures.
> > 
> > I'm working on patches to consolidate a lot of generic headers, why not
> > add this in a generic way and make x86 use that version?
> 
> I was hoping that it could be still fixed for 2.6.28. Perhaps
> that would be too intrusive that late? That is why I hope
> it can be still considered even if it's x86 only.

I don't think it's too intrusive, it just doesn't fit the 'strictly
bug fixes' definition.

> For .29 I suspect in fact the best way would be to just move it into linux
> and use a superset because I don't think it's a big problem to waste 3-4
> pages of virtual space for this.

Yes, that would work as well. FWIW, we currently have the following
nonstandard kmap types:

avr32: KM_PTE2 (unused)
frv: __KM_CACHE, __KM_PGD, __KM_ITLB_PTD, __KM_DTLB_PTD (unused
	except for __KM_CACHE)
powerpc: KM_PPC_SYNC_PAGE, KM_PPC_SYNC_ICACHE

It should be fair to introduce common types KM_DCACHE (__KM_CACHE
and KM_PPC_SYNC_PAGE) and KM_ICACHE (KM_PPC_SYNC_ICACHE) for these.

> > --- /dev/null
> > +++ b/include/asm-generic/kmap_types.h
> > @@ -0,0 +1,29 @@
> > +#ifndef __ASM_GENERIC_KMAP_TYPES_H
> > +#define __ASM_GENERIC_KMAP_TYPES_H
> 
> So are you submitting this?

It's part of a larger series that I'm planning to submit for 2.6.29,
but I wouldn't mind if you take care of this file independently.

	Arnd <><
