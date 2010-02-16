Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932680Ab0BPPll (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 10:41:41 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38792 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932265Ab0BPPlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 10:41:39 -0500
Date: Tue, 16 Feb 2010 07:40:35 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Oleg Nesterov <oleg@redhat.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] x86: set_personality_ia32() abuses TS_COMPAT
In-Reply-To: <20100216140242.GC16448@redhat.com>
Message-ID: <alpine.LFD.2.00.1002160738530.18830@localhost.localdomain>
References: <20100215161752.GA19962@redhat.com> <4B799C3F.7010308@zytor.com> <20100215194123.96D49FC3@magilla.sf.frob.com> <4B79B202.5090006@zytor.com> <20100216101903.GA1057@redhat.com> <20100216102332.GL21783@one.firstfloor.org> <20100216140126.GA16448@redhat.com>
 <20100216140242.GC16448@redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 16 Feb 2010, Oleg Nesterov wrote:
> 
> In fact I'd say this is not right, but fortunetely do_execve() can
> never return something which could confuse syscall_get_error().
> And apart from do_signal() we never check TS_COMPAT during return
> to user-mode.

But 'do_signal()' _can_ happen the first thing after an execve(), no?

And after we have switched to 32-bit mode, we _are_ inside a 32-bit system 
call: the execve has "changed" from a 64-bit one to a 32-bit one.

So I really don't understand why you dislike TS_COMPAT here.

I understand not liking TS_COMPAT in the first place (it would be nice to 
not have that flag at all), but considering that it exists, and it is 
supposed to be set while in 32-bit system calls, setting it on a 32-bit 
execve() seems to be the RightThing(tm) to do.

		Linus
