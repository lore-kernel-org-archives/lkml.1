Return-Path: <linux-kernel-owner+w=401wt.eu-S1750704AbXBMOwN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750704AbXBMOwN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 09:52:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750708AbXBMOwN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 09:52:13 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:48383 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750712AbXBMOwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 09:52:11 -0500
Date: Tue, 13 Feb 2007 15:00:19 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Benjamin LaHaise <bcrl@kvack.org>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 00/11] ANNOUNCE: "Syslets", generic asynchronous system
 call support
Message-ID: <20070213150019.4b4d4827@localhost.localdomain>
In-Reply-To: <20070213142010.GA638@elte.hu>
References: <20060529212109.GA2058@elte.hu>
	<20070213142010.GA638@elte.hu>
X-Mailer: Claws Mail 2.7.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> A syslet is executed opportunistically: i.e. the syslet subsystem 
> assumes that the syslet will not block, and it will switch to a 
> cachemiss kernel thread from the scheduler. This means that even a 

How is scheduler fairness maintained ? and what is done for resource
accounting here ?

> that the kernel fills and user-space clears. Waiting is done via the 
> sys_async_wait() system call. Completion can be supressed on a per-atom 

They should be selectable as well iff possible.

> Open issues:

Let me add some more

	sys_setuid/gid/etc need to be synchronous only and not occur
while other async syscalls are running in parallel to meet current kernel
assumptions.

	sys_exec and other security boundaries must be synchronous only
and not allow async "spill over" (consider setuid async binary patching)

>  - sys_fork() and sys_async_exec() should be filtered out from the 
>    syscalls that are allowed - first one only makes sense with ptregs, 

clone and vfork. async_vfork is a real mindbender actually.

>    second one is a nice kernel recursion thing :) I didnt want to 
>    duplicate the sys_call_table though - maybe others have a better 
>    idea.

What are the semantics of async sys_async_wait and async sys_async ?

