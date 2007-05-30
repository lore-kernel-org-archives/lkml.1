Return-Path: <linux-kernel-owner+w=401wt.eu-S1759397AbXE3Vsb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759397AbXE3Vsb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 17:48:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760573AbXE3Vrr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 17:47:47 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:38627 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760207AbXE3Vrq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 17:47:46 -0400
Date: Wed, 30 May 2007 14:44:58 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: Davide Libenzi <davidel@xmailserver.org>, Ingo Molnar <mingo@elte.hu>,
       Ulrich Drepper <drepper@redhat.com>, Jeff Garzik <jeff@garzik.org>,
       Zach Brown <zach.brown@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Syslets, Threadlets, generic AIO support, v6
In-Reply-To: <465DEE59.9070901@goop.org>
Message-ID: <alpine.LFD.0.98.0705301442000.26602@woody.linux-foundation.org>
References: <20070529212718.GH7875@mami.zabbo.net> <465CA654.5000505@garzik.org>
 <20070530072055.GA3077@elte.hu> <465D286E.2080807@redhat.com>
 <20070530084252.GA15708@elte.hu> <Pine.LNX.4.64.0705301148150.6272@alien.or.mcafeemobile.com>
 <alpine.LFD.0.98.0705301254210.26602@woody.linux-foundation.org>
 <465DEE59.9070901@goop.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 30 May 2007, Jeremy Fitzhardinge wrote:
> 
> Some programs - legitimately, I think - scan /proc/self/fd to close
> everything.  The question is whether the glibc-private fds should appear
> there.  And something like a "close-on-fork" flag might be useful,
> though I guess glibc can keep track of its own fds closely enough to not
> need something like that.

Sure. I think there are things we can do (like make the non-linear fd's 
appear somewhere else, and make them close-on-exec by default etc).

And it's not like it's necessarily at all the only way to do things. 

I just threw it out as a possible solution - and one that is almost 
certainly *superior* to trying to work around the fd thing with some 
shared memory area which has tons of much more serious problems of its own 
(*).

		Linus

(*) Ranging from: specialized-only interfaces, inability to pass it 
around, lack of any abstraction interfaces, and almost impossible to 
debug. The security implications of kernel and user space sharing 
read-write access to some shared area are also legion!
