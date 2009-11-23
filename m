Return-Path: <linux-kernel-owner+w=401wt.eu-S1752895AbZKWRic@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752895AbZKWRic (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 12:38:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752122AbZKWRib
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 12:38:31 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:38639 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751833AbZKWRia (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 12:38:30 -0500
Date: Mon, 23 Nov 2009 18:38:17 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Prasad <prasad@linux.vnet.ibm.com>
Subject: Re: [PATCH 4/4] perf tools: Add support for breakpoint events in
 perf tools
Message-ID: <20091123173817.GA23765@elte.hu>
References: <1258987355-8751-1-git-send-email-fweisbec@gmail.com>
 <1258987355-8751-4-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1258987355-8751-4-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> Add the breakpoint events support with this new sysnopsis:
> 
> mem:addr[:access]
> 
> Where addr is a raw addr value in the kernel and access can be
> either [r][w][x]
> 
> Example to profile tasklist_lock:
> 
> 	$ grep tasklist_lock /proc/kallsyms
> 	ffffffff8189c000 D tasklist_lock
> 
> 	$ perf record -e mem:0xffffffff8189c000:rw -a -f -c 1

would be nice to also accept a plain cut & paste of an address in hexa 
without the 0x prefix, i.e.:
 	$ perf record -e mem:ffffffff8189c000:rw -a -f -c 1

plus perf stat gets surprised by this new event and prints 'unknown':

 $ grep tasklist_lock /proc/kallsyms 
 ffffffff81802000 D tasklist_lock
 $ perf stat -a -e mem:0xffffffff81802000 sleep 1

 Performance counter stats for 'sleep 1':

             64  unknown                 

    1.000833173  seconds time elapsed

	Ingo
