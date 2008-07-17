Return-Path: <linux-kernel-owner+w=401wt.eu-S1758226AbYGQPfp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758226AbYGQPfp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 11:35:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754898AbYGQPfg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 11:35:36 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:43962 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754130AbYGQPff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 11:35:35 -0400
Date: Thu, 17 Jul 2008 17:35:30 +0200 (CEST)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Peter Korsgaard <jacmet@sunsite.dk>
cc: Phillip Lougher <phillip@lougher.demon.co.uk>,
       squashfs-devel@lists.sourceforge.net,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: [Squashfs-devel] Squashfs mainlining status?
In-Reply-To: <87od6h7d7l.fsf@macbook.be.48ers.dk>
Message-ID: <Pine.LNX.4.64.0807171729450.29859@vixen.sonytel.be>
References: <Pine.LNX.4.64.0806021650190.28709@vixen.sonytel.be>
 <48460906.2080205@lougher.demon.co.uk> <87od6h7d7l.fsf@macbook.be.48ers.dk>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584349381-1981335071-1216308712=:29859"
Content-ID: <Pine.LNX.4.64.0807171733030.29859@vixen.sonytel.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584349381-1981335071-1216308712=:29859
Content-Type: TEXT/PLAIN; CHARSET=UTF-8
Content-Transfer-Encoding: 8BIT
Content-ID: <Pine.LNX.4.64.0807171733031.29859@vixen.sonytel.be>

	Hi Peter,

On Wed, 4 Jun 2008, Peter Korsgaard wrote:
> >>>>> "Phillip" == Phillip Lougher <phillip@lougher.demon.co.uk> writes:
>  Phillip> The major work of course is the move to a little endian
>  Phillip> layout without any bit fields in the structures to make it
>  Phillip> easier to swap member fields on big-endian architectures.
>  Phillip> I'm currently working on this on a non-CVS branch.
>  Phillip> Most of the work till now has been without any attempt to
>  Phillip> retain backwards compatibility with the current 3.3
>  Phillip> little-endian filesystem layout.  After your private email
>  Phillip> regarding retaining backwards compatibility I will look
>  Phillip> again at this issue, it may well be that I will abandon my
>  Phillip> current layout changes that I have so far made.
> 
> What private mail? Anything of interest to the rest of the group? As I

Oops, I've just returned from holidays, and realize I never actually responded
to this question. So here is the gist of it:

| I had a closer look at the structures and bitfields, and I still think it's
| possible to stay compatible with the current little endian layout:
|   1. About half of the bitfields are actually bytes or 16-bit words. Hence
|      these can easily be converted to __u8 or __le16.
|   2. Most of the remaining bitfields sit in an 8, 16, or 32 bit integer.
|      Hence these can be converted to such an integer (or an array of bytes,
|      cfr. 3 below), and accessed using get_unaligned_le{16,32}() and a
|      shift/mask operation.
|   3. There are a few bitfields that sit in an `odd' number of bytes. These
|      can be converted to an array of bytes, and accessed using
|      get_unaligned_le{16,32}() and a shift/mask operation.
|   4. The integral fields in the structs should be accessed using
|      get_unaligned_le{8,16,32}(), too.

I noticed the squashfs CVS repository is getting a new (incompatible) 4.0
layout now?

What do people think?

With kind regards,

Geert Uytterhoeven
Software Architect

Sony Techsoft Centre Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium

Phone:    +32 (0)2 700 8453
Fax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@eu.sony.com
Internet: http://www.sony-europe.com/

A division of Sony Europe (Belgium) N.V.
VAT BE 0413.825.160 · RPR Brussels
Fortis 293-0376800-10 GEBA-BE-BB
---584349381-1981335071-1216308712=:29859--
