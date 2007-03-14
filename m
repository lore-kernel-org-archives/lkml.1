Return-Path: <linux-kernel-owner+w=401wt.eu-S1422747AbXCNXq6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422747AbXCNXq6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 19:46:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422750AbXCNXq5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 19:46:57 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:42483 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422747AbXCNXq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 19:46:57 -0400
X-AuthUser: davidel@xmailserver.org
Date: Wed, 14 Mar 2007 16:41:58 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Benjamin LaHaise <bcrl@kvack.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Suparna Bhattacharya <suparna@in.ibm.com>,
       Zach Brown <zach.brown@oracle.com>
Subject: Re: [patch 13/13] signalfd/timerfd/asyncfd v5 - KAIO asyncfd support
 (example/maybe-broken) ...
In-Reply-To: <20070314234208.GC1246@kvack.org>
Message-ID: <Pine.LNX.4.64.0703141638570.4982@alien.or.mcafeemobile.com>
References: <send-serie.davidel@xmailserver.org.13805.1173910770.13>
 <20070314231920.GB1246@kvack.org> <Pine.LNX.4.64.0703141620340.4982@alien.or.mcafeemobile.com>
 <20070314234208.GC1246@kvack.org>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Mar 2007, Benjamin LaHaise wrote:

> On Wed, Mar 14, 2007 at 04:24:54PM -0700, Davide Libenzi wrote:
> > Can you point me to a kernel path that ends up calling aio_complete() in a 
> > do-not-sleep mode?
> 
> If you remove that invariant, then it is very difficult for device drivers 
> and other code to make use of aio_complete().
> 
> > The offender I see is drivers/usb/gadget/inode.c that calls it with a 
> > spinlock held.
> 
> Which was from irq context last time I checked.
> 
> > The aio_run_iocb function seem to release/reacquire the lock before 
> > calling aio_complete().
> 
> That implies nothing -- aio_complete() has to acquire ctx_lock and cannot 
> be called holding the lock.  Sure, it could probably be split into 
> __aio_complete() and have aio_complete() wrap it acquiring the lock.

Yeah, of course. I do not plan revolutions. Just asking if it's a possible 
thing to do. I can mlock the userspace ring, if imposing that burden over 
aio_complete() is seen as too heavy.



- Davide


