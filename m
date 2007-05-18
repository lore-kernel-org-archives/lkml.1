Return-Path: <linux-kernel-owner+w=401wt.eu-S1759209AbXERGkF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759209AbXERGkF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 02:40:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754737AbXERGj4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 02:39:56 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51032 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752893AbXERGjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 02:39:55 -0400
Date: Thu, 17 May 2007 23:37:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Davi Arnaut <davi@haxent.com.br>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] timerfd/eventfd context lock doesn't protect against
 poll_wait
Message-Id: <20070517233722.8d4be064.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0705172258400.5705@alien.or.mcafeemobile.com>
References: <464D2142.3070705@haxent.com.br>
	<Pine.LNX.4.64.0705172258400.5705@alien.or.mcafeemobile.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 May 2007 23:20:05 -0700 (PDT) Davide Libenzi <davidel@xmailserver.org> wrote:

> On Fri, 18 May 2007, Davi Arnaut wrote:
> 
> > Hi,
> > 
> > poll_wait() callback may modify the waitqueue without holding the
> > context private lock.
> 
> Thx Davi, patch is correct. Nice catch. But at this point instead of 
> ending up getting two locks, we may look into using Andrew suggestion of 
> reusing the waitqueue lock. Is it universally considered a "legal" 
> operation?
> 

I think it's a reasonable thing to do in core kernel code.  It'd be more
worrisome if it was done way down in some rarely-visited device driver.

btw, the code at present doesn't explicitly take care of WQ_FLAG_EXCLUSIVE.
I guess as you want wake-all behaviour that's OK, but it might be worth a
mention somewhrre.

hm, fs/signalfd.c is "Copyright (C) 2003 Linus Torvalds".  He was before
his time, that lad.

