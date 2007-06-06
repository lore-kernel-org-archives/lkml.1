Return-Path: <linux-kernel-owner+w=401wt.eu-S965575AbXFFXIQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965575AbXFFXIQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 19:08:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965580AbXFFXHx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 19:07:53 -0400
Received: from ozlabs.org ([203.10.76.45]:54672 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965500AbXFFXHw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 19:07:52 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18023.15936.864242.214870@cargo.ozlabs.ibm.com>
Date: Thu, 7 Jun 2007 09:07:44 +1000
From: Paul Mackerras <paulus@samba.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>,
       Oleg Nesterov <oleg@tv-sign.ru>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [BUG] ptraced process waiting on syscall may return kernel
 internal errnos
In-Reply-To: <alpine.LFD.0.98.0706060811470.4205@woody.linux-foundation.org>
References: <20070606105900.DE5E94D0592@magilla.localdomain>
	<alpine.LFD.0.98.0706060811470.4205@woody.linux-foundation.org>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds writes:

> So I think that the *right* place to clear TIF_SIGPENDING is actually in 
> "get_signal_to_deliver()", because that function is called _only_ by the 
> actual per-architecture "I'm going to deliver a signal now".

I agree that's the right place for real user processes, but I note
that there are drivers that have kernel threads that do basically
this:

	if (signal_pending(current))
		dequeue_signal(current, ...);

for example, drivers/block/nbd.c, and obviously they don't want to
still see signal_pending(current) after they have dequeued all the
pending signals.

Paul.
