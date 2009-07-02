Return-Path: <linux-kernel-owner+w=401wt.eu-S1753294AbZGBHoe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753294AbZGBHoe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 03:44:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751312AbZGBHo1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 03:44:27 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57662 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751225AbZGBHo0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 03:44:26 -0400
Date: Thu, 2 Jul 2009 09:44:19 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Kevin Winchester <kjwinchester@gmail.com>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: tools/perf compile error: ignoring return value of 'read',
	declared with attribute warn_unused_result
Message-ID: <20090702074419.GB19187@elte.hu>
References: <4A4BF4A2.8030607@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A4BF4A2.8030607@gmail.com>
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


* Kevin Winchester <kjwinchester@gmail.com> wrote:

>     CC builtin-stat.o
> cc1: warnings being treated as errors
> builtin-stat.c: In function 'run_perf_stat':
> builtin-stat.c:243: error: ignoring return value of 'read', declared with attribute warn_unused_result
> builtin-stat.c:256: error: ignoring return value of 'read', declared with attribute warn_unused_result
> make: *** [builtin-stat.o] Error 1
> 
> Apparently my version of gcc and/or glibc do not agree with -Werror.  Would the fix be as simple as:
> 
>     if *read(go_pipe[0], &buf, 1) < 0) {
>             perror("Failed to read go_pipe.");
>             exit(1);
>     }
> 
> ?

Yeah, that's Ubuntu doing some must-check-warnings via headers, 
right?

Frederic fixed a bug there yesterday - mind checking the latest 
perfcounters code at:

  http://people.redhat.com/mingo/tip.git/README

?

Thanks,

	Ingo
