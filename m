Return-Path: <linux-kernel-owner+w=401wt.eu-S935116AbXGaV7c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935116AbXGaV7c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 17:59:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764606AbXGaV7K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 17:59:10 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:54204 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762417AbXGaV7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 17:59:08 -0400
Date: Tue, 31 Jul 2007 15:02:45 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Zan Lynx <zlynx@acm.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.22-rc1-mm1 huge pages VM freeze (maybe?)
Message-Id: <20070731150245.5932b763.randy.dunlap@oracle.com>
In-Reply-To: <1185918261.6981.13.camel@localhost>
References: <1185918261.6981.13.camel@localhost>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Jul 2007 15:44:21 -0600 Zan Lynx wrote:

> I was playing with huge pages and libhugetlbfs.  Small programs like
> "ls" work fine.  I tried running Evolution through libhugetlbfs and the
> system slowly stops running.  One interesting thing is the "ps" command,
> it gets stuck like this:

Do you mean 2.6.22-rc1-mm1 or 2.6.23-rc1-mm1?

There was a hugepage problem fixed very recently, in 2.6.23-rc1 IIRC.


> ps            D ffff81001e57ed40     0 103558 103483
>  ffff81001f061dc8 0000000000000096 ffff81003d8586e8 ffff81001cbadc00
>  0000000000000006 ffffffff80537009 0000000000000030 ffffffff807ff700
>  ffffffff807ff700 ffffffff807ff700 ffffffff807ff700 ffffffff807ff700
> Call Trace:
>  [<ffffffff80537009>] _spin_unlock+0x29/0x50
>  [<ffffffff80536425>] __down_read+0x75/0xaf
>  [<ffffffff80295f49>] access_process_vm+0x49/0x190
>  [<ffffffff802f3003>] proc_pid_cmdline+0xa3/0x130
>  [<ffffffff802f4cea>] proc_info_read+0xba/0x100
>  [<ffffffff802b0085>] vfs_read+0xc5/0x180
>  [<ffffffff802b0583>] sys_read+0x53/0x90
>  [<ffffffff8020c1de>] system_call+0x7e/0x83
> 
> and nothing will touch it after that.
> 
> Here's my kernel command line:
> root=/dev/sda2 rootfstype=reiser4 rootflags=no_write_barrier ro
> i8042.nomux elevator=cfq resume=/dev/sda3 panic=5 nmi_watchdog=2,panic
> debug hugepages=32
> 
> Here's the "huge" script I was using to run programs:
> #!/bin/sh
> export LD_PRELOAD=libhugetlbfs.so
> export HUGETLB_MORECORE=yes
> export HUGETLB_PATH=/mnt/huge
> export HUGETLB_VERBOSE=1
> exec "$@"
> 
> I don't have any more info than that at the moment but I could reproduce
> it with whatever, on request.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
