Return-Path: <linux-kernel-owner+w=401wt.eu-S1760223AbYA3Jpj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760223AbYA3Jpj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 04:45:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755576AbYA3Jp1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 04:45:27 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:48720 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754005AbYA3Jp0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 04:45:26 -0500
Date: Wed, 30 Jan 2008 12:48:01 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: paulmck@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix tasklist + find_pid() with CONFIG_PREEMPT_RCU
Message-ID: <20080130094801.GA143@tv-sign.ru>
References: <20080129164019.GA2060@tv-sign.ru> <m1ir1cgfmm.fsf@ebiederm.dsl.xmission.com> <20080130050048.GH12073@linux.vnet.ibm.com> <m163xbhdq5.fsf@ebiederm.dsl.xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m163xbhdq5.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/30, Eric W. Biederman wrote:
>
> "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> writes:
> 
> > On Tue, Jan 29, 2008 at 08:24:17PM -0700, Eric W. Biederman wrote:
> >> 
> >> Using the tasklist_lock to still guarantee we see the list, the entire
> >> list, and exactly the list for proper implementation of kill to
> >> process groups and sessions still seems sane.
> >> 
> >> So let's just remove the guarantee of find_pid being usable with
> >> just the tasklist_lock held.
> >
> > Makes sense to me -- it is totally permissible to hold rcu_read_lock()
> > across update code.  ;-)
> 
> Let me rephrase so it is clear.
> 
> When dealing with pids there is exactly one case where we need
> to take read_lock(&tasklist_lock);

Well, another example is sys_ioprio_set(IOPRIO_WHO_PGRP),

> Posix (and sanely handling corner cases) requires that when we send a
> signal to a process group or a session we have a snapshot in time view
> of the entire group.  In particular this allows us to send SIGKILL to
> every member of the group and to have the entire group die.

but you are right of course. tasklist pins group/session/->tasks.

Oleg.

