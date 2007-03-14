Return-Path: <linux-kernel-owner+w=401wt.eu-S964806AbXCNX36@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964806AbXCNX36 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 19:29:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964813AbXCNX36
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 19:29:58 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:42470 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964806AbXCNX35 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 19:29:57 -0400
X-AuthUser: davidel@xmailserver.org
Date: Wed, 14 Mar 2007 16:24:54 -0700 (PDT)
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
In-Reply-To: <20070314231920.GB1246@kvack.org>
Message-ID: <Pine.LNX.4.64.0703141620340.4982@alien.or.mcafeemobile.com>
References: <send-serie.davidel@xmailserver.org.13805.1173910770.13>
 <20070314231920.GB1246@kvack.org>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Mar 2007, Benjamin LaHaise wrote:

> On Wed, Mar 14, 2007 at 03:19:21PM -0700, Davide Libenzi wrote:
> > +	/*
> > +	 * Check if the user asked us to deliver the result through an
> > +	 * asyncfd. Note that asyncfd_add_results() may sleep. It seems
> > +	 * OK looking at the code, but I'm not sure since inside a USB driver,
> > +	 * aio_complete() is called with a spinlock held. !!CHECK
> > +	 */
> 
> That won't work.  aio_complete() is supposed to be irq safe.

Can you point me to a kernel path that ends up calling aio_complete() in a 
do-not-sleep mode?
The offender I see is drivers/usb/gadget/inode.c that calls it with a 
spinlock held.
The aio_run_iocb function seem to release/reacquire the lock before 
calling aio_complete().



- Davide


