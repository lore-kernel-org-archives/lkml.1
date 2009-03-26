Return-Path: <linux-kernel-owner+w=401wt.eu-S1759440AbZCZOu1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759440AbZCZOu1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 10:50:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759174AbZCZOtE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 10:49:04 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48670 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759150AbZCZOtD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 10:49:03 -0400
Date: Thu, 26 Mar 2009 07:38:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jan Kara <jack@suse.cz>, Linus Torvalds <torvalds@linux-foundation.org>,
       Theodore Tso <tytso@mit.edu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, David Rees <drees76@gmail.com>,
       Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>
Subject: Re: ext3 IO latency measurements (was: Linux 2.6.29)
Message-Id: <20090326073851.fcee79dd.akpm@linux-foundation.org>
In-Reply-To: <20090326090630.GA9369@elte.hu>
References: <20090324103111.GA26691@elte.hu>
	<20090324041249.1133efb6.akpm@linux-foundation.org>
	<20090325123744.GK23439@duck.suse.cz>
	<20090325150041.GM32307@mit.edu>
	<alpine.LFD.2.00.0903251008120.3032@localhost.localdomain>
	<20090325185824.GO32307@mit.edu>
	<alpine.LFD.2.00.0903251341050.3032@localhost.localdomain>
	<20090325215137.GQ32307@mit.edu>
	<alpine.LFD.2.00.0903251613300.3032@localhost.localdomain>
	<20090325235041.GA11024@duck.suse.cz>
	<20090326090630.GA9369@elte.hu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Mar 2009 10:06:30 +0100 Ingo Molnar <mingo@elte.hu> wrote:

> And it's not just sys_fsync(). The script i wrote tests file read 
> latencies. I have created 1000 files with the same size (all copies 
> of kernel/sched.c ;-), and tested their cache-cold plain-cat 
> performance via:
> 
>   for ((i=0;i<1000;i++)); do
>     printf "file #%4d, plain reading it took: " $i
>     /usr/bin/time -f "%e seconds."  cat $i >/dev/null
>   done
> 
> I.e. plain, supposedly high-prio reads. The result is very common 
> hickups in read latencies:
> 
> file # 579 (253560 bytes), reading it took: 0.08 seconds.
> file # 580 (253560 bytes), reading it took: 0.05 seconds.
> file # 581 (253560 bytes), reading it took: 0.01 seconds.
> file # 582 (253560 bytes), reading it took: 0.01 seconds.
> file # 583 (253560 bytes), reading it took: 4.61 seconds.
> file # 584 (253560 bytes), reading it took: 1.29 seconds.
> file # 585 (253560 bytes), reading it took: 3.01 seconds.
> file # 586 (253560 bytes), reading it took: 7.74 seconds.
> file # 587 (253560 bytes), reading it took: 3.22 seconds.
> file # 588 (253560 bytes), reading it took: 0.05 seconds.
> file # 589 (253560 bytes), reading it took: 0.36 seconds.
> file # 590 (253560 bytes), reading it took: 7.39 seconds.
> file # 591 (253560 bytes), reading it took: 7.58 seconds.
> file # 592 (253560 bytes), reading it took: 7.90 seconds.
> file # 593 (253560 bytes), reading it took: 8.78 seconds.
> file # 594 (253560 bytes), reading it took: 8.01 seconds.
> file # 595 (253560 bytes), reading it took: 7.47 seconds.
> file # 596 (253560 bytes), reading it took: 11.52 seconds.
> file # 597 (253560 bytes), reading it took: 10.33 seconds.
> file # 598 (253560 bytes), reading it took: 8.56 seconds.
> file # 599 (253560 bytes), reading it took: 7.58 seconds.

(gets deja-vu feelings)

http://lkml.org/lkml/2003/2/21/10

Maybe you should be running a 2.5.61 kernel.
