Return-Path: <linux-kernel-owner+w=401wt.eu-S1756510AbZA3SVe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756510AbZA3SVe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 13:21:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753790AbZA3SUa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 13:20:30 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43620 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753811AbZA3SU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 13:20:28 -0500
Message-ID: <498344E9.5030707@zytor.com>
Date: Fri, 30 Jan 2009 10:20:25 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: blp@cs.stanford.edu
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: do not expose CONFIG_BSWAP to userspace
References: <20090127222825.GA27097@elte.hu> <alpine.LFD.2.00.0901271441280.3123@localhost.localdomain> <1233106614.3256.6.camel@localhost.localdomain> <200901281337.52294.arnd@arndb.de> <49809A65.2090501@kernel.org> <1233170532.6717.49.camel@brick> <alpine.LFD.2.00.0901281141510.3123@localhost.localdomain> <1233172994.6717.56.camel@brick> <4980CD51.70601@zytor.com> <1233179884.6717.59.camel@brick> <4980D913.3000505@zytor.com> <1233182314.6717.66.camel@brick> <873af36niw.fsf@blp.benpfaff.org>
In-Reply-To: <873af36niw.fsf@blp.benpfaff.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ben Pfaff wrote:
> Harvey Harrison <harvey.harrison@gmail.com> writes:
> 
>> Is there a byteswap builtin in gcc?  At least AVR32
>> seems to use it, but perhaps it's not generally exposed...perhaps we
>> could ask the gcc-folk?
> 
> Yes, GCC has byteswap builtins on x86 documented as follows:
> 
>  -- Built-in Function: int32_t __builtin_bswap32 (int32_t x)
>      Returns X with the order of the bytes reversed; for example,
>      `0xaabbccdd' becomes `0xddccbbaa'.  Byte here always means exactly
>      8 bits.
> 
>  -- Built-in Function: int64_t __builtin_bswap64 (int64_t x)
>      Similar to `__builtin_bswap32', except the argument and return
>      types are 64-bit.
> 
> These were only added as of GCC 4.3 though.

It would make sense to use them if gcc >= 4.3 (both for userspace and
kernel space.)  IMO, for older compilers we can just punt on the
enhancement for userspace and fall back to the i386 code.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

