Return-Path: <linux-kernel-owner+w=401wt.eu-S938690AbZDJHgl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938690AbZDJHgl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 03:36:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939073AbZDJHeH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 03:34:07 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:54469 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S939065AbZDJHeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 03:34:05 -0400
Date: Fri, 10 Apr 2009 09:34:50 +0200
From: Heinz Diehl <htd@fancy-poultry.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jan Kara <jack@suse.cz>, Linus Torvalds <torvalds@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, "Theodore Ts'o" <tytso@mit.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>
Subject: Re: updated: ext3 IO latency measurements on v2.6.30-rc1
Message-ID: <20090410073450.GA6505@fancy-poultry.org>
References: <20090325123744.GK23439@duck.suse.cz> <20090325150041.GM32307@mit.edu> <alpine.LFD.2.00.0903251008120.3032@localhost.localdomain> <20090325185824.GO32307@mit.edu> <alpine.LFD.2.00.0903251341050.3032@localhost.localdomain> <20090325215137.GQ32307@mit.edu> <alpine.LFD.2.00.0903251613300.3032@localhost.localdomain> <20090325235041.GA11024@duck.suse.cz> <20090326090630.GA9369@elte.hu> <20090409215946.GA28183@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090409215946.GA28183@elte.hu>
Organization: private site
User-Agent: Mutt/1.5.19+20090405 (GNU/Linux)
X-Provags-ID: V01U2FsdGVkX1/iOPZqJp4EhKtC1Y+IjbbPHy60xJSa8tWAIDK
 i/it0cJ2ABWx8+lUJ06b2Uj6JF6+unC7ONy0do8dUUlr+ry9vi
 OAbX28FzuyZ5P3yqmu5VaqNB33aw1IE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10.04.2009, Ingo Molnar wrote: 

> This is an update to the ext3+CFQ latency measurements i did early 
> in the merge window - originally with a v2.6.29 based kernel.
> 
> Today i've repeated my measurements under v2.6.30-rc1, using the 
> exact same system and the exact same workload.
> 
> The quick executive summary:
> 
>    _what a difference a week of upstream development makes_!

Here's a quicktest with xfs+CFQ on one of my testing machines, 
using fsync-tester while running Linus' "bigfile torture test". 
It underlines your results, showing significant improvement!

The xfs partition is mounted with the defaults, and I'm expecting 
slightly more improvement after mounting with noatime and nobarrier.

2.6.30-rc1

fsync time: 0.4674
fsync time: 1.0473
fsync time: 0.4190
fsync time: 1.0800
fsync time: 1.0132
fsync time: 1.0193
fsync time: 1.0191
fsync time: 1.1318
fsync time: 0.9924
fsync time: 1.0568
fsync time: 1.0676
fsync time: 1.0241
fsync time: 1.0530
fsync time: 0.9709
fsync time: 0.4475
fsync time: 0.6320
fsync time: 1.0906
fsync time: 0.6344
fsync time: 1.0632
fsync time: 1.0455
fsync time: 1.0530
fsync time: 1.0655
fsync time: 1.0032
fsync time: 1.0644
fsync time: 1.1573
fsync time: 1.0197
fsync time: 1.0342
fsync time: 1.0643
fsync time: 0.0342
fsync time: 0.7603
fsync time: 1.0905
fsync time: 0.6340

2.6.29.1

fsync time: 2.1255
fsync time: 2.2851
fsync time: 1.9048
fsync time: 1.0999
fsync time: 2.0117
fsync time: 2.0819
fsync time: 2.0819
fsync time: 0.0225
fsync time: 0.2796
fsync time: 0.3879
fsync time: 0.6584
fsync time: 0.9287
fsync time: 0.2488
fsync time: 2.0994
fsync time: 2.0161
fsync time: 1.9736
fsync time: 2.0231
fsync time: 2.2888
fsync time: 2.1719
fsync time: 1.8452
fsync time: 0.3278
fsync time: 1.0881
fsync time: 0.5202
fsync time: 1.3339
fsync time: 0.4295
fsync time: 1.2772
fsync time: 1.9436
fsync time: 2.1048
fsync time: 1.9376
fsync time: 2.0786
fsync time: 1.9202

