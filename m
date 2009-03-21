Return-Path: <linux-kernel-owner+w=401wt.eu-S1754460AbZCUIzu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754460AbZCUIzu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 04:55:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752698AbZCUIzl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 04:55:41 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49059 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752407AbZCUIzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 04:55:40 -0400
Date: Sat, 21 Mar 2009 01:49:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Roland McGrath <roland@redhat.com>
Cc: utrace-devel@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] utrace core
Message-Id: <20090321014909.6b654f55.akpm@linux-foundation.org>
In-Reply-To: <20090321014140.AA4F5FC3AB@magilla.sf.frob.com>
References: <20090321013946.890F4FC3AB@magilla.sf.frob.com>
	<20090321014140.AA4F5FC3AB@magilla.sf.frob.com>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Mar 2009 18:41:40 -0700 (PDT) Roland McGrath <roland@redhat.com> wrote:

> This adds the utrace facility, a new modular interface in the kernel for
> implementing user thread tracing and debugging.  This fits on top of the
> tracehook_* layer, so the new code is well-isolated.
> 
> The new interface is in <linux/utrace.h> and the DocBook utrace book
> describes it.  It allows for multiple separate tracing engines to work in
> parallel without interfering with each other.  Higher-level tracing
> facilities can be implemented as loadable kernel modules using this layer.
> 
> The new facility is made optional under CONFIG_UTRACE.
> When this is not enabled, no new code is added.
> It can only be enabled on machines that have all the
> prerequisites and select CONFIG_HAVE_ARCH_TRACEHOOK.
> 
> In this initial version, utrace and ptrace do not play together at all.
> If ptrace is attached to a thread, the attach calls in the utrace kernel
> API return -EBUSY.  If utrace is attached to a thread, the PTRACE_ATTACH
> or PTRACE_TRACEME request will return EBUSY to userland.  The old ptrace
> code is otherwise unchanged and nothing using ptrace should be affected
> by this patch as long as utrace is not used at the same time.  In the
> future we can clean up the ptrace implementation and rework it to use
> the utrace API.

I'd be interested in seeing a bit of discussion regarding the overall value
of utrace - it has been quite a while since it floated past.

I assume that redoing ptrace to be a client of utrace _will_ happen, and
that this is merely a cleanup exercise with no new user-visible features?

The "prototype utrace-ftrace interface" seems to be more a cool toy rather
than a serious new kernel feature (yes?)

If so, what are the new killer utrace clients which would justify all these
changes?



Also, is it still the case that RH are shipping utrace?  If so, for what
reasons and what benefits are users seeing from it?


And I recall that there were real problems wiring up the Feb 2007 version
of utrace to the ARM architecture.  Have those issues been resolved?  Are
any problems expected for any architectures?

Thanks.

