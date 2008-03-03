Return-Path: <linux-kernel-owner+w=401wt.eu-S1761992AbYCCEnn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761992AbYCCEnn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 23:43:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761309AbYCCEnc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 23:43:32 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52277 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568AbYCCEnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 23:43:31 -0500
Message-ID: <47CB81EA.8070802@zytor.com>
Date: Sun, 02 Mar 2008 20:43:22 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Arch Mailing List <linux-arch@vger.kernel.org>,
       David Brownell <dbrownell@users.sourceforge.net>
Subject: Re: [PATCH 1/2] Add C99-style constructor macros for specific-sized
 integers
References: <4a8566f54ff84f498c5c0c0340076c296b1840e6@tazenda.hos.anvin.org> <20080303023851.GF24386@parisc-linux.org>
In-Reply-To: <20080303023851.GF24386@parisc-linux.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox wrote:
> On Sun, Mar 02, 2008 at 04:09:51PM -0800, H. Peter Anvin wrote:
>> first place.  C99 has macros of the form [U]INT#_C() to construct
>> numbers of an arbitrary size; this patch creates analogous macros for
>> the kernel s# and u# types.
> 
> Why put this in asm/types.h instead of, say, linux/types.h?
> 

Because that's where the s* and u* types are defined.

Realistically, those probably could/should be folded into a pair of 
asm-generic files (for 32 and 64 bits), but that is a separate change.

> I appreciate you have:
> 
>> +#define S64_C(x) x ## L
>> +#define U64_C(x) x ## UL
> 
> and:
> 
>> +#define S64_C(x) x ## LL
>> +#define U64_C(x) x ## ULL
> 
> but can't we use the latter for all arches?
> 

You really don't want to, as the whole point is that you want it to 
match what u64/s64 is defined as, in order to avoid spurious warnings.

	-hpa
