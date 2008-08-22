Return-Path: <linux-kernel-owner+w=401wt.eu-S1757152AbYHVSMs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757152AbYHVSMs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 14:12:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754955AbYHVSMe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 14:12:34 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:4277 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755960AbYHVSMd (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 14:12:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=UejSTO27oVqd1RmKLNmc7S9aVCXMGlvYbwh9I41H/FsDYpXMiHXOpiAliBGd7xNrUJ
         OLm2PZAS2An/rMk4NG1Q/w4Mlo3kRIAECGM3n0KUphwaJZr8lkYORNfo2Da4GHrVCi0V
         +Rhz51T0D8a1XyW4FouZMqXiecZ9X8vXirmA0=
Message-ID: <6934efce0808221112p64fe1346kc5530ca71dbb108b@mail.gmail.com>
Date: Fri, 22 Aug 2008 11:12:32 -0700
From: "Jared Hulbert" <jaredeh@gmail.com>
To: "Geert Uytterhoeven" <Geert.Uytterhoeven@sonycom.com>
Subject: Re: [PATCH 03/10] AXFS: axfs.h
Cc: "Arnd Bergmann" <arnd@arndb.de>, Linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org,
       linux-mtd <linux-mtd@lists.infradead.org>,
       "=?UTF-8?Q?J=C3=B6rn_Engel?=" <joern@logfs.org>, tim.bird@am.sony.com,
       cotte@de.ibm.com, nickpiggin@yahoo.com.au
In-Reply-To: <Pine.LNX.4.64.0808221402170.17105@vixen.sonytel.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48AD00E6.2070505@gmail.com> <200808211424.31966.arnd@arndb.de>
	 <6934efce0808211540p237f2c52pd71c2b955b3f54a8@mail.gmail.com>
	 <200808221327.37371.arnd@arndb.de>
	 <Pine.LNX.4.64.0808221402170.17105@vixen.sonytel.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> So do I understand right that 3 bytes is your minimum size, and going
>> smaller than that would not be helpful? Otherwise I would assume that
>> storing a '5' should only take one byte instead of three.

Right.  But you need 3 bytes to store the maximum value 0x0a0000

If we had:
0x0000000000000003
0x00000000000000FF
0x000000000000000A

You would only need a 1 byte depth.

> From the paper, the minimum size (called `depth') is 1.

Correct the depth can be from 1 to 8 bytes.  The depth is determined
by the maximum value in the array.

>> I don't unsterstand yet why you store the length of each word separate
>> from the word. Most variable-length codes store that implicitly in
>> the data itself, e.g. in the upper three bits, so that for storing
>> 0x5, 0x1001, 0xa0000, this could e.g. end up as 0x054010014a0000,
>> which is shorter than what you have, but not harder to decode.
>
> AFAIU, the length (`depth') of each word is not stored separate, as the
> depth is the same for all values in the same table.

That is correct.  Each table has a single depth stored in the region descriptor.
