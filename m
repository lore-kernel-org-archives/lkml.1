Return-Path: <linux-kernel-owner+w=401wt.eu-S1755587AbXFMUUo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755587AbXFMUUo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 16:20:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752373AbXFMUUh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 16:20:37 -0400
Received: from mx1.redhat.com ([66.187.233.31]:48639 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751116AbXFMUUg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 16:20:36 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
X-Fcc: ~/Mail/linus
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: [BUG] 2.6.22-rc4: wait4() waiting for SIGSTOP may not return if the target process is ptraced
In-Reply-To: Satoru Takeuchi's message of  Thursday, 7 June 2007 19:15:04 +0900 <87tztk9il3.wl%takeuchi_satoru@jp.fujitsu.com>
Emacs: ballast for RAM.
Message-Id: <20070613202028.803964D059F@magilla.localdomain>
Date: Wed, 13 Jun 2007 13:20:28 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > The bug is in strace (and is being fixed).  It needs to use tgkill instead
> > of kill to send that SIGSTOP to the right thread only.  
> 
> You mean kill() to specifig thread is fundamentally wrong? If so, current
> kill() is wrong because it can receive pid of non main thread.

The kill call should only be used on process IDs (tgid in linuspeak).  This
is what POSIX defines it for.  I'm not sure off hand if it's technically a
violation of POSIX that it works for numbers that aren't a POSIX process ID
(aka tgid) but happen happen to be a Linux thread ID (aka pid).


Thanks,
Roland
