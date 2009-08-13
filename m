Return-Path: <linux-kernel-owner+w=401wt.eu-S1752040AbZHMJhH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752040AbZHMJhH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 05:37:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751319AbZHMJhH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 05:37:07 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46669 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751312AbZHMJhG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 05:37:06 -0400
Date: Thu, 13 Aug 2009 11:36:48 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>, paulus@samba.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PROBLEM] perf report is broken in latest linus git
Message-ID: <20090813093648.GA22762@elte.hu>
References: <1250155708.6052.2.camel@penberg-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1250155708.6052.2.camel@penberg-laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Pekka Enberg <penberg@cs.helsinki.fi> wrote:

> Latest Linus git kernel with -rc4 perf userspace:
> 
>   penberg@penberg-laptop:~/testing/jato$ perf record -f jato HelloWorldSwing
>   [ perf record: Captured and wrote 1.402 MB perf.data (~61261 samples) ]
> 
>   penberg@penberg-laptop:~/testing/jato$ perf report --sort comm,dso,symbol|head -30
>   # Samples: 60457
>   #
>   # Overhead  Command                            Shared Object  Symbol
>   # ........  .......  .......................................  ......
>   #
> 
>   [ Note: the jato executable doesn't appear anywhere in the trace. I'm
>     pretty sure the libzip functions, for example, are from jato, not perf.  ]
> 
>       36.14%     perf  /home/penberg/bin/perf                   [.] dso__synthesize_plt_symbols
>       35.20%     perf  /home/penberg/bin/perf                   [.] dso__new
>        3.57%     perf  /home/penberg/bin/jato                   [.] 0x0000000000c910

Perhaps it's this commit:

4d1e00a: perf symbol: Fix symbol parsing in certain cases: use the build-id as a symlink

it does not revert cleanly, so you might want to check out these two 
commits:

  4d1e00a
  4d1e00a~1

and build perf on both, and check with your anomalous perf.data 
(without changing it) whether the output makes most sense.

	Ingo
