Return-Path: <linux-kernel-owner+w=401wt.eu-S1757647AbXFSXQo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757647AbXFSXQo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 19:16:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754512AbXFSXQh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 19:16:37 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:3982 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754351AbXFSXQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 19:16:36 -0400
X-AuthUser: davidel@xmailserver.org
Date: Tue, 19 Jun 2007 16:16:33 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Oleg Nesterov <oleg@tv-sign.ru>
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nicholas Miell <nmiell@comcast.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Fix signalfd interaction with thread-private signals
In-Reply-To: <20070619200818.GA122@tv-sign.ru>
Message-ID: <Pine.LNX.4.64.0706191606190.16740@alien.or.mcafeemobile.com>
References: <1182108399.3794.4.camel@entropy>
 <Pine.LNX.4.64.0706171436260.20841@alien.or.mcafeemobile.com>
 <1182125303.3794.8.camel@entropy> <Pine.LNX.4.64.0706171715320.5316@alien.or.mcafeemobile.com>
 <1182127391.26853.207.camel@localhost.localdomain>
 <alpine.LFD.0.98.0706181011460.14121@woody.linux-foundation.org>
 <20070619091452.GA94@tv-sign.ru> <1182254988.26853.334.camel@localhost.localdomain>
 <20070619140646.GB27343@tv-sign.ru> <Pine.LNX.4.64.0706191244090.16740@alien.or.mcafeemobile.com>
 <20070619200818.GA122@tv-sign.ru>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Jun 2007, Oleg Nesterov wrote:

> Well, I think the kernel doesn't make any assumptions on that. It can't
> guarantee the signal will be actually dequeued, to begin with.
> 
> (That said, I probably missed something, in that case I'd like to be
>  educated. This is the real reason why I am making the noise :)

What happens if a task gets a page fault that results in a SIGSEGV, and 
another task steals the SIGSEGV using a signalfd, before the faulted task 
has the chance to get into do_notify_resume() and notice it? ;)



- Davide


