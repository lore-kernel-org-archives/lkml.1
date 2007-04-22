Return-Path: <linux-kernel-owner+w=401wt.eu-S1754120AbXDVHLh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754120AbXDVHLh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 03:11:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754125AbXDVHLh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 03:11:37 -0400
Received: from wr-out-0506.google.com ([64.233.184.238]:42979 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754120AbXDVHLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 03:11:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:mail-followup-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=rt+UkFD+dRTqJQa8CYh/UuvBiAEvYViSnV+sWoEP3l72+Nj2jYPDczG/NkvhN/HG+mDSTztZWcrpTcLA+78Nq2mWugW7BVF5ZrFwWTdW/9hys4DijE5o2CQ3/GE6TERQHgDO3AH4V7TVgnpD5+Hh3Vr68silOaz1TpZ+6phn2IA=
Date: Sun, 22 Apr 2007 16:06:03 +0900
To: Andi Kleen <andi@firstfloor.org>
Cc: Scott Porter <scott@opengridcomputing.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Fault Injection issues: stacktrace x86_64 and failslab NUMA
Message-ID: <20070422070603.GA30662@APFDCB5C>
Mail-Followup-To: Akinobu Mita <Akinobu.Mita@gmail.com>,
	Andi Kleen <andi@firstfloor.org>,
	Scott Porter <scott@opengridcomputing.com>,
	linux-kernel <linux-kernel@vger.kernel.org>
References: <1177095354.25165.48.camel@scott-desktop.site> <1177192363.25165.101.camel@scott-desktop.site> <20070421221033.GA30496@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070421221033.GA30496@one.firstfloor.org>
User-Agent: Mutt/1.4.2.2i
From: Akinobu Mita <akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 22, 2007 at 12:10:33AM +0200, Andi Kleen wrote:
> > unwind code to even attempt to avoid the problem what should be done?
> > How about:
> > 
> > (1) Make it clear the Fault Injection with STACKTRACE on x86_64 is at
> > best "Russian Roulette" -- maybe a !X86_64 in Kconfig.debug?
> > 
> > (2) Introduce FRAME_POINTER support back into the x86_64 code.  This is
> > what Fault Injection really wants.
> > 
> > (3) Keep the saved stack address entries array out of sight of the
> > fallback save_stack_trace() code.  Lockdep does this by storing it in
> > static space but this requires locking which would be ugly for Fault
> > Injection.  Another option is to mask the saved addresses so they fail
> > the __kernel_text_address() test but fail_stacktrace() uses the same
> > mask to make it's comparisons.  There's still the problem of avoiding
> > kernel text addresses stored on the stack by other code (that is, other
> > than the expected stack chain uses).
> 
> Some hack in (3) would be probably best, otherwise (1).
> At some point I hope we can get the dwarf2 unwinder back, then
> the problem should be also solved. But then you would need to force
> the dwarf2 unwinder with fault injection on, but that shouldn't
> be a problem.

I'm goint to send the patch that disables stacktrace filter
(CONFIG_FAULT_INJECTION_STACKTRACE_FILTER) on x86_64.

But dwarf2 unwinder is still available on -mm. So I'll
send -mm only patch that enables it at the same time.

BTW, are there any pending issues in dwarf2 unwinder?

