Return-Path: <linux-kernel-owner+w=401wt.eu-S1756407AbYFITPW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756407AbYFITPW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 15:15:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753580AbYFITPI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 15:15:08 -0400
Received: from orion.ambsoft.pl ([212.109.144.130]:41572 "EHLO
	orion.ambsoft.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753562AbYFITPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 15:15:07 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: balbir@linux.vnet.ibm.com
Subject: Re: 2.6.26-rc5-mm1
Date: Mon, 9 Jun 2008 21:14:54 +0200
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
References: <20080609053908.8021a635.akpm@linux-foundation.org> <484D67EF.5090203@linux.vnet.ibm.com>
In-Reply-To: <484D67EF.5090203@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200806092114.54467.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Balbir,

> Andrew Morton wrote:
> > Temporarily at
> > 
> >   http://userweb.kernel.org/~akpm/2.6.26-rc5-mm1/
> > 
> 
> I've hit a segfault, the last few lines on my console are
> 
> 
> Testing -fstack-protector-all feature
> registered taskstats version 1
> debug: unmapping init memory ffffffff80c03000..ffffffff80dd8000
> init[1]: segfault at 7fff701fe880 ip 7fff701fee5e sp 7fff7006e6d0 error 7
> 
> With absolutely no stack trace. I'll dig deeper.

Hey, I see something similar and I actually have a stack trace. Here it goes:

bash[498] segfault at ffffffff80868b58 ip ffffffffff600412 sp 7fffa3d010f0 error 7
init[1] segfault at ffffffff80868b58 ip ffffffffff600412 sp 7fff9e97f640 error 7
init[1] segfault at ffffffff80868b58 ip ffffffffff600412 sp 7fff9e97eed0 error 7
Kernel panic - not syncing: Attemted to kill init!
Pid 1, comm: init Not tainted 2.6.26-rc5-mm1 #1

Call Trace:
[<ffffffff80254632>] panic+0xe2/0x260
[<ffffffff802fa8ba>] ? __slab_free+0x10a/0x630
[<ffffffff80265a8e>] ? __sigqueue_free+0x5e/0x70
[<ffffffff802851eb>] ? trace_hardirqs_off+0x1b/0x30
[<ffffffff802851eb>] ? trace_hardirqs_off+0x1b/0x30
[<ffffffff80259b54>] do_exit+0xb84/0xc30
[<ffffffff80259c5a>] do_group_exit+0x5a/0x110
[<ffffffff8026a3b5>] get_signal_to_deliver+0x2c5/0x620
[<ffffffff8020bb3b>] do_notify_resume+0x11b/0xd10
[<ffffffff8028da5b>] ? trace_hardirqs_on+0x1b/0x30
[<ffffffff805cd0f3>] ? _spin_unlock_irqrestore+0x93/0x130
[<ffffffff8026865c>] ? force_sig_info+0x10c/0x130
[<ffffffff8022fb9c>] ? force_sig_info_fault+0x2c/0x40
[<ffffffff802dd7dd>] ? print_vma_addr+0x10d/0x1d0
[<ffffffff805cbb67>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[<ffffffff8028d8da>] ? trace_hardirqs_on_caller+0x15a/0x2c0
[<ffffffff8020d4c9>] retint_signal+0x46/0x8d

This was copied manually so typos are possible.

	Mariusz
