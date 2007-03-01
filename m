Return-Path: <linux-kernel-owner+w=401wt.eu-S965126AbXCAObf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965126AbXCAObf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 09:31:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965116AbXCAObf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 09:31:35 -0500
Received: from pfx2.jmh.fr ([194.153.89.55]:57104 "EHLO pfx2.jmh.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965106AbXCAObU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 09:31:20 -0500
From: Eric Dumazet <dada1@cosmosbay.com>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
Date: Thu, 1 Mar 2007 15:31:12 +0100
User-Agent: KMail/1.9.5
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>, Pavel Machek <pavel@ucw.cz>,
       Theodore Tso <tytso@mit.edu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ulrich Drepper <drepper@redhat.com>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Zach Brown <zach.brown@oracle.com>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
References: <20070301095402.GA14603@elte.hu> <200703011519.20001.dada1@cosmosbay.com> <20070301141637.GA20006@elte.hu>
In-Reply-To: <20070301141637.GA20006@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703011531.12818.dada1@cosmosbay.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01 March 2007 15:16, Ingo Molnar wrote:
> * Eric Dumazet <dada1@cosmosbay.com> wrote:
> > I can tell you that the problem (at least on my machine) comes from :
> >
> > gettimeofday(&tm, NULL);
> >
> > in evserver_epoll.c
>
> yeah, that's another difference - especially if it's something like an
> Athlon64 and gettimeofday falls back to pm-timer, that could explain the
> performance difference. That's why i repeatedly asked Evgeniy to use the
> /very same/ client function for both the epoll and the kevent test and
> redo the measurements. The numbers are still highly suspect - and we are
> already down from the prior claim of kevent being almost twice as fast
> to a 25% difference.

Also, ab is quite lame... Maybe we could use a epoll based 'stresser' 

On my machines (again ...), ab is the slow thing... not the 'server'

Some small differences in behavior could have a big impact on ab (and you 
could think there is a problem on the remote side)

