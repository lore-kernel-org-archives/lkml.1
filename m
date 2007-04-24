Return-Path: <linux-kernel-owner+w=401wt.eu-S1754559AbXDXC3a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559AbXDXC3a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 22:29:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754556AbXDXC33
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 22:29:29 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:46362 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754559AbXDXC33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 22:29:29 -0400
Date: Tue, 24 Apr 2007 11:29:53 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Cc: hugh@veritas.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: PageLRU can be non-atomic bit operation
Message-Id: <20070424112953.efa44e50.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <6.0.0.20.2.20070424100507.049670d0@172.19.0.2>
References: <6.0.0.20.2.20070423193641.0457f700@172.19.0.2>
	<Pine.LNX.4.64.0704231202390.29015@blonde.wat.veritas.com>
	<6.0.0.20.2.20070423210926.045668d0@172.19.0.2>
	<Pine.LNX.4.64.0704231438280.3516@blonde.wat.veritas.com>
	<6.0.0.20.2.20070424100507.049670d0@172.19.0.2>
Organization: Fujitsu
X-Mailer: Sylpheed version 2.2.0 (GTK+ 2.6.10; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Apr 2007 10:54:27 +0900
Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp> wrote:
> In the case that changing the same bit concurrently, lock prefix or other
> spinlock is needed. But, I think that concurrent bit operation on different 
> bits
> is just like OR operation , so lock prefix is not needed.
> 
> AMD instruction manual says about bts that ,
> 
> "Copies a bit, specified by bit index in a register or 8-bit immediate 
> value (second operand), from a bit
> string (first operand), also called the bit base, to the carry flag (CF) of 
> the rFLAGS register, and then
> sets the bit in the bit string to 1."
> 
> BTS instruction is read-modify-write instruction on bit unit. So concurrent 
> bit operation on different
> bits may be possible.
> 
This is ia64's __set_bit() hehe..
==
static __inline__ void
__set_bit (int nr, volatile void *addr)
{
        *((__u32 *) addr + (nr >> 5)) |= (1 << (nr & 31));
}
==

Bye.
-Kame

