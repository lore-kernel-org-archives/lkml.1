Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932844Ab0BPRRQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 12:17:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62778 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932304Ab0BPRRO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 12:17:14 -0500
Date: Tue, 16 Feb 2010 18:16:14 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] x86: set_personality_ia32() abuses TS_COMPAT
Message-ID: <20100216171614.GA23503@redhat.com>
References: <20100215161752.GA19962@redhat.com> <4B799C3F.7010308@zytor.com> <20100215194123.96D49FC3@magilla.sf.frob.com> <4B79B202.5090006@zytor.com> <20100216101903.GA1057@redhat.com> <20100216102332.GL21783@one.firstfloor.org> <20100216140126.GA16448@redhat.com> <20100216140242.GC16448@redhat.com> <alpine.LFD.2.00.1002160738530.18830@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1002160738530.18830@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/16, Linus Torvalds wrote:
>
> On Tue, 16 Feb 2010, Oleg Nesterov wrote:
> >
> > In fact I'd say this is not right, but fortunetely do_execve() can
> > never return something which could confuse syscall_get_error().
> > And apart from do_signal() we never check TS_COMPAT during return
> > to user-mode.
>
> But 'do_signal()' _can_ happen the first thing after an execve(), no?

this is what I meant,

> And after we have switched to 32-bit mode, we _are_ inside a 32-bit system
> call: the execve has "changed" from a 64-bit one to a 32-bit one.

And this is what I do not understand, we are still in 64-bit execve.

With ot without TS_COMPAT we take the same return path and I can't
see why should we sign-extend ->ax. But I didn't claim this is wrong,
and it is possible I missed something.

> So I really don't understand why you dislike TS_COMPAT here.

The only reason I dislike TS_COMPAT is that I spent a lot of time
trying to understand the necessity to set it here when I tried to
understand the basics of compat issues.

> I understand not liking TS_COMPAT in the first place (it would be nice to
> not have that flag at all), but considering that it exists, and it is
> supposed to be set while in 32-bit system calls, setting it on a 32-bit
> execve() seems to be the RightThing(tm) to do.

OK, please ignore the patch then.

As I said, only the first patch probably makes sense, and even it
was not tested.



Cough. And since I already made a lot of noise...

Now that we always call setup_new_exec() which does
arch_pick_mmap_layout(), what is the point of
exec_mmap()->arch_pick_mmap_layout() ?

Oleg.

