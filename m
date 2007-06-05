Return-Path: <linux-kernel-owner+w=401wt.eu-S933816AbXFEWvR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933816AbXFEWvR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 18:51:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765970AbXFEWvD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 18:51:03 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:2520 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759965AbXFEWvB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 18:51:01 -0400
X-AuthUser: davidel@xmailserver.org
Date: Tue, 5 Jun 2007 15:50:57 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH/RFC] signal races/bugs, losing TIF_SIGPENDING and other
 woes
In-Reply-To: <1181081720.31677.144.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0706051548290.23673@alien.or.mcafeemobile.com>
References: <1181006711.31677.97.camel@localhost.localdomain> 
 <alpine.LFD.0.98.0706041831400.23741@woody.linux-foundation.org> 
 <1181009413.31677.117.camel@localhost.localdomain> 
 <Pine.LNX.4.64.0706050839350.23304@alien.or.mcafeemobile.com>
 <1181081720.31677.144.camel@localhost.localdomain>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Jun 2007, Benjamin Herrenschmidt wrote:

> On Tue, 2007-06-05 at 08:52 -0700, Davide Libenzi wrote:
> >         if (tsk == current)
> >                 recalc_sigpending();
> > 
> > What can happen, is that a task may notice TIF_SIGPENDING and not find
> > a 
> > signal once it calls dequeue_signal(), but this is fine as far as
> > signalfd 
> > goes. This should be OK in general, no? 
> 
> What about the code in __dequeue_signal though ? That notifier thing is
> used by the DRI though I'm not sure what would happen if it acts on the
> wrong task.

Hmm, looking at the comments in block_all_signals(), it seems that they're 
interested in the fact that a specific task dequeue the signal. So, at 
a first sight, it seems that such code should not not be executed if 
another task dequeue the message. What do you think?



- Davide


