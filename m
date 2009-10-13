Return-Path: <linux-kernel-owner+w=401wt.eu-S1761004AbZJMUww@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761004AbZJMUww (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 16:52:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760206AbZJMUwv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 16:52:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60463 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752306AbZJMUwu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 16:52:50 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
X-Fcc: ~/Mail/linus
Cc: linux-kernel@vger.kernel.org, Oren Laadan <orenl@cs.columbia.edu>,
       serue@us.ibm.com, "Eric W. Biederman" <ebiederm@xmission.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Pavel Emelyanov <xemul@openvz.org>, Andrew Morton <akpm@osdl.org>,
       torvalds@linux-foundation.org, mikew@google.com, mingo@elte.hu,
       hpa@zytor.com, Nathan Lynch <nathanl@austin.ibm.com>, arnd@arndb.de,
       peterz@infradead.org, Louis.Rilling@kerlabs.com,
       kosaki.motohiro@jp.fujitsu.com, randy.dunlap@oracle.com,
       linux-api@vger.kernel.org,
       Containers <containers@lists.linux-foundation.org>, sukadev@us.ibm.com
Subject: Re: [RFC][v8][PATCH 0/10] Implement clone3() system call
In-Reply-To: Sukadev Bhattiprolu's message of  Monday, 12 October 2009 21:49:25 -0700 <20091013044925.GA28181@us.ibm.com>
References: <20091013044925.GA28181@us.ibm.com>
Emacs: the prosecution rests its case.
Message-Id: <20091013205015.1ED524F7@magilla.sf.frob.com>
Date: Tue, 13 Oct 2009 13:50:15 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some userland debugging things and so forth like to look at the clone_flags
argument, so that is kept simpler for them if it stays in a register
(i.e. its own argument) rather than a user pointer fetch for that argument.
Any problem with:

	sys_clone3(unsigned long clone_flags,
		   struct clone_struct __user *cs, pid_t __user *pids)

?

That also has the side benefit that instead of non-ia64 users forever
asking, "Why is it clone3 when there is no clone2?" you can instead pretend
that it follows the "clone3 because it takes three arguments" convention. ;-)

Btw, IMHO "struct foo_struct" is one of the lamest naming conventions ever.
How about "struct clone_args"?

Also, if you were to replace:

		u64 child_stack;

with:

		u64 child_stack_base;
		u64 child_stack_size;

and use in sys_clone3 (for most arch's):

	child_stack_ptr = kcs.child_stack_base + kcs.child_stack_size;

then the same clone3 interface would cover ia64 as well.


Thanks,
Roland
