Return-Path: <linux-kernel-owner+w=401wt.eu-S1758006AbXGBWhX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758006AbXGBWhX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 18:37:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755100AbXGBWhH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 18:37:07 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:3863 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754957AbXGBWhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 18:37:05 -0400
X-AuthUser: davidel@xmailserver.org
Date: Mon, 2 Jul 2007 15:37:01 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Ulrich Drepper <drepper@gmail.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 0/6] sys_indirect RFC - sys_indirect introduction
In-Reply-To: <a36005b50707020709s87bde71m325a4ced02eb6e2b@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0707021119460.14774@alien.or.mcafeemobile.com>
References: <send-serie.davidel@xmailserver.org.28360.1183153732.0> 
 <a36005b50706291848p406fbb9aw99697f609b0d5c4b@mail.gmail.com> 
 <Pine.LNX.4.64.0706301208140.2957@alien.or.mcafeemobile.com> 
 <a36005b50706301454j46c23760m5f0ac6088fe24a9d@mail.gmail.com> 
 <Pine.LNX.4.64.0706301458300.2957@alien.or.mcafeemobile.com> 
 <Pine.LNX.4.64.0706301529310.2957@alien.or.mcafeemobile.com> 
 <a36005b50707010925k5c936c1ch2238b560c595a833@mail.gmail.com> 
 <Pine.LNX.4.64.0707011003510.7547@alien.or.mcafeemobile.com>
 <a36005b50707020709s87bde71m325a4ced02eb6e2b@mail.gmail.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Jul 2007, Ulrich Drepper wrote:

> On 7/1/07, Davide Libenzi <davidel@xmailserver.org> wrote:
> > With the current API design you'd able to easily confine the "pre" code
> > inside the "set" function, and the "post" code inside the "unset"
> > function. It looks pretty clean to me, and allows to limit the knowledge
> > of sys_indirect, the more as possible inside kernel/indirect.c.
> 
> But this will not be applicable.  We already discussed that each
> syscall likely needs its own set of flags etc.  There really isn't
> much overlap if any which cannot be handled at least as well using a
> flat structure.  You're adding major complications for something which
> IMO will never be usable.  With the flat structure to whole overhead
> of sys_indirect is limited to a test for valid syscalls, copying the
> struct, making the call to the syscall function, and resetting the
> value in current.  Very simple and fast.

Never be usable? I made you a concrete example that is like 8 months old. 
And *that* could not have been cleanly handled with the flat structure 
idea.
The extra flags parameter is one example where we'd need an extra flags 
field in the task_struct in any case. So you need in any case code that 
does extra checks and merges normal parameters/flags with the shared 
context ones. This independently of the method used. But there are 
examples (and the signal stuff is one of them), where you do need the 
set_context+syscall+unset_context abstraction, for all cases where the 
kernel already has its own internal data strctures. In those cases you'd 
have to spread sys_internal context knowledge all around the kernel, 
whereas the current solution allows you to confine the code inside 
kernel/indirect.c (through the set/unset abstraction). And this w/out even 
try to hit the weak spot of about how this structure will look after a few 
additions.



- Davide


