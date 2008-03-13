Return-Path: <linux-kernel-owner+w=401wt.eu-S1757043AbYCMXgs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757043AbYCMXgs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 19:36:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752667AbYCMXgi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 19:36:38 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53911 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752471AbYCMXgh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 19:36:37 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
X-Fcc: ~/Mail/linus
Cc: paulus@samba.org, anton@samba.org, mingo@elte.hu, tglx@linutronix.de,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 1/4] powerpc copy_siginfo_from_user32
In-Reply-To: Andrew Morton's message of  Thursday, 13 March 2008 14:35:10 -0700 <20080313143510.9cfb7ab4.akpm@linux-foundation.org>
X-Fcc: ~/Mail/linus
References: <20080313083107.8BDE926F992@magilla.localdomain>
	<20080313143510.9cfb7ab4.akpm@linux-foundation.org>
X-Zippy-Says: I'm DESPONDENT...  I hope there's something DEEP-FRIED under this
    miniature DOMED STADIUM...
Message-Id: <20080313233601.E413226F9A4@magilla.localdomain>
Date: Thu, 13 Mar 2008 16:36:01 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This is advertised as a -mm patch but afacit it isn't against -mm.  And it
> doesn't seem to be against mainline either?  At least, the fourth patch
> fails to apply.

Oops, sorry for the bad labeling.  The baseline I used was actually x86/mm.
(This was originally going to be just some x86_64 cleanups destined for
post-2.6.25, before I noticed that powerpc had issues.)

> When trying to apply the fourth patch to -mm I hit a reject due to the new
> BTS support in git-x86.  I stopped there because the patch might be invalid
> because of this.

The only differences for that stuff should be to pass any new BTS requests
through to arch_ptrace as is done for e.g. PTRACE_GET_THREAD_AREA.  I'll
admit I tried not to think about that since it's disabled now and still in
so much flux.

> Even though this appears to be a signal-related patch it is actually
> ptrace-related, yes?

It is a prerequisite for ptrace cleanups/fixes, yes.  The change does not
affect any signals code behavior.  It may also be useful for other generic
signals compat code later (though I haven't looked into that yet).  I'd
call it "compat-related" really.

> This patch is a prerequisite for "ptrace: compat_ptrace_request siginfo",
> but this patch is independent from that patch (and from all others) and
> hence this patch can be merged on its own into powerpc tree if we wish to
> go that way, yes?  

Yes.

> Anwyay, please help me out with the dependencies here, and take a look at
> the x86 BTS stuff?

2/4 depends on 1/4 for powerpc64 to keep building.
3/4 depends on 2/4 for x86_64 kernel's 32-bit ptrace calls to keep working.
4/4 depends on 3/4 for same.

I've become fairly confused about the various trees and the state of the
ill-fated BTS code.  It's hard to figure out when it's coming and going
from where lately.  But resolving the actual code bits in any conflicts
with that will be trivial.


Thanks,
Roland
