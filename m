Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758418Ab0BNKN1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 05:13:27 -0500
Received: from casper.infradead.org ([85.118.1.10]:60699 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758378Ab0BNKMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 05:12:54 -0500
Subject: Re: [PATCH 2/5] bitops: compile time optimization for
 hweight_long(CONSTANT)
From: Peter Zijlstra <peterz@infradead.org>
To: Borislav Petkov <bp@amd64.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Borislav Petkov <petkovbb@googlemail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       LKML <linux-kernel@vger.kernel.org>, Jamie Lokier <jamie@shareable.org>,
       Roland Dreier <rdreier@cisco.com>, Al Viro <viro@ZenIV.linux.org.uk>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Brian Gerst <brgerst@gmail.com>
In-Reply-To: <20100211172424.GB19779@aftab>
References: <1265296432.22001.18.camel@laptop>
	 <20100204155419.GD32711@aftab> <1265299457.22001.72.camel@laptop>
	 <20100205121139.GA9044@aftab> <4B6C93A2.1090302@zytor.com>
	 <20100206093659.GA28326@aftab> <4B6E1DA3.50204@zytor.com>
	 <20100208092845.GB12618@a1.tnic> <4B6FDAED.9060204@zytor.com>
	 <20100208095945.GA14740@a1.tnic>  <20100211172424.GB19779@aftab>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 14 Feb 2010 11:12:23 +0100
Message-ID: <1266142343.5273.419.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-02-11 at 18:24 +0100, Borislav Petkov wrote:
> On Mon, Feb 08, 2010 at 10:59:45AM +0100, Borislav Petkov wrote:
> > Let me prep another version when I get back on Wed. (currently
> > travelling) with all the stuff we discussed to see how it would turn.
> 
> Ok, here's another version ontop of PeterZ's patch at
> http://lkml.org/lkml/2010/2/4/119. I need to handle 32- and 64-bit
> differently wrt to popcnt opcode so on 32-bit I do "popcnt %eax, %eax"
> while on 64-bit I do "popcnt %rdi, %rdi".

Right, so I don't like how you need to touch !x86 for this, and I think
that is easily avoidable by not making x86 include
asm-generic/bitops/arch_hweight.h.

If you then add __sw_hweightN() -> __arch_hweightN() wrappers in
arch_hweight.h, then you can leave const_hweight.h use __arch_hweightN()
and simply provide __arch_hweightN() from x86/include/asm/bitops.h


