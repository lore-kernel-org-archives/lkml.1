Return-Path: <linux-kernel-owner+w=401wt.eu-S1753206AbZA0Xn6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753206AbZA0Xn6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 18:43:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751500AbZA0Xnu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 18:43:50 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41354 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751095AbZA0Xnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 18:43:49 -0500
Date: Tue, 27 Jan 2009 15:43:29 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>,
       Jaswinder Singh Rajput <jaswinderrajput@gmail.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [mingo@elte.hu: [git pull] headers_check fixes]
In-Reply-To: <20090127233159.GA26403@elte.hu>
Message-ID: <alpine.LFD.2.00.0901271539090.3123@localhost.localdomain>
References: <20090127222825.GA27097@elte.hu> <alpine.LFD.2.00.0901271441280.3123@localhost.localdomain> <20090127233159.GA26403@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 28 Jan 2009, Ingo Molnar wrote:
> 
> It would be much better if we exported _much_ less and reduced our 
> cross-section to user-space. Also, the include/linux/Kbuild rules are all 
> but transparent: it would also be nice if whatever we exported was be 
> visible straight in the header itself, to make it obvious to people who 
> modify/extend those files that those definitions are going to be exported 
> to user-space.
> 
> Some __user_export tag on structures perhaps? I have no good ideas here - 
> #ifdefs are ugly and tags obscure the purity of the code.

I agree, and we probably could do so with some sparse extension (just make 
the rule be that in order to make a __user pointer, the base type needs to 
have been tagged with __user_visible). So we _could_ do something like 
that, and have a sane checking model where sparse would warn if it sees a 
user pointer of something that wasn't marked as being a user-visible type.

But I doubt it's really worth it. A lot of the usage cases for users end 
up being about constants etc that we really can't check sanely and 
automatically. And some historical user-space usage is literally just 
about user space finding the kernel headers really helpful (ie using the 
list.h headers for user-space lists, or the inline asms for atomic stuff 
for threaded apps that don't rely on ptrace locking).

		Linus
