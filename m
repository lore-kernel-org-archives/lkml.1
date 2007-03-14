Return-Path: <linux-kernel-owner+w=401wt.eu-S964852AbXCNXmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964852AbXCNXmT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 19:42:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964853AbXCNXmT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 19:42:19 -0400
Received: from kanga.kvack.org ([66.96.29.28]:48072 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964852AbXCNXmS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 19:42:18 -0400
Date: Wed, 14 Mar 2007 19:42:08 -0400
From: Benjamin LaHaise <bcrl@kvack.org>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Suparna Bhattacharya <suparna@in.ibm.com>,
       Zach Brown <zach.brown@oracle.com>
Subject: Re: [patch 13/13] signalfd/timerfd/asyncfd v5 - KAIO asyncfd support (example/maybe-broken) ...
Message-ID: <20070314234208.GC1246@kvack.org>
References: <send-serie.davidel@xmailserver.org.13805.1173910770.13> <20070314231920.GB1246@kvack.org> <Pine.LNX.4.64.0703141620340.4982@alien.or.mcafeemobile.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0703141620340.4982@alien.or.mcafeemobile.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 14, 2007 at 04:24:54PM -0700, Davide Libenzi wrote:
> Can you point me to a kernel path that ends up calling aio_complete() in a 
> do-not-sleep mode?

If you remove that invariant, then it is very difficult for device drivers 
and other code to make use of aio_complete().

> The offender I see is drivers/usb/gadget/inode.c that calls it with a 
> spinlock held.

Which was from irq context last time I checked.

> The aio_run_iocb function seem to release/reacquire the lock before 
> calling aio_complete().

That implies nothing -- aio_complete() has to acquire ctx_lock and cannot 
be called holding the lock.  Sure, it could probably be split into 
__aio_complete() and have aio_complete() wrap it acquiring the lock.

		-ben
-- 
"Time is of no importance, Mr. President, only life is important."
Don't Email: <zyntrop@kvack.org>.
