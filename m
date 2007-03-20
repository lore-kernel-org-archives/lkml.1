Return-Path: <linux-kernel-owner+w=401wt.eu-S932290AbXCTHrt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932290AbXCTHrt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 03:47:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932310AbXCTHrt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 03:47:49 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:32870 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932290AbXCTHrs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 03:47:48 -0400
Date: Tue, 20 Mar 2007 09:47:46 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Eric Dumazet <dada1@cosmosbay.com>
cc: Andrew Morton <akpm@linux-foundation.org>, mpm@selenic.com,
       Christoph Lameter <clameter@sgi.com>, "ast@domdv.de" <ast@domdv.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] slab: deal with NULL pointers passed to kmem_cache_free
In-Reply-To: <45FF8FB2.3060601@cosmosbay.com>
Message-ID: <Pine.LNX.4.64.0703200943430.3622@sbz-30.cs.Helsinki.FI>
References: <20070319141038.212d4ac9.akpm@linux-foundation.org> 
 <az5Ytbv5.1174339536.7416370.penberg@cs.helsinki.fi> 
 <20070319144100.8a87f288.akpm@linux-foundation.org>
 <84144f020703200014j1ec8a6feq9828fd8739beff18@mail.gmail.com>
 <45FF8FB2.3060601@cosmosbay.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/19/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> > > This is a super-hot path.

At some point in time, I wrote:
> > Super-hot exactly where?

On Tue, 20 Mar 2007, Eric Dumazet wrote:
> Don't be silly Pekka ... We have plenty oprofiles results if you dont trust
> Andrew.

Oh, don't get me wrong, this has certainly nothing to do with "not 
trusting" Andrew. It's just that "this is a super-hot path" doesn't really 
help me understand where kmem_cache_free() is so performance sensitive at 
all.

On Tue, 20 Mar 2007, Eric Dumazet wrote:
> CPU: AMD64 processors, speed 1992.52 MHz (estimated)
> Counted CPU_CLK_UNHALTED events (Cycles outside of halt state) with a unit
> mask of 0x00 (No unit mask) count 100000
> samples  %        symbol name
> 1861563   4.7882  tg3_start_xmit_dma_bug
> 1375727   3.5386  memcpy_c
> 1166438   3.0002  tcp_v4_rcv
> 1157334   2.9768  kmem_cache_free
> 
> In this workload (real server), you can see kmem_cache_free() is number four.

Thanks for the profile. I still wonder where exactly thouse super-hot 
call-sites are...

On Tue, 20 Mar 2007, Eric Dumazet wrote:
> Adding one test and conditional branch in this super-hot function just to
> correct a bug in a SCSI driver (or whatever) is not *SANE*.

Agreed. Unless we can get kmem_cache_free() out of those hot paths, of 
course =).

				Pekka
