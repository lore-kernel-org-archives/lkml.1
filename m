Return-Path: <linux-kernel-owner+w=401wt.eu-S1752792AbZE1WBC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752792AbZE1WBC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 18:01:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751515AbZE1WAy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 18:00:54 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36882 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751336AbZE1WAx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 18:00:53 -0400
Date: Fri, 29 May 2009 00:00:43 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
       Mike Galbraith <efault@gmx.de>, Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH tip 0/5] perf: make top share sym routines with report
Message-ID: <20090528220043.GA20964@elte.hu>
References: <20090528175451.GB4747@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090528175451.GB4747@ghostprotocols.net>
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


* Arnaldo Carvalho de Melo <acme@redhat.com> wrote:

> Haven't done and perf stat runs tho. Perhaps ask for running it 
> for 5 refreshes and then exit.

I've benchmarked it. With about half a million sample IRQs per 
second on a 16way x86 box the overhead went from 22.3%:

   PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME   COMMAND          
  4701 mingo     20   0  423m  61m 1796 R 22.3  0.5   0:08.11 perf             

down to:
         
   PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME   COMMAND          
  3386 mingo     20   0 88068  61m 1756 R 18.2  0.5   0:03.06 perf      

So it's a ~22% speedup.

Also, there's much less virtual memory used as well - a factor of 5 
reduction (!).

Applied and pushed out - thanks Arnaldo!

	Ingo
