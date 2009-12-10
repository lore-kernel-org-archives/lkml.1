Return-Path: <linux-kernel-owner+w=401wt.eu-S1758927AbZLJDRF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758927AbZLJDRF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 22:17:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758697AbZLJDQ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 22:16:58 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55559 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758515AbZLJDQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 22:16:58 -0500
Date: Wed, 9 Dec 2009 19:15:52 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Dipankar Sarma <dipankar@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       Al Viro <viro@zeniv.linux.org.uk>, James Morris <jmorris@namei.org>,
       David Howells <dhowells@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 0/9] Fix various __task_cred related invalid RCU
 assumptions
In-Reply-To: <20091210022825.GG6938@linux.vnet.ibm.com>
Message-ID: <alpine.LFD.2.00.0912091914540.3560@localhost.localdomain>
References: <20091210001308.247025548@linutronix.de> <20091210022825.GG6938@linux.vnet.ibm.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 9 Dec 2009, Paul E. McKenney wrote:

> On Thu, Dec 10, 2009 at 12:52:46AM -0000, Thomas Gleixner wrote:
> > While auditing the read_lock(&tasklist_lock) sites for a possible
> > conversion to rcu-read_lock() I stumbled over an unprotected user of
> > __task_cred in kernel/sys.c
> > 
> > That caused me to audit all the __task_cred usage sites except in
> > kernel/exit.c.
> > 
> > Most of the usage sites are correct, but some of them trip over
> > invalid assumptions about the protection which is given by RCU.
> > 
> > - spinlocked/preempt_disabled regions are equivalent to rcu_read_lock():
> > 
> >    That's wrong. RCU does not guarantee that. 
> > 
> >    It has been that way due to implementation details and it still is
> >    valid for CONFIG_TREE_PREEMPT_RCU=n, but there is no guarantee that
> >    this will be the case forever.
> 
> To back this up, item #2 from Documentation/RCU/checklist.txt says:

Hmm. This seems to be a difference that the tree-RCU things introduced, 
no? I wonder if we have other areas where we just knew that a spinlock 
would make an rcu read-lock unnecessary (which used to be true..)

		Linus
