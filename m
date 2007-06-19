Return-Path: <linux-kernel-owner+w=401wt.eu-S1759527AbXFSXtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759527AbXFSXtS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 19:49:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756599AbXFSXtH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 19:49:07 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:1447 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756336AbXFSXtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 19:49:04 -0400
X-AuthUser: davidel@xmailserver.org
Date: Tue, 19 Jun 2007 16:49:01 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Oleg Nesterov <oleg@tv-sign.ru>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Nicholas Miell <nmiell@comcast.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Fix signalfd interaction with thread-private signals
In-Reply-To: <20070619091452.GA94@tv-sign.ru>
Message-ID: <Pine.LNX.4.64.0706191643400.16740@alien.or.mcafeemobile.com>
References: <alpine.LFD.0.98.0706162013420.14121@woody.linux-foundation.org>
 <1182064500.2798.6.camel@entropy> <Pine.LNX.4.64.0706170951580.20841@alien.or.mcafeemobile.com>
 <1182108399.3794.4.camel@entropy> <Pine.LNX.4.64.0706171436260.20841@alien.or.mcafeemobile.com>
 <1182125303.3794.8.camel@entropy> <Pine.LNX.4.64.0706171715320.5316@alien.or.mcafeemobile.com>
 <1182127391.26853.207.camel@localhost.localdomain>
 <alpine.LFD.0.98.0706181011460.14121@woody.linux-foundation.org>
 <20070619091452.GA94@tv-sign.ru>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Jun 2007, Oleg Nesterov wrote:

> The commited "Fix signalfd interaction with thread-private signals"
> (commit caec4e8dc85e0644ec24aeb36285e1ba02da58cc) doesn't implement
> this.
> 
> We can do something like
> 
> 	int signalfd_dequeue_signal(struct task_struct *tsk, sigset_t *mask, siginfo_t *info)
> 	{
> 		if (tsk->tgid == current->tgid)
> 			tsk = current;
> 
> 		return dequeue_signal(tsk, mask, info);
> 	}
> 
> (still I can't understand why should we change signalfd).

Actually, I think signalfd is fine as is, with Ben's patch applied. 
Signalfd should only fetch shared signals, not specific ones (in any 
case).



- Davide


