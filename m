Return-Path: <linux-kernel-owner+w=401wt.eu-S1754695AbYHVMEZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695AbYHVMEZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 08:04:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753074AbYHVMEP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 08:04:15 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:60944 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752314AbYHVMEO (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 08:04:14 -0400
Date: Fri, 22 Aug 2008 14:04:12 +0200 (CEST)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Arnd Bergmann <arnd@arndb.de>
cc: Jared Hulbert <jaredeh@gmail.com>, Linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org,
       linux-mtd <linux-mtd@lists.infradead.org>,
       =?utf-8?q?J=C3=B6rn?= Engel <joern@logfs.org>, tim.bird@am.sony.com,
       cotte@de.ibm.com, nickpiggin@yahoo.com.au
Subject: Re: [PATCH 03/10] AXFS: axfs.h
In-Reply-To: <200808221327.37371.arnd@arndb.de>
Message-ID: <Pine.LNX.4.64.0808221402170.17105@vixen.sonytel.be>
References: <48AD00E6.2070505@gmail.com> <200808211424.31966.arnd@arndb.de>
 <6934efce0808211540p237f2c52pd71c2b955b3f54a8@mail.gmail.com>
 <200808221327.37371.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584349381-947473005-1219406652=:17105"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584349381-947473005-1219406652=:17105
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Fri, 22 Aug 2008, Arnd Bergmann wrote:
> On Friday 22 August 2008, Jared Hulbert wrote:
> > If I have an array of u64 numbers tracking small numbers (a[0] = 1;
> > a[1] = 2;) just throwing that onmedia is a big waste.
> > (0x0000000000000001; 0x0000000000000002)  Having different array types
> > for different images such as arrays of u8,u16,u32,u64 becomes less
> > efficient for 3,5,6 and 7 byte numbers, 3 bytes was a particularly
> > interesting size for me.
> > 
> > All I'm doing is removing the totally unnecessary zeros and aligning by bytes.
> > Take an array of u64 like this :
> > 0x0000000000000005
> > 0x0000000000001001
> > 0x00000000000a0000
> > 
> > I strip off the unneeded leading zeros:
> > 0x000005
> > 0x001001
> > 0x0a0000
> > 
> > Then pack them to byte alignment:
> > 0x0000050010010a0000
> > 
> > Sure it could be encoded more but that would make it harder to extract
> > the data.  This way I can read the data in one, maybe two, cache
> > misses.  A couple of shifts to deal with the alignment and endianness
> > and we are done.
> 
> So do I understand right that 3 bytes is your minimum size, and going
> smaller than that would not be helpful? Otherwise I would assume that
> storing a '5' should only take one byte instead of three.

>From the paper, the minimum size (called `depth') is 1.

> I don't unsterstand yet why you store the length of each word separate
> from the word. Most variable-length codes store that implicitly in
> the data itself, e.g. in the upper three bits, so that for storing
> 0x5, 0x1001, 0xa0000, this could e.g. end up as 0x054010014a0000,
> which is shorter than what you have, but not harder to decode.

AFAIU, the length (`depth') of each word is not stored separate, as the
depth is the same for all values in the same table.

With kind regards,

Geert Uytterhoeven
Software Architect

Sony Techsoft Centre Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium

Phone:    +32 (0)2 700 8453
Fax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

A division of Sony Europe (Belgium) N.V.
VAT BE 0413.825.160 · RPR Brussels
Fortis · BIC GEBABEBB · IBAN BE41293037680010
---584349381-947473005-1219406652=:17105--
