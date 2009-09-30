Return-Path: <linux-kernel-owner+w=401wt.eu-S1753798AbZI3BAJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753798AbZI3BAJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 21:00:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752212AbZI3BAJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 21:00:09 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:35497 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047AbZI3BAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 21:00:08 -0400
Date: Tue, 29 Sep 2009 20:59:56 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] proc: augment /proc/pid/limits to allow setting of
	process limits (v2).
Message-ID: <20090930005956.GA4848@localhost.localdomain>
References: <20090928200600.GA3053@hmsreliant.think-freely.org> <20090928154403.25678002.akpm@linux-foundation.org> <20090929202504.GC20420@hmsreliant.think-freely.org> <20090929134603.3935b149.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090929134603.3935b149.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Spam-Score: -4.9 (----)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 29, 2009 at 01:46:03PM -0700, Andrew Morton wrote:
> On Tue, 29 Sep 2009 16:25:04 -0400
> Neil Horman <nhorman@tuxdriver.com> wrote:
> 
> > 3) modify the proc/pid/limits write routine so that it uses do_setrlimit,
> > thereby giving us the previously missing security checks.
> 
> I dunno, the interface just seems goofy to me.
> 
Well, I hear what your saying, although conversely, but it seems a bit goofy to
me to allocate another syscall number just to do what sys_setrlimit does, but
with the addition of a pid specification.  I know theres precedent to do it, but
it seems no less goofy to me to do it that way than via a proc write.

> Yes, it's always been strange that rlimits cannot be externally
> altered.  And desirable to extend that.  But doing what is really a
> syscall via a profs poke when there already exists a syscall which does
> the same thing seems Just Wrong.
> 
Again, I understand what your saying, but to draw a parallel, the reason
/proc/pid/limits exists in the first place is because there was a desire to know
what the rlimit values were for a process from external contexts.  We could have
done this by creating a new syscall, and modifying the ulimit utility to accept
the data needed to support that new syscall.  But we didn't do that, we made a
proc file.  This just seems like the natural extension to that file, in my view.
With it, we don't need to create a new utility, or extend ulimit to make it all
work.

> What reason is there to do it via procfs?  Where's the benefit?
> 
Ease of use really.  With this interface, we can use cat/echo/etc to do
administrative control of process limits.  No need to extend ulimit, or create a
new utility.

> Maybe it's a plot to stop people from setting CONFIG_PROC_FS=n.
> 
hmm, so I'm looking at the patch.  90% of the work is done for a new syscall.
If you're adamant that you'd rather see it that way, how would you feel about a
both option?  I can write a follow on patch that creates a do_getrlimit, and
creates 2 new syscalls (to get/set rlimits for a specified pid).  Then we take
this patch as is, as well as the new patch, and we can access limits either way,
programatically via the syscalls, or from a high sysadmin interface via the proc
file.  Thoughts?

Neil

