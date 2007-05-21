Return-Path: <linux-kernel-owner+w=401wt.eu-S936088AbXEUT6b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936088AbXEUT6b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 15:58:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934665AbXEUTkq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 15:40:46 -0400
Received: from d06184ca.dreamhost.com ([208.97.132.202]:47441 "EHLO
	spaceymail-a4.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S934820AbXEUTko (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 15:40:44 -0400
From: Anant Nitya <kernel@prachanda.info>
Organization: Prachanda Hub
To: linux-kernel@vger.kernel.org
Subject: Re: bad networking related lag in v2.6.22-rc2
Date: Tue, 22 May 2007 01:10:13 +0530
User-Agent: KMail/1.9.6
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "David S. Miller" <davem@davemloft.net>
References: <20070517174533.GA538@elte.hu> <20070521080351.GA13375@elte.hu> <20070521081201.GB13858@elte.hu>
In-Reply-To: <20070521081201.GB13858@elte.hu>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200705220110.14175.kernel@prachanda.hub>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 21 May 2007 13:42:01 Ingo Molnar wrote:
> * Ingo Molnar <mingo@elte.hu> wrote:
> > > ouch! a nearly 1 second delay got observed by the scheduler - something
> > > is really killing your system!
> >
> > ah, you got the latency tracer from Thomas, as part of the -hrt patchset
> > - that makes it quite a bit easier to debug. [...]
>
> and ... you already did a trace for Thomas, for the softirq problem:
>
>    http://cybertek.info/taitai/trace.txt.bz2
>
> this trace shows really bad networking related kernel activities!
>
> gkrellm-5977 does this at timestamp 0:
>
>  gkrellm-5977  0..s.    0us : cond_resched_softirq (established_get_next)
>
> 2 milliseconds later it's still in established_get_next() (!):
>
>  gkrellm-5977  0..s. 2001us : cond_resched_softirq (established_get_next)
>
> and the whole thing takes ... 455 msecs:
>
>  gkrellm-5977  0..s. 455443us+: cond_resched_softirq (established_get_next)
>
> i think this suggests that you have tons of open sockets. What does
> "netstat -ts" say on your box?
I am posting links to the information you asked for. One more thing, after 
digging a bit more I found its QoS shaping that is making the box crawl. Once 
I disabled the traffic shaping everything comes back to smooth and normal. 
Shaping being done on very low speed residential ADSL 256/64 Kbps connection.
If you want me to post shaping rules, please free to ask. BTW its a simple 
HTB/SFQ rules.

http://cybertek.info/taitai/netstat-ts-before-crawl-normal-workload.txt
http://cybertek.info/taitai/netstat-ts-while-crawl-normal-workload.txt
http://cybertek.info/taitai/trace-to-ingo.txt.bz2

Regards
Ananitya
>
> 	Ingo



-- 
Out of many thousands, one may endeavor for perfection, and of
those who have achieved perfection, hardly one knows Me in truth.
				-- Gita Sutra Of Mysticism
