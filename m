Return-Path: <linux-kernel-owner+w=401wt.eu-S1756230AbYAISRO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756230AbYAISRO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 13:17:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754053AbYAISQ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 13:16:59 -0500
Received: from tetsuo.zabbo.net ([207.173.201.20]:59293 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753068AbYAISQ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 13:16:59 -0500
Message-ID: <47850F99.5020001@oracle.com>
Date: Wed, 09 Jan 2008 10:16:57 -0800
From: Zach Brown <zach.brown@oracle.com>
User-Agent: Thunderbird 2.0.0.9 (Macintosh/20071031)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Ulrich Drepper <drepper@redhat.com>,
       Arjan van de Ven <arjan@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Dan Williams <dan.j.williams@gmail.com>, Jeff Moyer <jmoyer@redhat.com>,
       Simon Holm Thogersen <odie@cs.aau.dk>, suresh.b.siddha@intel.com
Subject: Re: [PATCH 5/6] syslets: add generic syslets infrastructure
References: <1196983219534-git-send-email-zach.brown@oracle.com> <200801091303.58920.rusty@rustcorp.com.au> <478438B4.6010101@oracle.com> <200801091448.46241.rusty@rustcorp.com.au>
In-Reply-To: <200801091448.46241.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> Or do you mean the syscall return value ending up in the userspace
>> completion event ring?  That's mostly about being able to wait for
>> pending syslets to complete.
> 
> The latter.  A ring is optimal for processing a huge number of requests, but 
> if you're really going to be firing off syslet threads all over the place 
> you're not going to be optimal anyway.  And being able to point the return 
> value to the stack or into some datastructure is way nicer to code (zero 
> setup == easy to understand and easy to convert).

One of Linus' rhetorical requirements for the syslets work is that we be
able to wait for the result without spending overhead building up state
in some completion context.  The userland rings in the current syslet
patches achieve that and don't seem outrageously complicated.

I have a hard time getting worked up about this particular piece of the
puzzle, though.  If people are excited about *only* providing a pollable
fd to collect the syslet completions, well, great, whatever.

> This must be solved, yet all avenues seem crawling with worms.

Yup.

- z
