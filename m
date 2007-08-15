Return-Path: <linux-kernel-owner+w=401wt.eu-S1764349AbXHOOk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764349AbXHOOk1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 10:40:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753895AbXHOOkK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 10:40:10 -0400
Received: from vena.lwn.net ([206.168.112.25]:49934 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753035AbXHOOkI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 10:40:08 -0400
To: Michael Kerrisk <mtk-manpages@gmx.net>
Cc: lkml <linux-kernel@vger.kernel.org>,
       Linux Torvalds <torvalds@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>, drepper@redhat.com,
       stable@kernel.org, Christoph Hellwig <hch@lst.de>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] Revised timerfd() interface 
From: corbet@lwn.net (Jonathan Corbet)
In-reply-to: Your message of "Thu, 09 Aug 2007 23:11:45 +0200."
             <46BB8311.6040702@gmx.net> 
Date: Wed, 15 Aug 2007 08:40:07 -0600
Message-ID: <32394.1187188807@lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for the late commentary...as I looked this over, one thing popped
into my mind....

> b) Make the 'clockid' immutable: it can only be set
>    if 'ufd' is -1 -- that is, on the timerfd() call that
>    first creates a timer.

timerfd() is looking increasingly like a multiplexor system call in
disguise.  There is no form of invocation which uses all of the
arguments.  Are we sure we wouldn't rather have something like:

	timerfd_open(clock);
	timerfd_adjust(fd, new_time, old_time);

?

jon
