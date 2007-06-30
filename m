Return-Path: <linux-kernel-owner+w=401wt.eu-S1754987AbXF3W2Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754987AbXF3W2Q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2007 18:28:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752962AbXF3W2D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jun 2007 18:28:03 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:2411 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752751AbXF3W2B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2007 18:28:01 -0400
X-AuthUser: davidel@xmailserver.org
Date: Sat, 30 Jun 2007 15:27:58 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Ulrich Drepper <drepper@gmail.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 0/6] sys_indirect RFC - sys_indirect introduction
In-Reply-To: <a36005b50706301454j46c23760m5f0ac6088fe24a9d@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0706301458300.2957@alien.or.mcafeemobile.com>
References: <send-serie.davidel@xmailserver.org.28360.1183153732.0> 
 <a36005b50706291848p406fbb9aw99697f609b0d5c4b@mail.gmail.com> 
 <Pine.LNX.4.64.0706301208140.2957@alien.or.mcafeemobile.com>
 <a36005b50706301454j46c23760m5f0ac6088fe24a9d@mail.gmail.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 30 Jun 2007, Ulrich Drepper wrote:

> On 6/30/07, Davide Libenzi <davidel@xmailserver.org> wrote:
> > But, a __get_user(), once you scrap off all the gcc wrapping, is bacially
> > a move. That could even be removed, but really I don't see the reason
> > since it allows for a cleaner strcture definition in userland.
> 
> Don't generalize.  The 4G/4G kernel, for instance, doesn't have this
> property.  Who knows what else will come up.  Anyway, two memcpy are
> slower than one.
>
> > But this does not allow more than one context to be set at a time, like
> > the current implementation does. Ie, the current implementation allow you
> > to:
> 
> Of course it does.  It just requires an appropriate union element.
> I've listed flags and sigset_t as separate union elements since I
> cannot think of a place where we need both extensions.  Should there
> be one this can easily be changed.

Why do you want to stick everything inside a structure, with nested 
strctures and unions, when they clearly are separate contexts?
Also, unions don't work if you want to pass multiple contexts at a time.
You need your structure to contains *all* the possible contexts.
You do not want to sell the monster-struct-union by branding an extra 
__get_user(), do you?
On top of that, the single pointer to the compat multi-context strcture, 
will force the kernel to decide which one of the members is actually valid 
or not. The set/unset callbacks separate each context from a structure POV 
and from a setup/teardown POV, and allow the kernel to use their native 
data structures. Think about if we had this for the latest 
pselect/ppoll/epoll_pwait. Think about how your solution and mine would 
apply to that very much concrete case.




- Davide


