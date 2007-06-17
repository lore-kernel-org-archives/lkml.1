Return-Path: <linux-kernel-owner+w=401wt.eu-S1754468AbXFQXt4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754468AbXFQXt4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 19:49:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752108AbXFQXtr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 19:49:47 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:2015 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581AbXFQXtr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 19:49:47 -0400
X-AuthUser: davidel@xmailserver.org
Date: Sun, 17 Jun 2007 16:49:40 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Nicholas Miell <nmiell@comcast.net>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@tv-sign.ru>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: And now for something _totally_ different: Linux v2.6.22-rc5
In-Reply-To: <1182108399.3794.4.camel@entropy>
Message-ID: <Pine.LNX.4.64.0706171436260.20841@alien.or.mcafeemobile.com>
References: <alpine.LFD.0.98.0706162013420.14121@woody.linux-foundation.org>
  <1182064500.2798.6.camel@entropy>  <Pine.LNX.4.64.0706170951580.20841@alien.or.mcafeemobile.com>
 <1182108399.3794.4.camel@entropy>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 17 Jun 2007, Nicholas Miell wrote:

> On Sun, 2007-06-17 at 10:01 -0700, Davide Libenzi wrote:
> > On Sun, 17 Jun 2007, Nicholas Miell wrote:
> > 
> > > On Sat, 2007-06-16 at 20:33 -0700, Linus Torvalds wrote:
> > > > In a stunning turn of events, I've actually been able to make another -rc 
> > > > release despite all the discussion (*cough*flaming*cough*) about other 
> > > > issues, and we now have a brand-spanking-new Linux 2.6.22-rc5 release 
> > > > out there!
> > > > 
> > > 
> > > signalfd still has the broken behavior w.r.t. signal delivery to
> > > threads.
> > > 
> > > Is this going to get fixed before 2.6.22 proper is released, or should
> > > it just be disabled entirely so no userspace apps grow to depend on
> > > current wrong behavior?
> > 
> > At the moment, with Ben's patch applied, signalfd can see all group-sent 
> > signals, and locally-directed thread signals.
> 
> But there's still no way for multiple threads to read from a single
> signalfd and get their own thread-specific signals in addition to
> process-wide signals, right? I think this was agreed to be the least
> surprising behavior.

Multiple threads can wait on the signalfd. Each one will dequeue either 
its own private signals (tsk->pending) or the process shared ones 
(tsk->signal->shared_pending). This will be the behaviour once Ben's patch 
is applied.



- Davide


