Return-Path: <linux-kernel-owner+w=401wt.eu-S1754425AbZEDKs4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754425AbZEDKs4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 06:48:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751824AbZEDKsq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 06:48:46 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:63224 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751813AbZEDKsp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 06:48:45 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH 05/27] asm-generic: add generic io.h
Date: Mon, 4 May 2009 12:48:28 +0200
User-Agent: KMail/1.9.9
Cc: linux-arch@vger.kernel.org, Michal Simek <monstr@monstr.eu>,
       Remis Lima Baima <remis.developer@googlemail.com>,
       linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
References: <cover.1241105648.git.arnd@arndb.de> <19d8a91dbf3456f9eb0b0bb2f92b302b88a1c672.1241105648.git.arnd@arndb.de> <10f740e80905040007x38dfcdc5i4a7d351e59db71e9@mail.gmail.com>
In-Reply-To: <10f740e80905040007x38dfcdc5i4a7d351e59db71e9@mail.gmail.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200905041248.29400.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18jvqpdcBWOJsblIHHHAuOKuxWymgcngGlr5j8
 CEmH1sf97xWKH0BEJduEBrHk1j99FmzNB7MY1kza/6+QKaJI3Y
 Kt76EacqwYb9xaqDQGz9w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

io.h is more or less a straight copy from the mn10300 code,
so maybe David Howells is interested in this as well.

On Monday 04 May 2009, Geert Uytterhoeven wrote:
> On Thu, Nov 6, 2008 at 15:38, Arnd Bergmann <arnd@arndb.de> wrote:
> > +static inline void outsw(unsigned long addr, const void *buffer, int count)
> > +{
> > +       if (count) {
> > +               const u16 *buf = buffer;
> > +               do {
> > +                       outw(*buf++, addr);
> > +               } while (--count);
> > +       }
> > +}
> > +
> > +static inline void outsl(unsigned long addr, const void *buffer, int count)
> > +{
> > +       if (count) {
> > +               const u32 *buf = buffer;
> > +               do {
> > +                       outl(*buf++, addr);
> > +               } while (--count);
> > +       }
> > +}
> 
> Do we ever call these with count == 0?

I don't think it can, but code is still more correct if it can handle it.
It could of course be written as

	const u32 *buf;
	for (buf = buffer; count; count--)
		outl(*buf++, addr);


> > +/*
> > + * Change "struct page" to physical address.
> > + */
> 
> Which `struct page'?

I can change the comment to what avr32 and m32r have:

arch/avr32/include/asm/io.h-/*
arch/avr32/include/asm/io.h: * ioremap  -   map bus memory into CPU space
arch/avr32/include/asm/io.h- * @offset  bus address of the memory
arch/avr32/include/asm/io.h- * @size    size of the resource to map
arch/avr32/include/asm/io.h- *
arch/avr32/include/asm/io.h: * ioremap performs a platform specific sequence of operations to make
arch/avr32/include/asm/io.h- * bus memory CPU accessible via the readb/.../writel functions and
arch/avr32/include/asm/io.h- * the other mmio helpers. The returned address is not guaranteed to
arch/avr32/include/asm/io.h- * be usable directly as a virtual address.
arch/avr32/include/asm/io.h- */


	Arnd <><
