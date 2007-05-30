Return-Path: <linux-kernel-owner+w=401wt.eu-S1758972AbXE3VtH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758972AbXE3VtH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 17:49:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760685AbXE3Vs0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 17:48:26 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:2037 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760674AbXE3VsY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 17:48:24 -0400
X-AuthUser: davidel@xmailserver.org
Date: Wed, 30 May 2007 14:48:22 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Linus Torvalds <torvalds@linux-foundation.org>
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
In-Reply-To: <alpine.LFD.0.98.0705301422230.26602@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0705301443340.6272@alien.or.mcafeemobile.com>
References: <20070529212718.GH7875@mami.zabbo.net> <465CA654.5000505@garzik.org>
 <20070530072055.GA3077@elte.hu> <465D286E.2080807@redhat.com>
 <20070530084252.GA15708@elte.hu> <Pine.LNX.4.64.0705301148150.6272@alien.or.mcafeemobile.com>
 <alpine.LFD.0.98.0705301254210.26602@woody.linux-foundation.org>
 <465DE992.6070803@redhat.com> <alpine.LFD.0.98.0705301422230.26602@woody.linux-foundation.org>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 May 2007, Linus Torvalds wrote:

> > And then the semantics: do these descriptors should show up in
> > /proc/self/fd?  Are there separate directories for each namespace?  Do
> > they count against the rlimit?
> 
> Oh, absolutely. The'd be real fd's in every way. People could use them 
> 100% equivalently (and concurrently) with the traditional ones. The whole, 
> and the _only_ point, would be that it breaks the legacy guarantees of a 
> dense fd space.
> 
> Most apps don't actually *need* that dense fd space in any case. But by 
> defaulting to it, we wouldn't break those (few) apps that actually depend 
> on it.

I agree. What would be a good interface to allocate fds in such area? We 
don't want to replicate syscalls, so maybe a special new dup function?



- Davide


