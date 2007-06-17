Return-Path: <linux-kernel-owner+w=401wt.eu-S1760866AbXFQT06@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760866AbXFQT06 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 15:26:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754541AbXFQT0v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 15:26:51 -0400
Received: from alnrmhc16.comcast.net ([204.127.225.96]:38796 "EHLO
	alnrmhc16.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649AbXFQT0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 15:26:50 -0400
Subject: Re: And now for something _totally_ different: Linux v2.6.22-rc5
From: Nicholas Miell <nmiell@comcast.net>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@tv-sign.ru>
In-Reply-To: <Pine.LNX.4.64.0706170951580.20841@alien.or.mcafeemobile.com>
References: <alpine.LFD.0.98.0706162013420.14121@woody.linux-foundation.org>
	 <1182064500.2798.6.camel@entropy>
	 <Pine.LNX.4.64.0706170951580.20841@alien.or.mcafeemobile.com>
Content-Type: text/plain
Date: Sun, 17 Jun 2007 12:26:39 -0700
Message-Id: <1182108399.3794.4.camel@entropy>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7.0.njm.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-06-17 at 10:01 -0700, Davide Libenzi wrote:
> On Sun, 17 Jun 2007, Nicholas Miell wrote:
> 
> > On Sat, 2007-06-16 at 20:33 -0700, Linus Torvalds wrote:
> > > In a stunning turn of events, I've actually been able to make another -rc 
> > > release despite all the discussion (*cough*flaming*cough*) about other 
> > > issues, and we now have a brand-spanking-new Linux 2.6.22-rc5 release 
> > > out there!
> > > 
> > 
> > signalfd still has the broken behavior w.r.t. signal delivery to
> > threads.
> > 
> > Is this going to get fixed before 2.6.22 proper is released, or should
> > it just be disabled entirely so no userspace apps grow to depend on
> > current wrong behavior?
> 
> At the moment, with Ben's patch applied, signalfd can see all group-sent 
> signals, and locally-directed thread signals.

But there's still no way for multiple threads to read from a single
signalfd and get their own thread-specific signals in addition to
process-wide signals, right? I think this was agreed to be the least
surprising behavior.

> Linus, we can leave this as is, or we can use the ququed-signalfd that was
> implemented in the first versions of signalfd. In such case, since 
> signalfd hooks to the sighand, all signals will be visible to signalfd and 
> they will not compete against dequeue_signal with the tasks. So there will 
> be no races in the queue retrieval. The issue that remained to be solved 
> was a simple way to limit memory allocated by the queue.
> What do you prefer?
> 
> 
> 
> - Davide

-- 
Nicholas Miell <nmiell@comcast.net>

