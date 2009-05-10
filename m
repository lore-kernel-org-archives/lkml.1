Return-Path: <linux-kernel-owner+w=401wt.eu-S1753087AbZEJGXU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753087AbZEJGXU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 02:23:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751510AbZEJGXI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 02:23:08 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40351 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751297AbZEJGXH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 02:23:07 -0400
Date: Sun, 10 May 2009 08:22:52 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Erdem Aktas <eaktas1@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: perf_counter: buffer overwrite problem for perf top command
Message-ID: <20090510062252.GB30778@elte.hu>
References: <3fee128b0905092313x608e65e0l7b1116d86914114f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3fee128b0905092313x608e65e0l7b1116d86914114f@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Erdem Aktas <eaktas1@gmail.com> wrote:

> Hi;
> There is a buffer overwrite problem in builtin-top.c line 526, When I
> tried to use ./perf top command, it was giving memory corruption
> problem. should not we use malloc(strlen(str)+1) ?

indeed, well spotted - we do an strcpy into that buffer so the \0 at 
the end of the string has to be allocated too.

I've applied it to tip:perfcounters/core and tip/master and pushed 
it out. Thanks,

	Ingo
