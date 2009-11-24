Return-Path: <linux-kernel-owner+w=401wt.eu-S934088AbZKXV0P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934088AbZKXV0P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 16:26:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933497AbZKXV0O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 16:26:14 -0500
Received: from one.firstfloor.org ([213.235.205.2]:38784 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933487AbZKXV0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 16:26:13 -0500
Date: Tue, 24 Nov 2009 22:26:19 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, Alexey Dobriyan <adobriyan@gmail.com>,
       Ananth Mavinakayanahalli <ananth@in.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, Ingo@firstfloor.org,
       "Molnar <mingo"@firstfloor.org, utrace-devel@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC,PATCH 14/14] utrace core
Message-ID: <20091124212619.GB29096@one.firstfloor.org>
References: <20091124200220.GA5828@redhat.com> <87my2bwtno.fsf@basil.nowhere.org> <20091124204152.GA9131@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091124204152.GA9131@redhat.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 24, 2009 at 09:41:52PM +0100, Oleg Nesterov wrote:
> On 11/24, Andi Kleen wrote:
> >
> > Oleg Nesterov <oleg@redhat.com> writes:
> >
> > > From: Roland McGrath <roland@redhat.com>
> > >
> > > This adds the utrace facility, a new modular interface in the kernel
> > > for implementing user thread tracing and debugging.  This fits on top
> > > of the tracehook_* layer, so the new code is well-isolated.
> >
> > Could we just drop the tracehook layer if this finally merged
> > and call the low level functions directly?
> 
> Not sure I understand. Tracehooks are trivial inline wrappers on
> top utrace calls,

Yes that's the problem -- they are unnecessary obfuscation
when you can just call directly.

> 
> > It might have been reasonably early on when it was still out of tree,
> > but longer term when it's integrated having strange opaque hooks
> > like that just makes the coder harder to read and maintain.
> 
> Well, I don't think the code will be better if we remove tracehooks.
> 
> For example. tracehook_report_syscall_entry() has a lot of callers
> in arch/, each callsite should be changed to do
> 
> 	if ((task_utrace_flags(current) & UTRACE_EVENT(SYSCALL_ENTRY)) &&
> 		utrace_report_syscall_entry(regs))
> 		ret = -1; // this depends on machine
> 
> instead of simply calling tracehook_report_syscall_entry().

That should be in the utrace code?

I don't have a problem with having common code somewhere,
just not a whole layer whose only purpose seems to be obfuscation.


> What is the point?

Less code obfuscation.

When it's a utrace call, call it a utrace call, not something else.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
