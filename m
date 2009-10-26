Return-Path: <linux-kernel-owner+w=401wt.eu-S1753394AbZJZQFL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753394AbZJZQFL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 12:05:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752945AbZJZQFK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 12:05:10 -0400
Received: from tomts43.bellnexxia.net ([209.226.175.110]:62704 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751992AbZJZQFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 12:05:09 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtoEAE5l5UpGGN1W/2dsb2JhbACBUNZlhD8E
Date: Mon, 26 Oct 2009 12:05:09 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Pierre-Marc Fournier <pierre-marc.fournier@polymtl.ca>,
       Ingo Molnar <mingo@elte.hu>, GeunSik Lim <leemgs1@gmail.com>,
       Zhaolei <zhaolei@cn.fujitsu.com>, Wu Fengguang <fengguang.wu@intel.com>,
       Jesper Juhl <jj@chaosbits.net>, Adrian Bunk <bunk@stusta.de>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       "Robert P. J. Day" <rpjday@mindspring.com>,
       Jaswinder Singh Rajput <jaswinderrajput@gmail.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org,
       Dominique Toupin <dominique.toupin@ericsson.com>,
       Michel Dagenais <michel.dagenais@polymtl.ca>
Subject: Re: Relicensing tracepoints and markers to Dual LGPL v2.1/GPL
	v2,headers to Dual BSD/GPL
Message-ID: <20091026160509.GA8755@Krystal>
References: <20091023160257.GA30447@Krystal> <20091023160632.GA2198@Krystal> <alpine.LNX.2.00.0910242300510.16628@swampdragon.chaosbits.net> <20091026015357.GA6033@localhost> <023001ca55e1$436e38e0$808410ac@zhaoleiwin> <49b7c2350910252203o69811000w4551c01e6e2a10c7@mail.gmail.com> <20091026073048.GC8162@elte.hu> <4AE5A17D.5020202@polymtl.ca> <20091026071832.36405c9a@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20091026071832.36405c9a@infradead.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 11:59:07 up 69 days,  2:48,  2 users,  load average: 0.09, 0.14,
	0.10
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Arjan van de Ven (arjan@infradead.org) wrote:
> On Mon, 26 Oct 2009 09:17:49 -0400
> Pierre-Marc Fournier <pierre-marc.fournier@polymtl.ca> wrote:
> 
> > Ingo Molnar wrote:
> > > 
> > > But i also disagree with it on a technical level: code duplication
> > > is _bad_. Why does the code have to be duplicated in user-space
> > > like that? I'd like Linux tracing code to be in the kernel repo.
> > > Why isnt this done properly, as part of the kernel project - to
> > > make sure it all stays in sync?
> > > 
> > 
> > If you mean that this code should solely be used inside the kernel,
> > then what you propose technically does not work. There is a very high
> > cost to accessing kernel code from userspace. 
> 
> yeah 100 cycles is insanely high, that's at least the equivalent of...
> say one cache miss.
> 

Hi Arjan,

Maybe it's just me, but if you are talking of system calls performed
with sysenter, my own machine (with an Intel Xeon E5405 CPU) seems to
disagree with your estimations:

For a system call doing basically _nothing_:

Cache-cold system call:
Time for a system call (returns after a simple test) :
TSC diff : 6426 cycles
time diff : 3212.53 ns

Cache-hot system call:
Time for system call (10000 calls) (returns after a simple test) :
TSC diff : 599.893 cycles per call
time diff : 299.903 ns per call

Otherwise, if you are instead referring to a vDSO, then the contexts is
slightly different, and it becomes cheaper, but it does not allow to
share code as much between the in-kernel and vDSO implementations,
mainly due to different locking required. Moreover, I wonder about the
maximum vDSO size that can be ported across multiple architectures. It
has only been used for really tiny pieces of code so far.

Thanks,

Mathieu

> 
> -- 
> Arjan van de Ven 	Intel Open Source Technology Centre
> For development, discussion and tips for power savings, 
> visit http://www.lesswatts.org

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
