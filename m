Return-Path: <linux-kernel-owner+w=401wt.eu-S1764334AbYBTUFr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764334AbYBTUFr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 15:05:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757531AbYBTUFj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 15:05:39 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:38887 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755027AbYBTUFi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 15:05:38 -0500
Date: Wed, 20 Feb 2008 23:04:40 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Rik van Riel <riel@redhat.com>
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       roland@redhat.com, Andy Whitcroft <apw@shadowen.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [BUG] 2.6.25-rc2-mm1 - Kernel panic while bootup caused by signal_group_exit()
Message-ID: <20080220200440.GA105@tv-sign.ru>
References: <20080216002522.9c4bd0fb.akpm@linux-foundation.org> <47B7B3B9.2090706@linux.vnet.ibm.com> <20080220143417.6e419c5e@cuia.boston.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080220143417.6e419c5e@cuia.boston.redhat.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/20, Rik van Riel wrote:
>
> On Sun, 17 Feb 2008 09:40:33 +0530
> Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:
> 
> > [   25.512919] BUG: unable to handle kernel paging request at 9d74e37b
> > [   25.514926] IP: [<c04a8fac>] proc_flush_task+0x5b/0x223
> 
> I wonder if this one is related.   Also with 2.6.25-rc2-mm1 on x86_64:
> 
> BUG: unable to handle kernel paging request at 0000000000200200
> IP: [<ffffffff81043d3c>] free_pid+0x35/0x90
> ...
> Call Trace:
>  [<ffffffff81035a6d>] ? release_task+0x1be/0x346
>  [<ffffffff810362b7>] ? do_wait+0x6c2/0xa0e
>  [<ffffffff81051316>] ? trace_hardirqs_on_caller+0xf2/0x115
>  [<ffffffff8102ac72>] ? default_wake_function+0x0/0xe
>  [<ffffffff81051316>] ? trace_hardirqs_on_caller+0xf2/0x115
>  [<ffffffff8103668d>] ? sys_wait4+0x8a/0xa1
>  [<ffffffff8100be3b>] ? system_call_after_swapgs+0x7b/0x80

Yes, please look at http://marc.info/?t=120309840500006

Btw. The bug in tty_io.c _can_ explain this trace, but it would be nice
to ensure we don't have other problems. Could you try this

	http://marc.info/?l=linux-kernel&m=120352655031911

patch?

(I can't understand why this happens at the boot time, and it is not
 reproducable on my side).

Oleg.

