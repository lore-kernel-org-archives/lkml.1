Return-Path: <linux-kernel-owner+w=401wt.eu-S933782AbXFEXAR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933782AbXFEXAR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 19:00:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763433AbXFEXAF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 19:00:05 -0400
Received: from gate.crashing.org ([63.228.1.57]:41829 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759965AbXFEXAE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 19:00:04 -0400
Subject: Re: [PATCH/RFC] signal races/bugs, losing TIF_SIGPENDING and other
	woes
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Mackerras <paulus@samba.org>
In-Reply-To: <Pine.LNX.4.64.0706051548290.23673@alien.or.mcafeemobile.com>
References: <1181006711.31677.97.camel@localhost.localdomain>
	 <alpine.LFD.0.98.0706041831400.23741@woody.linux-foundation.org>
	 <1181009413.31677.117.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0706050839350.23304@alien.or.mcafeemobile.com>
	 <1181081720.31677.144.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0706051548290.23673@alien.or.mcafeemobile.com>
Content-Type: text/plain
Date: Wed, 06 Jun 2007 08:59:28 +1000
Message-Id: <1181084368.31677.149.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-06-05 at 15:50 -0700, Davide Libenzi wrote:
> > What about the code in __dequeue_signal though ? That notifier thing
> is
> > used by the DRI though I'm not sure what would happen if it acts on
> the
> > wrong task.
> 
> Hmm, looking at the comments in block_all_signals(), it seems that
> they're 
> interested in the fact that a specific task dequeue the signal. So,
> at 
> a first sight, it seems that such code should not not be executed if 
> another task dequeue the message. What do you think?

Yes, I think the idea is that the DRM uses that to prevent signals to be
delivered to the task that is blocking them with the notifier (I have no
idea why they can't use the normal block mecanism for that... looks like
a hack to me).

So I suppose it's fine, as long as you add a test of tsk == current to
avoid calling it.

Ben.


