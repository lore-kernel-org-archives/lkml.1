Return-Path: <linux-kernel-owner+w=401wt.eu-S1758426AbYLDVAp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758426AbYLDVAp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 16:00:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755463AbYLDVAg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 16:00:36 -0500
Received: from mx1.redhat.com ([66.187.233.31]:44337 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755001AbYLDVAf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 16:00:35 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, mingo@elte.hu,
       rnalumasu@gmail.com
Subject: Re: + do_wait-wakeup-optimization.patch added to -mm tree
In-Reply-To: Oleg Nesterov's message of  Thursday, 4 December 2008 16:26:01 +0100 <20081204152601.GB8816@redhat.com>
References: <200811212015.mALKFMs4019558@imap1.linux-foundation.org>
	<20081123213929.GA9097@redhat.com>
	<20081204005203.C795EFC3AB@magilla.sf.frob.com>
	<20081204152601.GB8816@redhat.com>
Emacs: featuring the world's first municipal garbage collector!
Message-Id: <20081204205942.81079FC32C@magilla.sf.frob.com>
Date: Thu,  4 Dec 2008 12:59:42 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > I don't see an exposed __wake_up* variant that both passes a "key" pointer
> > through and does "sync".  For __wake_up_parent, "sync" is quite desireable.
> 
> Well, yes... and __wake_up_common() is static. Perhaps we can make a new
> helper. 

Right, that's what I was suggesting (and not volunteering to do ;-).

> I must admit, I don't understand what "sync" actually means nowadays.

I don't claim to know any actual scheduler innards.  But the meaning as I
understand it is to "make it runnable, but don't try to reschedule right
now because current will block quite soon anyway.  If this does indeed
reduce work done to immediately reschedule, then it seems quite desireable
to avoid that flutter since the dying/stopping thread is very few cycles
away from yielding, and in the death case it will be for the last time and
rescheduling earlier just means a later unnecessary switch back and delayed
put_task_struct processing after the reap.


Thanks,
Roland

