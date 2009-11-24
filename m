Return-Path: <linux-kernel-owner+w=401wt.eu-S933373AbZKXUrP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933373AbZKXUrP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 15:47:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933027AbZKXUrO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 15:47:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44518 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933025AbZKXUrN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 15:47:13 -0500
Date: Tue, 24 Nov 2009 21:41:52 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
       Ananth Mavinakayanahalli <ananth@in.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, Ingo@firstfloor.org,
       "Molnar <mingo"@firstfloor.org, utrace-devel@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC,PATCH 14/14] utrace core
Message-ID: <20091124204152.GA9131@redhat.com>
References: <20091124200220.GA5828@redhat.com> <87my2bwtno.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87my2bwtno.fsf@basil.nowhere.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/24, Andi Kleen wrote:
>
> Oleg Nesterov <oleg@redhat.com> writes:
>
> > From: Roland McGrath <roland@redhat.com>
> >
> > This adds the utrace facility, a new modular interface in the kernel
> > for implementing user thread tracing and debugging.  This fits on top
> > of the tracehook_* layer, so the new code is well-isolated.
>
> Could we just drop the tracehook layer if this finally merged
> and call the low level functions directly?

Not sure I understand. Tracehooks are trivial inline wrappers on
top utrace calls,

> It might have been reasonably early on when it was still out of tree,
> but longer term when it's integrated having strange opaque hooks
> like that just makes the coder harder to read and maintain.

Well, I don't think the code will be better if we remove tracehooks.

For example. tracehook_report_syscall_entry() has a lot of callers
in arch/, each callsite should be changed to do

	if ((task_utrace_flags(current) & UTRACE_EVENT(SYSCALL_ENTRY)) &&
		utrace_report_syscall_entry(regs))
		ret = -1; // this depends on machine

instead of simply calling tracehook_report_syscall_entry().

What is the point?

But again, perhaps I misunderstood you.

Oleg.

