Return-Path: <linux-kernel-owner+w=401wt.eu-S932463AbXBWRnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932463AbXBWRnU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 12:43:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932472AbXBWRnU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 12:43:20 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:1192 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932463AbXBWRnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 12:43:19 -0500
X-AuthUser: davidel@xmailserver.org
Date: Fri, 23 Feb 2007 09:43:14 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
cc: Ingo Molnar <mingo@elte.hu>, Ulrich Drepper <drepper@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Zach Brown <zach.brown@oracle.com>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
In-Reply-To: <20070223121521.GA5392@2ka.mipt.ru>
Message-ID: <Pine.LNX.4.64.0702230935440.30937@alien.or.mcafeemobile.com>
References: <20070221211355.GA7302@elte.hu> <f2b55d220702211446l78af6f14hc3e0dd0084016770@mail.gmail.com>
 <20070221233111.GB5895@elte.hu> <45DCD9E5.2010106@redhat.com>
 <20070222074044.GA4158@elte.hu> <20070222113148.GA3781@2ka.mipt.ru>
 <20070222125931.GB25788@elte.hu> <20070222133201.GB5208@2ka.mipt.ru>
 <Pine.LNX.4.64.0702221139320.1356@alien.or.mcafeemobile.com>
 <20070223121521.GA5392@2ka.mipt.ru>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Feb 2007, Evgeniy Polyakov wrote:

> On Thu, Feb 22, 2007 at 11:46:48AM -0800, Davide Libenzi (davidel@xmailserver.org) wrote:
> > 
> > A dynamic pool will smooth thread creation/freeing up by a lot.
> > And, in my box a *pthread* create/free takes ~10us, at 1000/s is 10ms, 1%. 
> > Bad, but not so aweful ;)
> > Look, I'm *definitely* not trying to advocate the use of async syscalls for 
> > network here, just pointing out that when we're talking about threads, 
> > Linux does a pretty good job.
>  
> If we are going to create 1000 threads each second, then it is better to
> preallocate them and queue a work to that pool - like syslets did with
> syscalls, but not ulitimately create a new thread just because it is not 
> that slow.

We do create a pool indeed, as I said in the opening of my asnwer. The 
numbers I posted was just to show that thread creation/destroy is pretty 
fast, but that does not justify it as a design choice.



> All such micro-thread designs are especially good in the case when 
> 1. switching is _rare_ (very)
> 2. programmer does not want to create complex model to achieve maximum
> performance
> 
> Disk (cached) IO definitely hits first entry and second one is there for
> advertisements and fast deployment, but overall usage of the
> asynchronous IO model is not limited to the above scenario, so
> micro-threads definitely hit own niche, but they can not cover all usage
> cases.

You know, I read this a few times, but I still don't get what your point 
is here ;) Are you talking about micro-thread design in the kernel as for 
kthreads usage for AIO, or about userspace?



- Davide


