Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755102Ab0BXBYR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 20:24:17 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:36274 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752165Ab0BXBYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 20:24:16 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 24 Feb 2010 10:20:37 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alan Jenkins <sourcejedi.lkml@googlemail.com>, Mel Gorman <mel@csn.ul.ie>,
       hugh.dickins@tiscali.co.uk, Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Linux MM <linux-mm@kvack.org>
Subject: Re: s2disk hang update
Message-Id: <20100224102037.2cca4f83.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <201002232213.56455.rjw@sisk.pl>
References: <9b2b86521001020703v23152d0cy3ba2c08df88c0a79@mail.gmail.com>
	<201002222017.55588.rjw@sisk.pl>
	<9b2b86521002230624g20661564mc35093ee0423ff77@mail.gmail.com>
	<201002232213.56455.rjw@sisk.pl>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Feb 2010 22:13:56 +0100
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> Well, it still looks like we're waiting for create_workqueue_thread() to
> return, which probably is trying to allocate memory for the thread
> structure.
> 
> My guess is that the preallocated memory pages freed by
> free_unnecessary_pages() go into a place from where they cannot be taken for
> subsequent NOIO allocations.  I have no idea why that happens though.
> 
> To test that theory you can try to change GFP_IOFS to GFP_KERNEL in the
> calls to clear_gfp_allowed_mask() in kernel/power/hibernate.c (and in
> kernel/power/suspend.c for completness).
> 

If allocation of kernel threads for stop_machine_run() is the problem,

What happens when
1. use CONIFG_4KSTACK
or
2. make use of stop_machine_create(), stop_machine_destroy().
   A new interface added by this commit.
  http://git.kernel.org/?p=linux/kernel/git/torvalds/  linux-2.6.git;a=commit;h=9ea09af3bd3090e8349ca2899ca2011bd94cda85
   You can do no-fail stop_machine_run().

Thanks,
-Kame

