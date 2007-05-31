Return-Path: <linux-kernel-owner+w=401wt.eu-S1760629AbXEaJgA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760629AbXEaJgA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 05:36:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758056AbXEaJfw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 05:35:52 -0400
Received: from brick.kernel.dk ([80.160.20.94]:29035 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757400AbXEaJfv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 05:35:51 -0400
Date: Thu, 31 May 2007 11:34:51 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>,
       Ulrich Drepper <drepper@redhat.com>, Jeff Garzik <jeff@garzik.org>,
       Zach Brown <zach.brown@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Syslets, Threadlets, generic AIO support, v6
Message-ID: <20070531093449.GN32105@kernel.dk>
References: <465D286E.2080807@redhat.com> <20070530084252.GA15708@elte.hu> <Pine.LNX.4.64.0705301148150.6272@alien.or.mcafeemobile.com> <alpine.LFD.0.98.0705301254210.26602@woody.linux-foundation.org> <465DE992.6070803@redhat.com> <alpine.LFD.0.98.0705301422230.26602@woody.linux-foundation.org> <Pine.LNX.4.64.0705301443340.6272@alien.or.mcafeemobile.com> <alpine.LFD.0.98.0705301457350.26602@woody.linux-foundation.org> <20070531061303.GA4436@elte.hu> <20070531093202.GA4784@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070531093202.GA4784@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 31 2007, Ingo Molnar wrote:
> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > (i definitely remember having written code for that too, but i cannot 
> > find that in the archives. hm.) In theory we could avoid _all_ 
> > fd-bitmap overhead as well and use a per-process list/pool of struct 
> > file buffers plus a maximum-fd field as the 'non-linear fd allocator' 
> > (at the price of only deallocating them at process exit time).
> 
> btw., this also allows mostly-lockless fd allocation, which would 
> probably benefit threaded apps too. (we can just recycle it from a 
> per-CPU list of cached fds for that process)

See also:

http://lkml.org/lkml/2006/6/16/144

which originates from a much simpler patch I did to fix performance
regressions in this area for the SLES10 kernel.

-- 
Jens Axboe

