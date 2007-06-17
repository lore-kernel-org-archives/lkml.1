Return-Path: <linux-kernel-owner+w=401wt.eu-S1756683AbXFQRBd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756683AbXFQRBd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 13:01:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753742AbXFQRB0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 13:01:26 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:1431 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753463AbXFQRBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 13:01:25 -0400
X-AuthUser: davidel@xmailserver.org
Date: Sun, 17 Jun 2007 10:01:19 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Nicholas Miell <nmiell@comcast.net>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: And now for something _totally_ different: Linux v2.6.22-rc5
In-Reply-To: <1182064500.2798.6.camel@entropy>
Message-ID: <Pine.LNX.4.64.0706170951580.20841@alien.or.mcafeemobile.com>
References: <alpine.LFD.0.98.0706162013420.14121@woody.linux-foundation.org>
 <1182064500.2798.6.camel@entropy>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 17 Jun 2007, Nicholas Miell wrote:

> On Sat, 2007-06-16 at 20:33 -0700, Linus Torvalds wrote:
> > In a stunning turn of events, I've actually been able to make another -rc 
> > release despite all the discussion (*cough*flaming*cough*) about other 
> > issues, and we now have a brand-spanking-new Linux 2.6.22-rc5 release 
> > out there!
> > 
> 
> signalfd still has the broken behavior w.r.t. signal delivery to
> threads.
> 
> Is this going to get fixed before 2.6.22 proper is released, or should
> it just be disabled entirely so no userspace apps grow to depend on
> current wrong behavior?

At the moment, with Ben's patch applied, signalfd can see all group-sent 
signals, and locally-directed thread signals.
Linus, we can leave this as is, or we can use the ququed-signalfd that was
implemented in the first versions of signalfd. In such case, since 
signalfd hooks to the sighand, all signals will be visible to signalfd and 
they will not compete against dequeue_signal with the tasks. So there will 
be no races in the queue retrieval. The issue that remained to be solved 
was a simple way to limit memory allocated by the queue.
What do you prefer?



- Davide


