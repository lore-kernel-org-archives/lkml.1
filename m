Return-Path: <linux-kernel-owner+w=401wt.eu-S1755124AbYGMRqu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755124AbYGMRqu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 13:46:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753293AbYGMRqm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 13:46:42 -0400
Received: from gw.goop.org ([64.81.55.164]:48855 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752960AbYGMRqm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 13:46:42 -0400
Message-ID: <487A3F75.5010405@goop.org>
Date: Sun, 13 Jul 2008 10:46:29 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: "Jakub W. Jozwicki" <jozwicki@aster.pl>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, tglx@timesys.com
Subject: Re: [PATCH 2.6.25.10 1/2] libata: fix locking for kmap_atomic
References: <200807130127.36706.jozwicki@aster.pl> <20080713012630.d5e522f7.akpm@linux-foundation.org> <200807131517.51795.jozwicki@aster.pl>
In-Reply-To: <200807131517.51795.jozwicki@aster.pl>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jakub W. Jozwicki wrote:
>
> Sorry, this was for -rt only.
>
> [   17.012011] BUG: sleeping function called from invalid context IRQ-14(5732) 
> at arch/x86/mm/highmem_32.c:8
> [   17.012011] in_atomic():0 [00000000], irqs_disabled():1
> [   17.012011] Pid: 5732, comm: IRQ-14 Not tainted 2.6.25.10-rtXXX #11
> [   17.012011]  [<c0120fc4>] __might_sleep+0xf1/0xf8
> [   17.012011]  [<c011c035>] kmap+0x47/0x5a
>   

The subject says kmap_atomic, but this is kmap.  It definitely makes no 
sense to call kmap in an IRQ, regardless of the locking.  There seems to 
be a larger structural problem here.

> [   17.012011]  [<c033e728>] ata_hsm_move+0x3d7/0x657
> [   17.012011]  [<c0342fd6>] ata_interrupt+0x14e/0x1cb
> [   17.012011]  [<c015c72c>] handle_IRQ_event+0x4e/0xd1
> [   17.012011]  [<c015d266>] do_irqd+0x126/0x224
> [   17.012011]  [<c015d140>] ? do_irqd+0x0/0x224
> [   17.012011]  [<c013ae9d>] kthread+0x3b/0x62
> [   17.012011]  [<c013ae62>] ? kthread+0x0/0x62
> [   17.012011]  [<c0108287>] kernel_thread_helper+0x7/0x10
> [   17.012011]  =======================
>   

    J
