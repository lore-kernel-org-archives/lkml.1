Return-Path: <linux-kernel-owner+w=401wt.eu-S1756724AbYC1Cdj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756724AbYC1Cdj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 22:33:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755504AbYC1Cd2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 22:33:28 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41703 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755905AbYC1Cd1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 22:33:27 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH] ptrace: arch_ptrace cleanup
In-Reply-To: Linus Torvalds's message of  Thursday, 27 March 2008 16:14:14 -0700 <alpine.LFD.1.00.0803271612360.14670@woody.linux-foundation.org>
X-Fcc: ~/Mail/linus
References: <20080327230623.969FF26FA1C@magilla.localdomain>
	<alpine.LFD.1.00.0803271612360.14670@woody.linux-foundation.org>
X-Zippy-Says: ..Hmmm...This thing is really VIBRATING! ..It's getting WARM, too!
Message-Id: <20080328023155.71B6626FA1C@magilla.localdomain>
Date: Thu, 27 Mar 2008 19:31:55 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I wanted to know if there was some actual technical point to it, and never 
> got a reply to that. 

I thought I did answer that.  But I will again.  Yes, it's preemptive.
You won't gain anything right now.  That doesn't make it "churn for
churn's sake".  (For Pete's sake, you think I do this for fun?)

One of these days I will post substantial core ptrace changes.  I don't
know what these are yet, but I know it's likely they will need to change
what's passed between sys_ptrace and ptrace_request/ptrace_resume.  We
can expect that there will be churn in that code while we hash out how
it should be.  Doing this arch patch first means that none of that later
churn will involve changing arch_ptrace back and forth while the
non-arch code gets settled.

If this goes in early after 2.6.25, there will be ample opportunity to
hack on and hash out core changes with lots of flux and not worry about
arch conflicts.  Different people's versions can fall in and out of -mm
without juggling arch fixups in each variant, etc.  It's really for the
benefit of those of us who are exchanging lots of patches in this area
before they are ready for you to merge.

In short, it is cleaner if the arch calls only deal with the cases they
know how to handle, including knowing what the control flow or state
shared between pieces of non-arch code might be.  If you don't buy it,
fine.  Take it or don't.  The first time I have new code to submit that
is cleanest if it can break every ptrace_request caller, I'll make the
first patch in that series (maybe identical to this one) take arch_ptrace
out of the call graph for non-arch cases with the comment "so we never
have to break every arch_ptrace for arch-irrelevant changes *again*".


Thanks,
Roland
