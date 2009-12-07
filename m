Return-Path: <linux-kernel-owner+w=401wt.eu-S964981AbZLGUjA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964981AbZLGUjA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 15:39:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934836AbZLGUjA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 15:39:00 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:40419 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932778AbZLGUi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 15:38:59 -0500
Subject: Re: [rfc] "fair" rw spinlocks
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Christoph Hellwig <hch@infradead.org>, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20091207183226.GA20139@redhat.com>
References: <20091130100041.GA29610@infradead.org>
	 <alpine.LFD.2.00.0911300722370.2872@localhost.localdomain>
	 <20091130174638.GA9782@elte.hu>
	 <alpine.LFD.2.00.0911302206370.24119@localhost.localdomain>
	 <1259616429.26472.499.camel@laptop>
	 <alpine.LFD.2.00.0911302300550.24119@localhost.localdomain>
	 <alpine.LFD.2.00.0911301409560.2872@localhost.localdomain>
	 <alpine.LFD.2.00.0911302328350.24119@localhost.localdomain>
	 <alpine.LFD.2.00.0911301443110.2872@localhost.localdomain>
	 <m1y6lg7q3n.fsf@fess.ebiederm.org>  <20091207183226.GA20139@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 Dec 2009 21:38:40 +0100
Message-ID: <1260218320.3935.723.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-12-07 at 19:32 +0100, Oleg Nesterov wrote:
> On 12/05, Eric W. Biederman wrote:
> >
> > Atomically sending signal to every member of a process group, is the
> > big fly in the ointment I am aware of.  Last time I looked I could
> > not see how to convert it rcu.
> 
> I am not sure, but iirc we can do this lockless (under rcu_lock).
> We need to modify pid_link to use list_entry and attach_pid() should
> add the new task to the end. Of course we need more changes, but
> (again iirc) this is not too hard.
> 
> > This is a pain because we occasionally signal a process group from
> > interrupt context.
> 
> Only send_sigio/etc does so, right?
> 
> 
> I didn't read the previous discussion yet (will try tomorrow), sorry
> if I am off-topic. But I think the nastiest problem with tasklist
> is that it protects parent/child relationship. We need per-process
> lock, but first we should change ptrace to avoid this lock somehow.
> (this is one of the goals of ptrace-utrace, but not "immediate").

Didn't Thomas and you also come up with a scheme to push most signal
processing into task context?

