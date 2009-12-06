Return-Path: <linux-kernel-owner+w=401wt.eu-S933826AbZLFPSo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933826AbZLFPSo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 10:18:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933805AbZLFPSo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 10:18:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56804 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933786AbZLFPSn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 10:18:43 -0500
Date: Sun, 6 Dec 2009 10:17:50 -0500 (EST)
From: Miloslav Trmac <mitr@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
       Al Viro <viro@zeniv.linux.org.uk>, James Morris <jmorris@namei.org>,
       Alan Cox <alan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Renaud Lottiaux <renaud.lottiaux@kerlabs.com>,
       Louis Rilling <louis.rilling@kerlabs.com>,
       David Howells <dhowells@redhat.com>,
       Stanislaw Gruszka <sgruszka@redhat.com>,
       Veaceslav Falico <vfalico@redhat.com>
Message-ID: <2003788136.1223211260112670844.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
In-Reply-To: <1536386836.1223191260112270565.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
Subject: Re: [PATCH v2 4/4] copy_signal cleanup: clean tty_audit_fork()
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.5.72]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- "Oleg Nesterov" <oleg@redhat.com> wrote:
> On 12/05, Miloslav Trmac wrote:
> > > Off-topic question to this who understands this code.
> > >
> > > But afaics we can also remove ->siglock from this helper and make
> > > it really trivial for being inline. ->siglock buys nothing, we just
> > > read a boolean. In fact, after the quick grep I do not understand
> > > how ->siglock is connected to ->audit_tty. OK, it protects
> > > tty_audit_buf,
> > > but why we always take ->siglock to access ->audit_tty ?
> > AFAIK there is no explicit documentation of the atomicity semantics
> > expected by the Linux kernel (both from the hardware and from the compiler),
> > so every access to the boolean is protected by a lock, to be on the safe side.
> 
> Not sure I understand, but the kernel relies on fact it is always safe
> to load/store a word.
And is "word" an "unsigned", "unsigned long" or "intptr_t"?  Must it be suitably aligned, and if so, what is "suitably"?  Where is this documented?  

> What atomicity semantics do you mean and how ->siglock can help?
At the very least, "any access will read the last value stored and not result in undefined behavior, even if other threads attempt to access the value".  In user-space, per POSIX, the only way to guarantee this is using explicit synchronization primitives.

> I believe every spin_lock(siglock) around ->audit_tty is bogus.
It might very well be.  Again, I just wanted to be sure, given my limited understanding of the Linux memory model assumptions.
    Mirek
