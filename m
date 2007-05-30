Return-Path: <linux-kernel-owner+w=401wt.eu-S1759428AbXE3WGe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759428AbXE3WGe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 18:06:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757003AbXE3WGZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 18:06:25 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:2762 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755815AbXE3WGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 18:06:24 -0400
X-AuthUser: davidel@xmailserver.org
Date: Wed, 30 May 2007 15:06:22 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Ulrich Drepper <drepper@redhat.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Jeff Garzik <jeff@garzik.org>,
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
In-Reply-To: <465DF0F5.6050000@redhat.com>
Message-ID: <Pine.LNX.4.64.0705301503210.6272@alien.or.mcafeemobile.com>
References: <20070529212718.GH7875@mami.zabbo.net> <465CA654.5000505@garzik.org>
 <20070530072055.GA3077@elte.hu> <465D286E.2080807@redhat.com>
 <20070530084252.GA15708@elte.hu> <Pine.LNX.4.64.0705301148150.6272@alien.or.mcafeemobile.com>
 <alpine.LFD.0.98.0705301254210.26602@woody.linux-foundation.org>
 <465DE992.6070803@redhat.com> <alpine.LFD.0.98.0705301422230.26602@woody.linux-foundation.org>
 <465DF0F5.6050000@redhat.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 May 2007, Ulrich Drepper wrote:

> You also have to be aware that open() is just one piece of the puzzle.
> What about socket()?  I've cursed this interface many times before and
> now it's biting you: there is parameter to pass a flag.  What about
> transferring file descriptors via Unix domain sockets?  How can I decide
> the transferred descriptor should be in the private namespace?

Well, we can't just replicate/change every system call that creates a file 
descriptor. So I'm for something like:

int sys_fdup(int fd, int flags);

So you basically create your fds with their native/existing system calls, 
and then you dup/move them into the prefered fd space.



- Davide


