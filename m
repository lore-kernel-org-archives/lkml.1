Return-Path: <linux-kernel-owner+w=401wt.eu-S1757933AbZCTL0t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757933AbZCTL0t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 07:26:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751577AbZCTL0k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 07:26:40 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:39749 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261AbZCTL0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 07:26:39 -0400
To: mingo@elte.hu
CC: miklos@szeredi.hu, peterz@infradead.org, roland@redhat.com, efault@gmx.de,
       rjw@sisk.pl, jdike@addtoit.com,
       user-mode-linux-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org
In-reply-to: <20090320105306.GG6256@elte.hu> (message from Ingo Molnar on Fri,
	20 Mar 2009 11:53:06 +0100)
Subject: Re: [patch] don't preempt not TASK_RUNNING tasks
References: <E1LkbGe-00039U-Hc@pomaz-ex.szeredi.hu> <1237543392.24626.49.camel@twins> <E1Lkc6U-0003II-W1@pomaz-ex.szeredi.hu> <20090320105306.GG6256@elte.hu>
Message-Id: <E1LkcrP-0003Np-T2@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 20 Mar 2009 12:25:59 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Mar 2009, Ingo Molnar wrote:
> > > The first line of attack for this problem is making 
> > > wait_task_inactive() sucks less, which shouldn't be too hard, 
> > > that unconditional 1 jiffy sleep is simply retarded.
> > 
> > I completely agree.  However, I'd like to have a non-invasive 
> > solution that can go into current and stable kernels so UML users 
> > don't need to suffer any more.
> 
> Agreed. task_unlock_no_resched() should do that i think.

I don't see how that would help.

ptrace_stop() specifically would need read_unlock_no_resched().  But
I'm reluctant to add more spinlock functions with all their
variants...

Thanks,
Miklos
