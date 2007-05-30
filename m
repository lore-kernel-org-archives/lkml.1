Return-Path: <linux-kernel-owner+w=401wt.eu-S1753679AbXE3Izv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753679AbXE3Izv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 04:55:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752956AbXE3Ize
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 04:55:34 -0400
Received: from relay.2ka.mipt.ru ([194.85.82.65]:40540 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752444AbXE3Izc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 04:55:32 -0400
Date: Wed, 30 May 2007 12:51:59 +0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Ingo Molnar <mingo@elte.hu>
Cc: Ulrich Drepper <drepper@redhat.com>, Jeff Garzik <jeff@garzik.org>,
       Zach Brown <zach.brown@oracle.com>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Syslets, Threadlets, generic AIO support, v6
Message-ID: <20070530085159.GC21528@2ka.mipt.ru>
References: <20070529212718.GH7875@mami.zabbo.net> <465CA654.5000505@garzik.org> <20070530072055.GA3077@elte.hu> <465D286E.2080807@redhat.com> <20070530084252.GA15708@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20070530084252.GA15708@elte.hu>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (2ka.mipt.ru [0.0.0.0]); Wed, 30 May 2007 12:52:18 +0400 (MSD)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2007 at 10:42:52AM +0200, Ingo Molnar (mingo@elte.hu) wrote:
> it is a serious flexibility issue that should not be ignored. The 
> unified fd space is a blessing on one hand because it's simple and 
> powerful, but it's also a curse because nested use of the fd space for 
> libraries is currently not possible. But it should be detached from any
> fundamental question of kevent vs. epoll. (By improving library use of
> file descriptors we'll improve the utility of all syscalls - by ducking
> to a memory based API we only solve that particular event based usage.)

There is another issue with file descriptors - userspace must dig into
kernel each time it wants to get a new set of events, while with memory
based approach it has them without doing so. After it has returned from
kernel and know that there are some evetns, kernel can add more of them
into the ring (if there is a place) and userspace will process them
withouth additional syscalls.
Although syscall overhead is very small, it does exist and should not be 
ignored in the design.

> 
> 	Ingo

-- 
	Evgeniy Polyakov
