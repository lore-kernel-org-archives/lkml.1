Return-Path: <linux-kernel-owner+w=401wt.eu-S1751905AbXBVVZK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751905AbXBVVZK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 16:25:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751910AbXBVVZJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 16:25:09 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:49017 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751905AbXBVVZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 16:25:08 -0500
In-Reply-To: <20070222074044.GA4158@elte.hu>
References: <20070221211355.GA7302@elte.hu> <f2b55d220702211446l78af6f14hc3e0dd0084016770@mail.gmail.com> <20070221233111.GB5895@elte.hu> <45DCD9E5.2010106@redhat.com> <20070222074044.GA4158@elte.hu>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <A97A8AFD-3D1C-49EC-84DE-901D900244A0@oracle.com>
Cc: Ulrich Drepper <drepper@redhat.com>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Content-Transfer-Encoding: 7bit
From: Zach Brown <zach.brown@oracle.com>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
Date: Thu, 22 Feb 2007 13:23:57 -0800
To: Ingo Molnar <mingo@elte.hu>
X-Mailer: Apple Mail (2.752.3)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Plus there's the fundamental killer that KAIO is a /lot/ harder to
> implement (and to maintain) on the kernel side: it has to be  
> implemented
> for every IO discipline, and even for the IO disciplines it  
> supports at
> the moment, it is not truly asynchronous for things like metadata
> blocking or VFS blocking. To handle things like metadata blocking  
> it has
> to resort to non-statemachine techniques like retries - which are bad
> for performance.

Yes, yes, yes.

As one of the poor suckers who has been fixing bugs in fs/aio.c and  
fs/direct-io.c, I really want everyone to read Ingo's paragraph a few  
times.  Have it printed on a t-shirt.

Look at the number of man-years that have gone into fs/aio.c and fs/ 
direct-io.c.  After all that effort it *barely* supports non-blocking  
O_DIRECT IO.

The maintenance overhead of those two files, above all else, is what  
pushed me to finally try that nutty fibril attempt.

> Syslets/threadlets on the other hand, once the core is implemented,  
> have
> near zero ongoing maintainance cost (compared to KAIO pushed into  
> every
> IO subsystem) and cover all IO disciplines and API variants  
> immediately,
> and they are as perfectly asynchronous as it gets.

Amen.

As an experiment, I'm working on backing the sys_io_*() calls with  
syslets.  It's looking very promising so far.

> So all in one, i used to think that AIO state-machines have a long- 
> term
> place within the kernel, but with syslets i think i've proven myself
> embarrasingly wrong =B-)

Welcome to the party :).

- z
