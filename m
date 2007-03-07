Return-Path: <linux-kernel-owner+w=401wt.eu-S965583AbXCGQ5h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965583AbXCGQ5h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 11:57:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965587AbXCGQ5h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 11:57:37 -0500
Received: from smtp.osdl.org ([65.172.181.24]:43446 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965583AbXCGQ5g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 11:57:36 -0500
Date: Wed, 7 Mar 2007 08:57:28 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: Davide Libenzi <davidel@xmailserver.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 1/4] signalfd v1 - signalfd core ...
In-Reply-To: <20070307233833.f1482f86.sfr@canb.auug.org.au>
Message-ID: <Pine.LNX.4.64.0703070854280.5963@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0703061639370.3661@alien.or.mcafeemobile.com>
 <20070307155553.06c82ca1.sfr@canb.auug.org.au>
 <Pine.LNX.4.64.0703062301590.10398@alien.or.mcafeemobile.com>
 <20070307233833.f1482f86.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 7 Mar 2007, Stephen Rothwell wrote:
> 
> You probably need the queue anyway because the real time signals are
> supposed to queue.

Davide - the *real* problem is (I think) that you try to allow signals to 
be returned *both* by signalfd() and as a real signal.

That's wrong, wrong, wrong.

My original patch used "dequeue_signal()" to dequeue signals. Trust me, I 
did that for a reason. Your re-design to think that you can get the signal 
without using the real signal dequeueing is simply broken.

The signalfd must be an "either or" thing. Either you get it as a real 
signal, or you get it off the signalfd(). Not both. Not neither.

		Linus
