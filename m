Return-Path: <linux-kernel-owner+w=401wt.eu-S1759207AbXFDR5o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759207AbXFDR5o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 13:57:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754682AbXFDR5e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 13:57:34 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:2023 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753654AbXFDR5d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 13:57:33 -0400
X-AuthUser: davidel@xmailserver.org
Date: Mon, 4 Jun 2007 10:57:31 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Ingo Molnar <mingo@elte.hu>, Eric Dumazet <dada1@cosmosbay.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ulrich Drepper <drepper@redhat.com>
Subject: Re: [patch 1/2] ufd v1 - unsequential O(1) fdmap core
In-Reply-To: <20070604095605.66e04153.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0706041051090.30836@alien.or.mcafeemobile.com>
References: <send-serie.davidel@xmailserver.org.24319.1180825145.1>
 <46633047.1020707@cosmosbay.com> <Pine.LNX.4.64.0706031536000.13247@alien.or.mcafeemobile.com>
 <20070603230859.5000424d.akpm@linux-foundation.org> <20070604080537.GA22898@elte.hu>
 <20070604080941.GA23537@elte.hu> <20070604013449.ea3acca8.akpm@linux-foundation.org>
 <20070604084227.GA29446@elte.hu> <20070604014759.aaa3b051.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0706040533210.30231@alien.or.mcafeemobile.com>
 <20070604095605.66e04153.akpm@linux-foundation.org>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Jun 2007, Andrew Morton wrote:

> > must be RCU friendly (proper barriers) since it's used in 
> > lockless code,
> 
> Haven't looked at that.
> 
> > and must have flags associated to an allocation.
> 
> Don't understand that.

It needs to be able to store flags (like close-on-exec, and maybe more) 
together with a file*.


> > And I'm 
> > leaving out the O(1) part, that for something like this, is just silly not 
> > to have it. This is really an array.
> 
> Having to walk down a tree in fget_light() would kinda suck.
> 
> What about my b)?

Right now, I'm working on a patch that uses fdmap even for legacy 
(sequential) fd allocations. With a cleaner interface, w/out having code 
all around the kernel that access fdtable members directly. This should 
cut some code WRT using two different allocators (code in fs/file.c will 
almost zip-away), and maybe it'll look even better and have some new 
comments too ;)
It can be, in theory, completely abstracted and moved into lib/. I'll look 
into it once I completed the first cleanup, assuming the whole thing won't 
look worse than before :)



- Davide


