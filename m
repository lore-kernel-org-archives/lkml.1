Return-Path: <linux-kernel-owner+w=401wt.eu-S1758948AbXJ2SHm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758948AbXJ2SHm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 14:07:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755809AbXJ2SHd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 14:07:33 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:33733 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755430AbXJ2SHc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 14:07:32 -0400
Subject: Re: [PATCH] pidns: Limit kill -1 and cap_set_all
From: Dave Hansen <haveblue@us.ibm.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org,
       Linux Containers <containers@lists.osdl.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Oleg Nesterov <oleg@tv-sign.ru>, Pavel Emelyanov <xemul@openvz.org>,
       "Sukadev Bhattiprolu [imap]" <sukadev@us.ibm.com>
In-Reply-To: <m1pryxpzsb.fsf@ebiederm.dsl.xmission.com>
References: <m1y7dp22d4.fsf@ebiederm.dsl.xmission.com>
	 <alpine.LFD.0.999.0710261105440.30120@woody.linux-foundation.org>
	 <m1r6jhzmov.fsf_-_@ebiederm.dsl.xmission.com>
	 <m1k5p9zk6b.fsf_-_@ebiederm.dsl.xmission.com>
	 <1193673738.24087.176.camel@localhost>
	 <m1pryxpzsb.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain
Date: Mon, 29 Oct 2007 11:07:27 -0700
Message-Id: <1193681247.24087.206.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-10-29 at 11:59 -0600, Eric W. Biederman wrote:
> ier to read.)  Also, can
> > we think of any better name for this?  It seems a bit funky that:
> >
> >       pid_in_pid_ns(mypid, &init_pid_ns);
> >
> > would _ever_ return 0.
> 
> It can't.
> 
> > So, it isn't truly a test for belonging *in* a
> > namespace, but having that namespace be the lowest level one. 
> 
> No.  It is precisely a test for being in a namespace.
> We first check ns->level to make certain it doesn't fall out
> of the array, and then we check to see if the namespace we
> are looking for is at that level.
> 
> pid->numbers[0].ns == &init_pid_ns.

Ahhh.  I misparsed the:

	pid->numbers[ns->level].ns == ns;

line to be checking at the pid level.  You're right, it works fine as it
stands.

-- Dave

