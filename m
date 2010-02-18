Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757323Ab0BRKwX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 05:52:23 -0500
Received: from casper.infradead.org ([85.118.1.10]:34543 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753530Ab0BRKwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 05:52:19 -0500
Subject: Re: [PATCH 2/5] bitops: compile time optimization for
 hweight_long(CONSTANT)
From: Peter Zijlstra <peterz@infradead.org>
To: Michal Marek <mmarek@suse.cz>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@amd64.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>,
       Borislav Petkov <petkovbb@googlemail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       LKML <linux-kernel@vger.kernel.org>, Jamie Lokier <jamie@shareable.org>,
       Roland Dreier <rdreier@cisco.com>, Al Viro <viro@ZenIV.linux.org.uk>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Brian Gerst <brgerst@gmail.com>
In-Reply-To: <4B7BF5D6.3030701@suse.cz>
References: <4B6C93A2.1090302@zytor.com> <20100206093659.GA28326@aftab>
	 <4B6E1DA3.50204@zytor.com> <20100208092845.GB12618@a1.tnic>
	 <4B6FDAED.9060204@zytor.com> <20100208095945.GA14740@a1.tnic>
	 <20100211172424.GB19779@aftab> <4B743F7D.3090605@zytor.com>
	 <20100212170649.GC3114@aftab> <4B758FC0.1020600@zytor.com>
	 <20100212174751.GD3114@aftab> <4B75A66A.70005@zytor.com>
	 <4B7BF5D6.3030701@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 18 Feb 2010 11:51:50 +0100
Message-ID: <1266490310.26719.185.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-02-17 at 14:57 +0100, Michal Marek wrote:
> On 12.2.2010 20:05, H. Peter Anvin wrote:
> > On 02/12/2010 09:47 AM, Borislav Petkov wrote:
> >>
> >> However, this is generic code and for the above to work we have to
> >> enforce x86-specific CFLAGS for it. What is the preferred way to do
> >> that?
> >>
> > 
> > That's a question for Michal and the kbuild list.  Michal?
> 
> (I was offline last week).
> 
> The _preferred_ way probably is not to do it :), but otherwise you can
> set CFLAGS_hweight.o depending on CONFIG_X86(_32|_64), just like you do
> in arch/x86/lib/Makefile already.

I guess one way to achieve that is to create a arch/x86/lib/hweight.c
that includes lib/hweight.c and give the x86 one special compile flags
and not build the lib on.

