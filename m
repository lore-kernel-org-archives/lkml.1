Return-Path: <linux-kernel-owner+w=401wt.eu-S1758228AbZCZJKk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758228AbZCZJKk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 05:10:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752801AbZCZJK2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 05:10:28 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34607 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756380AbZCZJK1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 05:10:27 -0400
Date: Thu, 26 Mar 2009 10:09:39 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jan Kara <jack@suse.cz>, Oleg Nesterov <oleg@redhat.com>,
       Roland McGrath <roland@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Theodore Tso <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, David Rees <drees76@gmail.com>,
       Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: ext3 IO latency measurements (was: Linux 2.6.29)
Message-ID: <20090326090939.GA8993@elte.hu>
References: <20090324041249.1133efb6.akpm@linux-foundation.org> <20090325123744.GK23439@duck.suse.cz> <20090325150041.GM32307@mit.edu> <alpine.LFD.2.00.0903251008120.3032@localhost.localdomain> <20090325185824.GO32307@mit.edu> <alpine.LFD.2.00.0903251341050.3032@localhost.localdomain> <20090325215137.GQ32307@mit.edu> <alpine.LFD.2.00.0903251613300.3032@localhost.localdomain> <20090325235041.GA11024@duck.suse.cz> <20090326090630.GA9369@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090326090630.GA9369@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> Oh, and while at it - also a job control complaint. I tried to 
> Ctrl-C the above script:
> 
> file # 858 (253560 bytes), reading it took: 0.06 seconds.
> file # 859 (253560 bytes), reading it took: 0.02 seconds.
> file # 860 (253560 bytes), reading it took: 5.53 seconds.
> file # 861 (253560 bytes), reading it took: 3.70 seconds.
> file # 862 (253560 bytes), reading it took: 0.88 seconds.
> file # 863 (253560 bytes), reading it took: 0.04 seconds.
> file # 864 (253560 bytes), reading it took: ^C0.69 seconds.
> file # 865 (253560 bytes), reading it took: ^C0.49 seconds.
> file # 866 (253560 bytes), reading it took: ^C0.01 seconds.
> file # 867 (253560 bytes), reading it took: ^C0.02 seconds.
> file # 868 (253560 bytes), reading it took: ^C^C0.01 seconds.
> file # 869 (253560 bytes), reading it took: ^C^C0.04 seconds.
> file # 870 (253560 bytes), reading it took: ^C^C^C0.03 seconds.
> file # 871 (253560 bytes), reading it took: ^C0.02 seconds.
> file # 872 (253560 bytes), reading it took: ^C^C0.02 seconds.
> file # 873 (253560 bytes), reading it took: 
> ^C^C^C^Caldebaran:~/linux/linux/test-files/src> 
> 
> I had to hit Ctrl-C numerous times before Bash would honor it. 
> This to is a very common thing on large SMP systems. [...]

It happened when i tried to Ctrl-C the compile job as well:

Thu Mar 26 11:04:05 CET 2009
Thu Mar 26 11:06:30 CET 2009
^CThu Mar 26 11:07:55 CET 2009
^C^C^C^C^C^C^C^C^C^C^C^C^C^C^C^C^C^C^C^C^C^C^C^C^C^C^C^C^C^C^C^C^C^C^C^C^C^C^C^C^Caldebaran:/home/mingo/linux/linux> 

a single Ctrl-C is rarely enough to stop busy Bash shell scripts on 
Linux. Why?

	Ingo
