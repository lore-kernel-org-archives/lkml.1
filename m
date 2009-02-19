Return-Path: <linux-kernel-owner+w=401wt.eu-S1755626AbZBSNm1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755626AbZBSNm1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 08:42:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750851AbZBSNmR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 08:42:17 -0500
Received: from vervifontaine.sonytel.be ([80.88.33.193]:43458 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750826AbZBSNmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 08:42:16 -0500
Date: Thu, 19 Feb 2009 14:42:14 +0100 (CET)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Jared Hulbert <jaredeh@gmail.com>
cc: Herbert Xu <herbert@gondor.apana.org.au>, linux-crypto@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Phillip Lougher <phillip@lougher.demon.co.uk>
Subject: Re: [PATCH 5/5] squashfs: Make SquashFS 4 use the new pcomp crypto
  interface
In-Reply-To: <6934efce0902181624q57f3423dm50cda218781e4399@mail.gmail.com>
Message-ID: <alpine.LRH.2.00.0902191415220.14749@vixen.sonytel.be>
References: <1234972402-24298-1-git-send-email-Geert.Uytterhoeven@sonycom.com> <1234972402-24298-2-git-send-email-Geert.Uytterhoeven@sonycom.com> <1234972402-24298-3-git-send-email-Geert.Uytterhoeven@sonycom.com> <1234972402-24298-4-git-send-email-Geert.Uytterhoeven@sonycom.com>
 <1234972402-24298-5-git-send-email-Geert.Uytterhoeven@sonycom.com> <1234972402-24298-6-git-send-email-Geert.Uytterhoeven@sonycom.com> <6934efce0902181624q57f3423dm50cda218781e4399@mail.gmail.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Hi Jared,

How's AXFS going?

On Wed, 18 Feb 2009, Jared Hulbert wrote:
> > Modify SquashFS 4 to use the new "pcomp" crypto interface for decompression,
> > instead of calling the underlying zlib library directly. This simplifies e.g.
> > the addition of support for hardware decompression and different decompression
> > algorithms.
> 
> When did this become an option?  I thought zlib in the crypto
> interface was not compatible with zlib.  Is that not the case anymore?

The "deflate" crypto module uses hardcoded parameters for the raw deflate mode,
that's why it's incompatible.

However, the new "zlib" crypto module is compatible with zlib, as you can
specify the all (de)compression parameters.

BTW, you probably want to read the full patch series, including the
introduction :-)

>  Have you looked at AXFS enough to judge if this would be as easy a
> job as it looks to convert?

I looked at the relevant code in AXFS before.  Yes, I think it would be an
easy job.

> How do you get from here to supporting alternate compressors?

Your file system code needs a mapping from compressor ID (as stored in your
file system metadata) to crypto module name and (de)compression parameters.

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
