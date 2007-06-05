Return-Path: <linux-kernel-owner+w=401wt.eu-S933306AbXFEWQK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933306AbXFEWQK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 18:16:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762919AbXFEWP5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 18:15:57 -0400
Received: from gate.crashing.org ([63.228.1.57]:55887 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762672AbXFEWP4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 18:15:56 -0400
Subject: Re: [PATCH/RFC] signal races/bugs, losing TIF_SIGPENDING and other
	woes
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Mackerras <paulus@samba.org>
In-Reply-To: <Pine.LNX.4.64.0706050839350.23304@alien.or.mcafeemobile.com>
References: <1181006711.31677.97.camel@localhost.localdomain>
	 <alpine.LFD.0.98.0706041831400.23741@woody.linux-foundation.org>
	 <1181009413.31677.117.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0706050839350.23304@alien.or.mcafeemobile.com>
Content-Type: text/plain
Date: Wed, 06 Jun 2007 08:15:20 +1000
Message-Id: <1181081720.31677.144.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-06-05 at 08:52 -0700, Davide Libenzi wrote:
>         if (tsk == current)
>                 recalc_sigpending();
> 
> What can happen, is that a task may notice TIF_SIGPENDING and not find
> a 
> signal once it calls dequeue_signal(), but this is fine as far as
> signalfd 
> goes. This should be OK in general, no? 

What about the code in __dequeue_signal though ? That notifier thing is
used by the DRI though I'm not sure what would happen if it acts on the
wrong task.

Ben.

