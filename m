Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753619Ab0BEPbA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 10:31:00 -0500
Received: from netrider.rowland.org ([192.131.102.5]:38982 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751207Ab0BEPa7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 10:30:59 -0500
Date: Fri, 5 Feb 2010 10:30:58 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Peter Zijlstra <peterz@infradead.org>
cc: "Eric W. Biederman" <ebiederm@xmission.com>, Greg KH <gregkh@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>, Cong Wang <amwang@redhat.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Tejun Heo <tj@kernel.org>, Miles Lane <miles.lane@gmail.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Patch 0/2] sysfs: fix s_active lockdep warning
In-Reply-To: <1265365117.22001.377.camel@laptop>
Message-ID: <Pine.LNX.4.44L0.1002051021120.22829-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Feb 2010, Peter Zijlstra wrote:

> Right, so this device stuff is much more complicated than I was led to
> believe ;-)

Haven't I told you all along that tree-structured locking is
complicated?  :-)

> So the device core doesn't know, so how are you guys making sure there
> really are no deadlocks hidden in there somewhere?

In the code I've seen, deadlocks are avoided by always taking the locks
in the same order.  But who knows?  Maybe there _are_ some hidden
deadlocks lurking.  For now we can't rely on lockdep to find them,
though, because it gets sidetracked by all the false positives.

> >  But for now perhaps a compromise is in
> > order.  We could make the switch from semaphores to mutexes while
> > avoiding lockdep issues by assigning the device mutexes to a
> > "don't-verify" class.  Is there such a thing, or could it be added?
> 
> Something like the below might work, but it should go along with a
> checkpatch.pl mod to ensure we don't grow any new users (just don't feel
> like brushing up my perl fu enough to actually make sense of that
> script)

I'll try it out in the next few days, and if it looks good maybe the 
checkpatch maintainers can lend some assistance before it gets 
submitted.

Alan Stern

