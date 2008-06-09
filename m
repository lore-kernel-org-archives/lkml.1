Return-Path: <linux-kernel-owner+w=401wt.eu-S1758953AbYFIJHN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758953AbYFIJHN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 05:07:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757338AbYFIJHA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 05:07:00 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38935 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755823AbYFIJG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 05:06:59 -0400
Date: Mon, 9 Jun 2008 02:06:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [bug, 2.6.26-rc4/rc5] sporadic bootup crashes in
 blk_lookup_devt()/prepare_namespace()
Message-Id: <20080609020623.b6727f2b.akpm@linux-foundation.org>
In-Reply-To: <20080609080312.GA32458@elte.hu>
References: <20080609080312.GA32458@elte.hu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Jun 2008 10:03:12 +0200 Ingo Molnar <mingo@elte.hu> wrote:

> -tip testing has started triggering a new type of sporadic bootup crash 
> a few days ago. Find below a collection of 14 crashes i've managed to 
> capture so far, which are all similar to this crash pattern:
> 
>  BUG: unable to handle kernel paging request at ffff81003b984fb8
>  IP: [<ffffffff803fafd4>] blk_lookup_devt+0x42/0xa0
>  PGD 8063 PUD 9063 PMD 3be2d163 PTE 800000003b984160
>  Oops: 0000 [1] SMP DEBUG_PAGEALLOC
> 
>  Call Trace:
>   [<ffffffff80bac17b>] ? ip_auto_config+0x0/0xd94
>   [<ffffffff80209259>] name_to_dev_t+0x145/0xeec
>   [<ffffffff803ff2be>] ? __next_cpu_nr+0x22/0x2b
>   [<ffffffff80b7f372>] prepare_namespace+0x91/0x14c
>   [<ffffffff80b7eb70>] kernel_init+0x2fe/0x314
>   [<ffffffff80251f3d>] ? trace_hardirqs_on_caller+0xca/0xee
>   [<ffffffff80741bbb>] ? trace_hardirqs_on_thunk+0x3a/0x3f
>   [<ffffffff80251f3d>] ? trace_hardirqs_on_caller+0xca/0xee
>   [<ffffffff8020d3f8>] child_rip+0xa/0x12
>   [<ffffffff8020c90c>] ? restore_args+0x0/0x30
>   [<ffffffff8025068d>] ? trace_hardirqs_off+0xd/0xf
>   [<ffffffff80b7e872>] ? kernel_init+0x0/0x314
>   [<ffffffff8020d3ee>] ? child_rip+0x0/0x12

Did you work out where it's dying?  Deref of `dev' I assume?

