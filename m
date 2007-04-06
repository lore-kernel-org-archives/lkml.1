Return-Path: <linux-kernel-owner+w=401wt.eu-S933264AbXDFWjA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933264AbXDFWjA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 18:39:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933275AbXDFWi7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 18:38:59 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:38103 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933267AbXDFWi6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 18:38:58 -0400
Message-ID: <4616CBF0.7090606@garzik.org>
Date: Fri, 06 Apr 2007 18:38:40 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Robin Holt <holt@sgi.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Jack Steiner <steiner@americas.sgi.com>
Subject: Re: init's children list is long and slows reaping children.
References: <20070405195118.GH22762@lnx-holt.americas.sgi.com>
In-Reply-To: <20070405195118.GH22762@lnx-holt.americas.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robin Holt wrote:
> We have been testing a new larger configuration and we are seeing a very
> large scan time of init's tsk->children list.  In the cases we are seeing,
> there are numerous kernel processes created for each cpu (ie: events/0
> ... events/<big number>, xfslogd/0 ... xfslogd/<big number>).  These are
> all on the list ahead of the processes we are currently trying to reap.

What about attacking the explosion of kernel threads?

As CPU counts increase, the number of per-CPU kernel threads gets really 
ridiculous.

I would rather change the implementation under the hood to start per-CPU 
threads on demand, similar to a thread-pool implementation.

Boxes with $BigNum CPUs probably won't ever use half of those threads.

	Jeff



