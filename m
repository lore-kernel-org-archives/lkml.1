Return-Path: <linux-kernel-owner+w=401wt.eu-S1754309AbYGMKrV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754309AbYGMKrV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 06:47:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752242AbYGMKqx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 06:46:53 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:43724 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751999AbYGMKqw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 06:46:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=qNTI1V8jb2MceemRHfHtCFdOjMPTAtMOLSLU6smSZkbuglRP+sc1MpmsgDdBnUmRAM
         wc8QC+PDv7nDkZI0yrEZaeVzK1+WIFVmFkHm9w9rHDtkpVQwX/UJcnyAlQ8faDo0LpNX
         UJ1HEySiDC5PcU1ZYtlaylk+4vKeAJBWL3t70=
Message-ID: <19f34abd0807130346p58872bado5d7217fe85e74c1f@mail.gmail.com>
Date: Sun, 13 Jul 2008 12:46:51 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: per-cpu related?
Cc: "Yinghai Lu" <yhlu.kernel@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       "Mike Travis" <travis@sgi.com>
In-Reply-To: <20080713092613.GB12749@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <86802c440807130116u3b850485jec220bc15892873e@mail.gmail.com>
	 <20080713092613.GB12749@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 13, 2008 at 11:26 AM, Ingo Molnar <mingo@elte.hu> wrote:
> [    9.270000] BUG: unable to handle kernel paging request at ffff88080101c1f8
> [    9.270000] IP: [<ffffffff80230576>] dequeue_task+0x73/0xf0

[...]

> [    9.270000] RIP: 0010:[<ffffffff80230576>]  [<ffffffff80230576>] dequeue_task+0x73/0xf0
> [    9.270000] RSP: 0018:ffff88003f9b7420  EFLAGS: 00010046
> [    9.270000] RAX: ffff88000101c200 RBX: ffff88003f9b4000 RCX: ffffffff80db5d40
> [    9.270000] RDX: 00000000ffffffff RSI: ffff88003f9b6000 RDI: ffff880001026d40

I don't think this is per-cpu related.

It seems that task_thread_info(p)->cpu returns -1. This is the number
that is loaded into %rdx:

mov    0x1c(%rsi),%edx
mov    (%rax,%rdx,8),%rax <-- faulting instruction

You also had this:

[    9.270000] Thread overran stack, or stack corrupted

so it seems likely that your thread_info was corrupted as well.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
