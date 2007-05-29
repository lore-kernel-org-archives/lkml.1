Return-Path: <linux-kernel-owner+w=401wt.eu-S1751508AbXE2WRh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751508AbXE2WRh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 18:17:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750808AbXE2WRb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 18:17:31 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:57145 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750803AbXE2WRa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 18:17:30 -0400
Message-ID: <465CA654.5000505@garzik.org>
Date: Tue, 29 May 2007 18:16:52 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Zach Brown <zach.brown@oracle.com>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Syslets, Threadlets, generic AIO support, v6
References: <20070529212718.GH7875@mami.zabbo.net>
In-Reply-To: <20070529212718.GH7875@mami.zabbo.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Zach Brown wrote:
> I'm pleased to announce the availability of version 6 of the syslet subsystem.
> Ingo and I agreed that I'll handle syslet releases while he's busy with CFS.  I
> copied the cc: list from Ingo's v5 announcement.  If you'd like to be dropped
> (or added), please let me know.
> 
> The v6 patch series against 2.6.21 can be downloaded from:
> 
>   http://oss.oracle.com/~zab/syslets/v6/
> 
> Example applications and previous syslet releases can be found at:
> 
>  http://people.redhat.com/~mingo/syslet-patches/
>   
> The syslet subsystem aims to provide user-space with an efficient interface for
> managing the asynchronus submission and completion of existing system calls.
> 
> The only changes since v5 are small changes that I made to support the
> experimental aio patch described below.
> 
> My syslet subsystem todo list is as follows, in no particular order:
> 
>  - replace WARN_ON() calls with error handling or avoidance
>  - split the x86_64-async.patch into more specific patches
>  - investigate integration with ptrace
>  - investigate rare ./syslet-test cpu spinning
>  - provide distro kernel rpms and documentation for developers
>  - compat design problems, still? http://lkml.org/lkml/2007/3/7/523
> 
> Included in this patch series is an experimental patch which reworks fs/aio.c
> to reuse the syslet subsystem to process iocb requests from user space.  The
> intent of this work is to simplify the code and broaden aio functionality.  
> 
> Many issues need to be addressed before this aio work could be merged:
> 
>  - support cancellation by sending signals to async_threads 
>  - figure out what to do about signals from handlers, like SIGXFSZ
>  - verify that heavy loads do not consume excessive cpu or memory 
>  - concurrent dio writes
>  - cfq gets confused, share io_context amongst threads?
>  - restrict allowed operations like .aio_{r,w} methods used to
> 
> More details on this work in progress can be found in the patch.
> 
> Any and all feedback is welcome and encouraged!

You should pick up the kevent work :)

Having async request and response rings would be quite useful, and most 
closely match what is going on under the hood in the kernel and hardware.

	Jeff


