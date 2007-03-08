Return-Path: <linux-kernel-owner+w=401wt.eu-S1030868AbXCHXFb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030868AbXCHXFb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 18:05:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030870AbXCHXFa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 18:05:30 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:43933 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030864AbXCHXFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 18:05:25 -0500
X-AuthUser: davidel@xmailserver.org
Date: Thu, 8 Mar 2007 15:05:20 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Oleg Nesterov <oleg@tv-sign.ru>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Avi Kivity <avi@argo.co.il>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch 2/5] signalfd v2 - signalfd core ...
In-Reply-To: <20070308215653.GA6744@tv-sign.ru>
Message-ID: <Pine.LNX.4.64.0703081459350.4882@alien.or.mcafeemobile.com>
References: <20070308204353.GA6733@tv-sign.ru>
 <Pine.LNX.4.64.0703081259560.7515@alien.or.mcafeemobile.com>
 <20070308215653.GA6744@tv-sign.ru>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Mar 2007, Oleg Nesterov wrote:

> > Logic is, if it's not an RT signal, queue only one, otherwise multiple.
> > The bit on the ->pending mask is clealer only when the queue slot becomes empty.
> 
> Yes, I see what the code does, but I don't undestand why. For example, SIGCHLD was
> delivered to the process _and_ handled several times, then sys_signalfd_dequeue()
> comes and finds only one siginfo. Isn't this strange?

That's the same logic the kernel folows for non-RT signals. 


> > The two trasports can rely on different masks. The signalfd_notify() does 
> > not even go in signalfd_deliver() if no signalfds are attached to the 
> > sighand.
> 
> Sorry, I don't understand. The masks are different, yes, but ->sighand is the
> same? How this can make any difference for "if no signalfds are attached" ?

The list_empty() che would not make you fall inside signalfd_deliver(), 
hence the fast path really lives up to its name ;)


> Also. A malicious user can eat all memory, signalfd_deliver()->kmem_cache_alloc()
> doesn't check any limits.

I'll make that use the std dequeu_signal, so everything is handled in there.



- Davide


