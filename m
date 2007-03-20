Return-Path: <linux-kernel-owner+w=401wt.eu-S1753341AbXCTHkv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753341AbXCTHkv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 03:40:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753342AbXCTHkv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 03:40:51 -0400
Received: from gw1.cosmosbay.com ([86.65.150.130]:58833 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753341AbXCTHku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 03:40:50 -0400
Message-ID: <45FF8FB2.3060601@cosmosbay.com>
Date: Tue, 20 Mar 2007 08:39:30 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: Andrew Morton <akpm@linux-foundation.org>, mpm@selenic.com,
       Christoph Lameter <clameter@sgi.com>, "ast@domdv.de" <ast@domdv.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] slab: deal with NULL pointers passed to kmem_cache_free
References: <20070319141038.212d4ac9.akpm@linux-foundation.org>	 <az5Ytbv5.1174339536.7416370.penberg@cs.helsinki.fi>	 <20070319144100.8a87f288.akpm@linux-foundation.org> <84144f020703200014j1ec8a6feq9828fd8739beff18@mail.gmail.com>
In-Reply-To: <84144f020703200014j1ec8a6feq9828fd8739beff18@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Tue, 20 Mar 2007 08:39:36 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka Enberg a écrit :
> On 3/19/07, Andrew Morton <akpm@linux-foundation.org> wrote:
>> This is a super-hot path.
> 
> Super-hot exactly where?

Don't be silly Pekka ... We have plenty oprofiles results if you dont trust 
Andrew.

CPU: AMD64 processors, speed 1992.52 MHz (estimated)
Counted CPU_CLK_UNHALTED events (Cycles outside of halt state) with a unit 
mask of 0x00 (No unit mask) count 100000
samples  %        symbol name
1861563   4.7882  tg3_start_xmit_dma_bug
1375727   3.5386  memcpy_c
1166438   3.0002  tcp_v4_rcv
1157334   2.9768  kmem_cache_free

In this workload (real server), you can see kmem_cache_free() is number four.

Adding one test and conditional branch in this super-hot function just to 
correct a bug in a SCSI driver (or whatever) is not *SANE*.


Numbers talk.
