Return-Path: <linux-kernel-owner+w=401wt.eu-S1761118AbYCCDVb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761118AbYCCDVb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 22:21:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758016AbYCCDVO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 22:21:14 -0500
Received: from gate.crashing.org ([63.228.1.57]:45827 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757787AbYCCDVM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 22:21:12 -0500
In-Reply-To: <4a8566f54ff84f498c5c0c0340076c296b1840e6@tazenda.hos.anvin.org>
References: <4a8566f54ff84f498c5c0c0340076c296b1840e6@tazenda.hos.anvin.org>
Mime-Version: 1.0 (Apple Message framework v623)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <7e0381d9932a37ad78f0c38b2a3c6a03@kernel.crashing.org>
Content-Transfer-Encoding: 7bit
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Arch Mailing List <linux-arch@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Brownell <dbrownell@users.sourceforge.net>
From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: [PATCH 1/2] Add C99-style constructor macros for specific-sized integers
Date: Mon, 3 Mar 2008 04:20:37 +0100
To: "H. Peter Anvin" <hpa@zytor.com>
X-Mailer: Apple Mail (2.623)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Although it is fully legal and correct C to write something like:
>
> 	 (u64)0x123456789abcdef
>
> .. gcc will issue a warning on 32-bit systems that 0x123456789abcdef
> is too big for an "int", and that it has been transparently promoted,
> even though it is obvious that that is what the user intended in the
> first place.

[It says it is too big for 'long', actually].

That's because this is not valid ISO C90.  GCC tries to help you out
by using the C99 rules (it has to do something, and terminating with
an error would be a bit rude).  Perhaps the kernel should use C99
mode (-std=gnu99, to get the GNU C extensions).

> +#define S8_C(x)	 x
> +#define U8_C(x)  x ## U
> +#define S16_C(x) x
> +#define U16_C(x) x ## U
> +#define S32_C(x) x
> +#define U32_C(x) x ## U

These are unnecessary, Linux requires an int to be at least 32 bits.

> +#define S64_C(x) x ## LL
> +#define U64_C(x) x ## ULL

Here you can use LL resp. ULL on all archs.


Do these new macros really buy anything over just writing LL in the
few places that 64-bit constants are used?


Segher

