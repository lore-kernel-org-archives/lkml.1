Return-Path: <linux-kernel-owner+w=401wt.eu-S1760190AbXE3WEH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760190AbXE3WEH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 18:04:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757277AbXE3WDz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 18:03:55 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:36823 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756967AbXE3WDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 18:03:54 -0400
Date: Wed, 30 May 2007 15:01:47 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Davide Libenzi <davidel@xmailserver.org>
cc: Ulrich Drepper <drepper@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Jeff Garzik <jeff@garzik.org>, Zach Brown <zach.brown@oracle.com>,
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
In-Reply-To: <Pine.LNX.4.64.0705301443340.6272@alien.or.mcafeemobile.com>
Message-ID: <alpine.LFD.0.98.0705301457350.26602@woody.linux-foundation.org>
References: <20070529212718.GH7875@mami.zabbo.net> <465CA654.5000505@garzik.org>
 <20070530072055.GA3077@elte.hu> <465D286E.2080807@redhat.com>
 <20070530084252.GA15708@elte.hu> <Pine.LNX.4.64.0705301148150.6272@alien.or.mcafeemobile.com>
 <alpine.LFD.0.98.0705301254210.26602@woody.linux-foundation.org>
 <465DE992.6070803@redhat.com> <alpine.LFD.0.98.0705301422230.26602@woody.linux-foundation.org>
 <Pine.LNX.4.64.0705301443340.6272@alien.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 30 May 2007, Davide Libenzi wrote:
> 
> I agree. What would be a good interface to allocate fds in such area? We 
> don't want to replicate syscalls, so maybe a special new dup function?

I'd do it with something like "newfd = dup2(fd, NONLINEAR_FD)" or similar, 
and just have NONLINEAR_FD be some magic value (for example, make it be 
0x40000000 - the bit that says "private, nonlinear" in the first place).

But what's gotten lost in the current discussion is that we probably don't 
actually _need_ such a private space. I'm just saying that if the *choice* 
is between memory-mapped interfaces and a private fd-space, we should 
probably go for the latter. "Everything is a file" is the UNIX way, after 
all. But there's little reason to introduce private fd's otherwise.

			Linus
