Return-Path: <linux-kernel-owner+w=401wt.eu-S1757607AbZLKNqX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757607AbZLKNqX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 08:46:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756112AbZLKNqT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 08:46:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25427 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755907AbZLKNqS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 08:46:18 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <alpine.LFD.2.00.0912101542200.3089@localhost.localdomain>
References: <alpine.LFD.2.00.0912101542200.3089@localhost.localdomain> <20091210001308.247025548@linutronix.de> <20091210004703.029784964@linutronix.de> <20091210024324.GH6938@linux.vnet.ibm.com> <20091210142915.GB8226@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@redhat.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: dhowells@redhat.com, LKML <linux-kernel@vger.kernel.org>,
       Dipankar Sarma <dipankar@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Al Viro <viro@zeniv.linux.org.uk>, James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-security-module@vger.kernel.org
Subject: Re: [patch 1/9] sys: Fix missing rcu protection for __task_cred() access
Date: Fri, 11 Dec 2009 13:45:20 +0000
Message-ID: <13183.1260539120@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner <tglx@linutronix.de> wrote:

> > > Or are there updates that are carried out without write-holding
> > > tasklist_lock that I am missing?
> > 
> > Yes, commit_creds() is called lockless.
> 
> Right, and that's what the problem is. commit_creds(), which rcu frees
> the old creds, does not take tasklist lock write lock.

commit_creds() does not need to hold a write lock, because it is implicitly
write-locked by only being permitted to run in the thread to which it is
committing.

I don't think commit_creds() needs to take the RCU read lock as no-one else
can alter/delete the creds it is dealing with.

David
