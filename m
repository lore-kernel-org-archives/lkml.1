Return-Path: <linux-kernel-owner+w=401wt.eu-S1751239AbXBNUwb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751239AbXBNUwb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 15:52:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751243AbXBNUwb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 15:52:31 -0500
Received: from gw.goop.org ([64.81.55.164]:42167 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751239AbXBNUwa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 15:52:30 -0500
Message-ID: <45D3768B.7010902@goop.org>
Date: Wed, 14 Feb 2007 12:52:27 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Benjamin LaHaise <bcrl@kvack.org>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 00/11] ANNOUNCE: "Syslets", generic asynchronous system
 call support
References: <20070213142010.GA638@elte.hu>
In-Reply-To: <20070213142010.GA638@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> Syslets consist of 'syslet atoms', where each atom represents a single 
> system-call. These atoms can be chained to each other: serially, in 
> branches or in loops. The return value of an executed atom is checked 
> against the condition flags. So an atom can specify 'exit on nonzero' or 
> 'loop until non-negative' kind of constructs.
>
> Syslet atoms fundamentally execute only system calls, thus to be able to 
> manipulate user-space variables from syslets i've added a simple special 
> system call: sys_umem_add(ptr, val). This can be used to increase or 
> decrease the user-space variable (and to get the result), or to simply 
> read out the variable (if 'val' is 0).
>   

This looks very interesting.  A couple of questions:

Are there any special semantics that result from running the syslet
atoms in kernel mode?  If I wanted to, could I write a syslet emulation
in userspace that's functionally identical to a kernel-based
implementation?  (Obviously the performance characteristics will be
different.)

I'm asking from the perspective of trying to work out the Valgrind
binding for this if it goes into the kernel.  Valgrind needs to see all
the input and output values of each system call the client makes,
including those done within the syslet mechanism.  It seems to me that
the easiest way to do this would be to intercept the syslet system
calls, and just implement them in usermode, performing the same series
of syscalls directly, and applying the Valgrind machinery to each one in
turn.

Would this work?

Also, an unrelated question: is there enough control structure in place
to allow multiple syslet streams to synchronize with each other with
futexes?

Thanks,
    J
