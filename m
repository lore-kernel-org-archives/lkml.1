Return-Path: <linux-kernel-owner+w=401wt.eu-S1751789AbXGaG54@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751789AbXGaG54 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 02:57:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750858AbXGaG5s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 02:57:48 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:42884 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750854AbXGaG5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 02:57:47 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Takenori Nagano <t-nagano@ah.jp.nec.com>
Cc: vgoyal@in.ibm.com, k-miyoshi@cb.jp.nec.com,
       Bernhard Walle <bwalle@suse.de>, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch] add kdump_after_notifier
References: <469F55D0.4050203@ah.jp.nec.com> <20070726140702.GA8949@suse.de>
	<20070726153240.GA15969@in.ibm.com> <20070726153440.GA19095@suse.de>
	<20070726154415.GB15969@in.ibm.com> <20070726154718.GA25561@suse.de>
	<20070726155444.GC15969@in.ibm.com> <46A92E30.8070703@ah.jp.nec.com>
	<20070730091624.GB6071@in.ibm.com>
	<m16442vwgs.fsf@ebiederm.dsl.xmission.com>
	<46AECEE0.3000307@ah.jp.nec.com>
Date: Tue, 31 Jul 2007 00:53:54 -0600
In-Reply-To: <46AECEE0.3000307@ah.jp.nec.com> (Takenori Nagano's message of
	"Tue, 31 Jul 2007 14:55:44 +0900")
Message-ID: <m1fy35t665.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Takenori Nagano <t-nagano@ah.jp.nec.com> writes:
>
> Hi all,
>
> IMHO, most users don't use kdump, kdump users are only kernel developers and
> enterprise users. 

Not at all.  So far the only kdump related bug report I have seen has
been from fedora Core.

> think enterprise users want the notifier function, because
> they use some driver and software (hardware monitering driver, clustering
> software, heartbeat driver, etc...) to raise their system availability.

Which users want this?  Specifics are needed here not hand waving.
In particular why can't the use the existing hooks that are already
in place.

> Some popular distributers added the dump function to their own kernel. We can
> use panic_notifier on LKCD (http://lkcd.sourceforge.net/), and diskdump
> (http://sourceforge.net/projects/lkdump) provides own notifier function
> disk_dump_notifier.
>
> Now, kdump was merged mainline kernel. Then some distributers chose kdump.
> I think kdump is greater than other dump function, but kdump has no notifier
> function. This is a large problem for enterprise users.

Why?  If this is a large problem we should have people that are willing
to have patches with users of this notifier.

> Solutions
>  1: my patch
>  2: Bernhard's idea
>  3: add kdump_notifier_list

I think you are solving a non-problem.  And the more I get hand waving
the more I think this. 

> I think my patch is better than other solutions, because it has only very few
> impact. Vivek, Eric, how do you think?

No.  The problem with your patch is that it doesn't have a code
impact.  We need to see who is using this and why.

Because you are trying to hide what is going on your code has
a tremendous maintenance and review burden.  I think any hook has a
tremendous maintenance and review burden.  Especially since the people
who want this absolutely refuse to publish their code.

If it is some proprietary solution that needs this and can not
withstand a code review it is absolutely the wrong thing to have
on this path.

The answer is no, and it isn't even worth talking about
until the code for some real users shows up.

Adding a notifier violates a fundamental assumption of
the code path.  The assumption is that the entire kernel
is broken, and you want me to follow a broken pointer
to broken code?

We already have so much code on that code path it is almost
impossible to test and review thoroughly and you want to
add more crap?

My apologies about my tone but I'm very annoyed at the direction of
all of this conversation, please don't try and avoid showing the
users.  Please let's make it upfront.

Eric
