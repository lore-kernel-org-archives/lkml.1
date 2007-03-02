Return-Path: <linux-kernel-owner+w=401wt.eu-S964822AbXCBTNb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964822AbXCBTNb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 14:13:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965144AbXCBTNb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 14:13:31 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:3115 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964822AbXCBTNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 14:13:30 -0500
X-AuthUser: davidel@xmailserver.org
Date: Fri, 2 Mar 2007 11:13:23 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
cc: Ingo Molnar <mingo@elte.hu>, Eric Dumazet <dada1@cosmosbay.com>,
       Pavel Machek <pavel@ucw.cz>, Theodore Tso <tytso@mit.edu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ulrich Drepper <drepper@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Zach Brown <zach.brown@oracle.com>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
In-Reply-To: <Pine.LNX.4.64.0703020840120.1977@alien.or.mcafeemobile.com>
Message-ID: <Pine.LNX.4.64.0703021106290.2381@alien.or.mcafeemobile.com>
References: <20070301095402.GA14603@elte.hu> <20070301131118.GA30228@elte.hu>
 <20070301133018.GB30177@2ka.mipt.ru> <200703011519.20001.dada1@cosmosbay.com>
 <20070301141637.GA20006@elte.hu> <20070301145454.GB12684@2ka.mipt.ru>
 <Pine.LNX.4.64.0703011123200.23932@alien.or.mcafeemobile.com>
 <20070302081047.GA27122@2ka.mipt.ru> <Pine.LNX.4.64.0703020840120.1977@alien.or.mcafeemobile.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Mar 2007, Davide Libenzi wrote:

> And if you really feel raw about the single O(nready) loop that epoll 
> currently does, a new epoll_wait2 (or whatever) API could be used to 
> deliver the event directly into a userspace buffer [1], directly from the 
> poll callback, w/out extra delivery loops (IRQ/event->epoll_callback->event_buffer).

And if you ever wonder from where the "epoll" name came, it came from the 
old /dev/epoll. The epoll predecessor /dev/epoll, was adding plugs 
everywhere events where needed and was delivering those events in O(1) 
*directly* on a user visible (mmap'd) buffer, in a zero-copy fashion.
The old /dev/epoll was faster the the current epoll, but the latter was 
chosen because despite being sloghtly slower, it had support for every 
pollable device, *without* adding more plugs into the existing code.
Performance and code maintainance are not to be taken disjointly whenever 
you evaluate a solution. That's the reason I got excited about this new 
generic AIO slution.



- Davide


