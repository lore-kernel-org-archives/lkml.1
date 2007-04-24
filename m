Return-Path: <linux-kernel-owner+w=401wt.eu-S1030694AbXDXBy6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030694AbXDXBy6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 21:54:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031020AbXDXBy6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 21:54:58 -0400
Received: from serv1.oss.ntt.co.jp ([222.151.198.98]:44338 "EHLO
	serv1.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030694AbXDXBy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 21:54:57 -0400
Message-Id: <6.0.0.20.2.20070424100507.049670d0@172.19.0.2>
X-Mailer: QUALCOMM Windows Eudora Version 6J-Jr3
Date: Tue, 24 Apr 2007 10:54:27 +0900
To: Hugh Dickins <hugh@veritas.com>
From: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Subject: Re: [PATCH] mm: PageLRU can be non-atomic bit operation
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0704231438280.3516@blonde.wat.veritas.com>
References: <6.0.0.20.2.20070423193641.0457f700@172.19.0.2>
 <Pine.LNX.4.64.0704231202390.29015@blonde.wat.veritas.com>
 <6.0.0.20.2.20070423210926.045668d0@172.19.0.2>
 <Pine.LNX.4.64.0704231438280.3516@blonde.wat.veritas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


At 22:42 07/04/23, Hugh Dickins wrote:
 >On Mon, 23 Apr 2007, Hisashi Hifumi wrote:
 >> >No.  The PG_lru flag bit is just one bit amongst many others:
 >> >what of concurrent operations changing other bits in that same
 >> >unsigned long e.g. trying to lock the page by setting PG_locked?
 >> >There are some places where such micro-optimizations can be made
 >> >(typically while first allocating the page); but in general, no.
 >>
 >> In i386 and x86_64, btsl is used to change page flag. In this case, if btsl
 >> without lock prefix
 >> set PG_locked and PG_lru flag concurrently, does only one operation
 >> succeed ?
 >
 >That's right: on an SMP machine, without the lock prefix, the operation
 >is no longer atomic: what's stored back may be missing the result of
 >one or the other of the racing operations.
 >

In the case that changing the same bit concurrently, lock prefix or other
spinlock is needed. But, I think that concurrent bit operation on different 
bits
is just like OR operation , so lock prefix is not needed.

AMD instruction manual says about bts that ,

"Copies a bit, specified by bit index in a register or 8-bit immediate 
value (second operand), from a bit
string (first operand), also called the bit base, to the carry flag (CF) of 
the rFLAGS register, and then
sets the bit in the bit string to 1."

BTS instruction is read-modify-write instruction on bit unit. So concurrent 
bit operation on different
bits may be possible.

