Return-Path: <linux-kernel-owner+w=401wt.eu-S933583AbXCaDml@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933583AbXCaDml (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 23:42:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933589AbXCaDml
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 23:42:41 -0400
Received: from mail.gmx.net ([213.165.64.20]:49630 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S933583AbXCaDmk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 23:42:40 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19hh0Ikmt9hpz73/nO905Ua+4IAcneh0yiSIG8+O3
	mhL0ceL9vrG7bg
Subject: Re: [test] hackbench.c interactivity results: vanilla versus
	SD/RSDL
From: Mike Galbraith <efault@gmx.de>
To: Xenofon Antidides <xantidides@yahoo.gr>
Cc: Ingo Molnar <mingo@elte.hu>, Con Kolivas <kernel@kolivas.org>,
       linux list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1175311424.6927.6.camel@Homer.simpson.net>
References: <20070331023615.98478.qmail@web26704.mail.ukl.yahoo.com>
	 <1175311424.6927.6.camel@Homer.simpson.net>
Content-Type: text/plain
Date: Sat, 31 Mar 2007 05:42:37 +0200
Message-Id: <1175312557.6927.14.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-03-31 at 05:23 +0200, Mike Galbraith wrote:
> On Fri, 2007-03-30 at 19:36 -0700, Xenofon Antidides wrote:
> 
> > Something different on many cpus? Sorry I was thinking
> > something other. I try 50% run + 50% sleep on one cpu
> > and mainline has big problem. Sorry for bad code I
> > copy bits to make it work. Start program first then
> > run bash 100% cpu (while : ; do : ; done). Try change
> > program forks from 1 till 3 or more mainline kernel
> > and bash gets 0%.
> 
> top - 05:16:41 up 43 min, 13 users,  load average: 9.51, 4.32, 5.67
> 
>   PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  P COMMAND
>  7146 root      15   0  1564  104   24 R   43  0.0   0:20.74 0 fiftypercent
>  7142 root      15   0  1564  104   24 S   37  0.0   0:18.08 0 fiftypercent
>  7140 root      15   0  1564  436  356 R   21  0.0   0:18.94 1 fiftypercent
>  7144 root      15   0  1564  104   24 R   21  0.0   0:18.75 1 fiftypercent
>  7143 root      15   0  1564  104   24 R   20  0.0   0:18.85 1 fiftypercent
>  7145 root      15   0  1564  104   24 R   19  0.0   0:18.30 1 fiftypercent
>  7147 root      15   0  1564  104   24 R   19  0.0   0:18.03 1 fiftypercent
>  7141 root      16   0  1564  104   24 R   10  0.0   0:18.29 0 fiftypercent
>  6245 root      16   0  3368 1876 1376 R    7  0.2   0:49.81 0 bash
> 
> That's mainline with the below (which I'm trying various ideas to improve).

Note: that's not an sh -c started at the same time as the 50% duty cycle
dos, the pertinent data is that bash is getting into the loop.

Yesterday, I piddled around with tracking interactive backlog as a way
to detect when the load isn't really an interactive load, that's very
simple and has potential.

	-Mike

