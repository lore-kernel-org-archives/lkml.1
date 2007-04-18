Return-Path: <linux-kernel-owner+w=401wt.eu-S1751473AbXDRJGj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751473AbXDRJGj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 05:06:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751366AbXDRJGj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 05:06:39 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38044 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751473AbXDRJGi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 05:06:38 -0400
Date: Wed, 18 Apr 2007 11:06:06 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Pfister <christophpfister@gmail.com>
Cc: =?utf-8?B?Uy7Dh2HEn2xhcg==?= Onur <caglar@pardus.org.tr>,
       linux-kernel@vger.kernel.org, Michael Lothian <mike@fireburn.co.uk>,
       Christophe Thommeret <hftom@free.fr>, Jurgen Kofler <kaffeine@gmx.net>,
       Ulrich Drepper <drepper@redhat.com>
Subject: Re: Kaffeine problem with CFS
Message-ID: <20070418090606.GA21741@elte.hu>
References: <20070413202100.GA9957@elte.hu> <200704141809.58737.caglar@pardus.org.tr> <20070414160939.GB3099@elte.hu> <200704141959.50076.caglar@pardus.org.tr> <20070415161348.GA30625@elte.hu> <20070415162508.GA4526@elte.hu> <19a3b7a80704150955x4e1d809eh929b0f931f842a06@mail.gmail.com> <20070418082744.GA14009@elte.hu> <20070418085752.GA16233@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070418085752.GA16233@elte.hu>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> these were only the threads that showed up in htop. Here's a full 
> analysis about what all threads are doing:
> 
>  Process 9303: stuck in xine_play()/pthread_mutex_lock()
>  Process 9319:  stuck in pthread_cond_timedwait()
>  Process 9320:  stuck in pthread_cond_timedwait()
>  Process 9321: loop of ~3 msec nanosleeps
>  Process 9322: loop of poll() calls every 335 msecs
>  Process 9323:  stuck in pthread_cond_timedwait()
>  Process 9324: stuck in a loop of 1-second futex-waits + mmap/munmap (malloc)
>  Process 9325:  stuck in pthread_cond_timedwait()
>  Process 9326:  stuck in pthread_cond_timedwait()
>  Process 9327:  stuck in pthread_cond_timedwait()

and here's a top snapshot:

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
 9324 mingo     20   0  300m  59m  17m R 96.4  6.8  21:00.55 kaffeine
 9325 mingo     20   0  300m  59m  17m S  2.0  6.8   0:15.57 kaffeine
 9327 mingo     20   0  300m  59m  17m S  2.0  6.8   0:20.10 kaffeine

so 9324 doing the mpeg decoding seems to be stuck somehow?

	Ingo
