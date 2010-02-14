Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758509Ab0BNMX5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 07:23:57 -0500
Received: from casper.infradead.org ([85.118.1.10]:55020 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752793Ab0BNMX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 07:23:56 -0500
Subject: Re: [PATCH 2/5] bitops: compile time optimization for
 hweight_long(CONSTANT)
From: Peter Zijlstra <peterz@infradead.org>
To: Borislav Petkov <petkovbb@googlemail.com>
Cc: Borislav Petkov <bp@amd64.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       LKML <linux-kernel@vger.kernel.org>, Jamie Lokier <jamie@shareable.org>,
       Roland Dreier <rdreier@cisco.com>, Al Viro <viro@ZenIV.linux.org.uk>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Brian Gerst <brgerst@gmail.com>
In-Reply-To: <20100214112447.GA8353@liondog.tnic>
References: <1265299457.22001.72.camel@laptop> <20100205121139.GA9044@aftab>
	 <4B6C93A2.1090302@zytor.com> <20100206093659.GA28326@aftab>
	 <4B6E1DA3.50204@zytor.com> <20100208092845.GB12618@a1.tnic>
	 <4B6FDAED.9060204@zytor.com> <20100208095945.GA14740@a1.tnic>
	 <20100211172424.GB19779@aftab> <1266142343.5273.419.camel@laptop>
	 <20100214112447.GA8353@liondog.tnic>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 14 Feb 2010 13:23:35 +0100
Message-ID: <1266150215.5273.601.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-02-14 at 12:24 +0100, Borislav Petkov wrote:
> 
> So, if I understand you correctly, your suggestion might work, we
> simply need to rename the lib/hweight.c versions to __sw_hweightN
> and have <asm-generic/bitops/arch_hweight.h> have __arch_hweightN ->
> __sw_hweightN wrappers in the default case, all arches which have an
> optimized version will provide it in their respective bitops header...
> 
I'm not quite sure what the last 'it' refers to, does that refer to:
 1) an __arch_hweightN() implementation, or
 2) __arch_hweightN() -> __sw_hweightN() wrappers ?

If you meant 1, then yes.

