Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755644Ab0BOQva (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 11:51:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9021 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755119Ab0BOQv3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 11:51:29 -0500
Date: Mon, 15 Feb 2010 17:50:12 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: x86: get rid of the insane TIF_ABI_PENDING bit
Message-ID: <20100215165012.GA20447@redhat.com>
References: <20100215161752.GA19962@redhat.com> <4B7974F7.1030105@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B7974F7.1030105@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/15, H. Peter Anvin wrote:
>
> On 02/15/2010 08:17 AM, Oleg Nesterov wrote:
> >
> >> +void set_personality_ia32(void)
> >> +{
> >> +	/* inherit personality from parent */
> >> +
> >> +	/* Make sure to be in 32bit mode */
> >> +	set_thread_flag(TIF_IA32);
> >> +
> >> +	/* Prepare the first "return" to user space */
> >> +	current_thread_info()->status |= TS_COMPAT;
> >
> > Can't understand why we need TS_COMPAT. I assume this is correct,
> > this was copied from flush_thread().
> >
> > What TS_COMPAT actually means? I thought it just means "the task
> > is inside 32-bit syscall".
>
> Yes.  In this case, though, it was a 64-bit syscall when the process did
> the exec, but it needs to "return" as if it came from a 32-bit syscall;

Could you please point me where do we check TS_COMPAT during return
to user-mode?

> > If a 64bit task execs a 32bit app, can't this TS_COMPAT break, say,
> > syscall_get_arguments() ?
> >
>
> At that point (this is after the exec!) we don't get arguments anyway.

I meant /proc/pid/syscall, but even if I am right this probably
doesn't matter.

Oleg.

