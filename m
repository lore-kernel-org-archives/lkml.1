Return-Path: <linux-kernel-owner+w=401wt.eu-S1755548AbZFCTxn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755548AbZFCTxn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 15:53:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753976AbZFCTxh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 15:53:37 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:41145 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753332AbZFCTxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 15:53:36 -0400
X-AuthUser: davidel@xmailserver.org
Date: Wed, 3 Jun 2009 12:47:32 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@makko.or.mcafeemobile.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Gregory Haskins <ghaskins@novell.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch] epoll - send POLLHUP on ->release
In-Reply-To: <20090603122739.c53b1d1f.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.1.10.0906031246030.18001@makko.or.mcafeemobile.com>
References: <alpine.DEB.1.10.0906031153471.18001@makko.or.mcafeemobile.com> <4A26CCFA.7050105@novell.com> <20090603122739.c53b1d1f.akpm@linux-foundation.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Jun 2009, Andrew Morton wrote:

> On Wed, 03 Jun 2009 15:20:26 -0400
> Gregory Haskins <ghaskins@novell.com> wrote:
> 
> > Davide Libenzi wrote:
> > > The following patch allows waiters to be notified about the eventfd file* 
> > > going away, and give them a change to unregister from the wait queue.
> > > This is turn allows eventfd users to use the eventfd file* w/out 
> > > holding a live reference to it.
> > > After the eventfd user callbacks returns, any usage of the eventfd file* 
> > > should be dropped. The eventfd user callback can acquire sleepy locks 
> > > since it is invoked lockless.
> > >
> > >
> > >
> > > Signed-off-by: Davide Libenzi <davidel@xmailserver.org>
> > >   
> > 
> > Tested-by: Gregory Haskins <ghaskins@novell.com>
> 
> Confused.  Did you test this with some new kernel patch, or with some
> existing kernel code?
> 
> If the latter, what code are we talking about here and what was the test
> case and what went wrong when using the current mainline
> implementation?

Andrew, this is not related to a bug in mainline. It's an helper for 
IRQFD, that allows them to not hold reference counts over the underlying 
eventfd.
I believe this has been tested using Gregory's IRQFD code.



- Davide


