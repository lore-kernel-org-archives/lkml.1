Return-Path: <linux-kernel-owner+w=401wt.eu-S1752307AbZKPK1c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752307AbZKPK1c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 05:27:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752283AbZKPK1c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 05:27:32 -0500
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:18067 "EHLO
	TX2EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752251AbZKPK1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 05:27:31 -0500
X-SpamScore: -13
X-BigFish: VPS-13(zz1432R98dNzz1202hzzz32i6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KT76DE-01-40O-02
X-M-MSG: 
Date: Mon, 16 Nov 2009 11:27:14 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Pekka Enberg <penberg@cs.helsinki.fi>, Tejun Heo <tj@kernel.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linux-kernel@vger.kernel.org, chrisw@sous-sol.org, dwmw2@infradead.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Yinghai Lu <yinghai@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 07/10] bootmem: add free_bootmem_late
Message-ID: <20091116102714.GC3328@amd.com>
References: <1256712464-21472-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <1256712464-21472-8-git-send-email-fujita.tomonori@lab.ntt.co.jp>
 <20091028074832.GC19402@elte.hu>
 <4AE7FA12.2070905@kernel.org>
 <84144f020910280438j65bcacacq731f6076cbd8d99@mail.gmail.com>
 <4AE83541.3030306@kernel.org>
 <84144f020910290419k45a0c47fp500f5b5c390b80e2@mail.gmail.com>
 <20091108095719.GC2845@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20091108095719.GC2845@elte.hu>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 16 Nov 2009 10:27:15.0011 (UTC) FILETIME=[5DA47130:01CA66A7]
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 08, 2009 at 10:57:19AM +0100, Ingo Molnar wrote:

> Page tables is the main dependency. x86 boots with a limited set of page 
> tables, the real ones are set up later.
> 
> We'd need to see what bootmem allocations are done before page table 
> init in practice. I think i did such tests a few years ago and i think 
> it's rather limited (if it happens at all).
> 
> If that's mapped out we can just convert x86 to an 'emulated' bootmem 
> allocator: buddy and slab is set up right when pagetables are set up, 
> and bootmem can just use kmalloc.

That sounds like a good idea. But keep in mind that support for 1GB
pages currently depends on the bootmem allocator because the buddy
system can not allocate 1GB of physically contiguous memory.
But I think this could also be handled from x86 arch code without the
bootmem allocator.

	Joerg


