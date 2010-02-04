Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933261Ab0BDQE4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 11:04:56 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:60987 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932935Ab0BDQEz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 11:04:55 -0500
Subject: Re: [PATCH 2/5] bitops: compile time optimization for
 hweight_long(CONSTANT)
From: Peter Zijlstra <peterz@infradead.org>
To: Borislav Petkov <bp@amd64.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       LKML <linux-kernel@vger.kernel.org>, Jamie Lokier <jamie@shareable.org>,
       Roland Dreier <rdreier@cisco.com>, Al Viro <viro@ZenIV.linux.org.uk>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20100204155419.GD32711@aftab>
References: <20100201124825.cc024f2a.akpm@linux-foundation.org>
	 <20100203133951.GA24357@localhost>
	 <20100203070825.e36b3932.akpm@linux-foundation.org>
	 <1265210157.24455.646.camel@laptop>
	 <20100203074251.e2caa3f3.akpm@linux-foundation.org>
	 <20100203181425.GB1367@aftab> <1265222875.24455.1020.camel@laptop>
	 <4B69D362.10608@zytor.com> <20100204151050.GC32711@aftab>
	 <1265296432.22001.18.camel@laptop>  <20100204155419.GD32711@aftab>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 04 Feb 2010 17:04:17 +0100
Message-ID: <1265299457.22001.72.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-02-04 at 16:54 +0100, Borislav Petkov wrote:
> On Thu, Feb 04, 2010 at 04:13:52PM +0100, Peter Zijlstra wrote:
> > hweight_long() isn't an arch primitive, only __arch_hweight{8,16,32,64}
> > are.
> 
> Yeah, I'm still looking for the proper location. hweight_long() is the
> generic version so do we want to do the
> 
> #ifndef __HAVE_ARCH_POPCNT
> static inline unsigned long hweight_long(unsigned long w)
> ....
> 
> #endif
> 
> thing and define a x86-specific version? 

No, just don't touch hweight_long(), simply provide
__arch_hweight{8,16,32,64} and all will be well.

hweight_long() is provided by <include/linux.h> and is constructed from
height32() and hweight64() depending on the actual word size.

