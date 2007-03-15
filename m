Return-Path: <linux-kernel-owner+w=401wt.eu-S1422755AbXCOACZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422755AbXCOACZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 20:02:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422756AbXCOACZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 20:02:25 -0400
Received: from kanga.kvack.org ([66.96.29.28]:48250 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422755AbXCOACZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 20:02:25 -0400
Date: Wed, 14 Mar 2007 20:02:12 -0400
From: Benjamin LaHaise <bcrl@kvack.org>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Suparna Bhattacharya <suparna@in.ibm.com>,
       Zach Brown <zach.brown@oracle.com>
Subject: Re: [patch 13/13] signalfd/timerfd/asyncfd v5 - KAIO asyncfd support (example/maybe-broken) ...
Message-ID: <20070315000212.GD1246@kvack.org>
References: <send-serie.davidel@xmailserver.org.13805.1173910770.13> <20070314231920.GB1246@kvack.org> <Pine.LNX.4.64.0703141620340.4982@alien.or.mcafeemobile.com> <20070314234208.GC1246@kvack.org> <Pine.LNX.4.64.0703141638570.4982@alien.or.mcafeemobile.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0703141638570.4982@alien.or.mcafeemobile.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 14, 2007 at 04:41:58PM -0700, Davide Libenzi wrote:
> Yeah, of course. I do not plan revolutions. Just asking if it's a possible 
> thing to do. I can mlock the userspace ring, if imposing that burden over 
> aio_complete() is seen as too heavy.

I'm not sure I follow what you're doing -- why isn't asyncfd merely calling 
io_getevents() instead of reinventing everything the ringbuffer does?  The 
aio ringbuffer is already locked in memory.  Fwiw, the aio ringbuffer was 
originally wired up to a file descriptor, but that gave way to the actual 
syscall in order to enforce proper typechecking and typical usage scenarios 
with timeouts.

Also, there have been patches floating around for aio_poll and a way to get 
epoll wakeups into the aio event queue.  They deserve serious consideration 
if this asyncfd seems necessary.

		-ben
-- 
"Time is of no importance, Mr. President, only life is important."
Don't Email: <zyntrop@kvack.org>.
