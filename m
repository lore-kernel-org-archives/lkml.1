Return-Path: <linux-kernel-owner+w=401wt.eu-S965999AbXFGD0L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965999AbXFGD0L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 23:26:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935607AbXFGDZ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 23:25:58 -0400
Received: from gate.crashing.org ([63.228.1.57]:42456 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754214AbXFGDZ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 23:25:57 -0400
Subject: Re: [BUG] ptraced process waiting on syscall may return kernel
	internal errnos
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>,
       Oleg Nesterov <oleg@tv-sign.ru>
In-Reply-To: <alpine.LFD.0.98.0706060811470.4205@woody.linux-foundation.org>
References: <20070606105900.DE5E94D0592@magilla.localdomain>
	 <alpine.LFD.0.98.0706060811470.4205@woody.linux-foundation.org>
Content-Type: text/plain
Date: Thu, 07 Jun 2007 13:25:24 +1000
Message-Id: <1181186724.14818.11.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-06-06 at 08:35 -0700, Linus Torvalds wrote:
> 
> So I think that the *right* place to clear TIF_SIGPENDING is actually in 
> "get_signal_to_deliver()", because that function is called _only_ by the 
> actual per-architecture "I'm going to deliver a signal now".

That was my initial idea but it has an issue with kernel
threads :-( There are in kernel thingies that use signals to a certain
extend and rely on being able to dequeue and/or clear sigpending (or
else they just loop instead of waiting in various loops).

A bit of a can of worms if you ask me.

Ben.


