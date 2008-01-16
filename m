Return-Path: <linux-kernel-owner+w=401wt.eu-S1757947AbYAPW25@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757947AbYAPW25 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 17:28:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754304AbYAPWSt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 17:18:49 -0500
Received: from saeurebad.de ([85.214.36.134]:36447 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755673AbYAPWSs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 17:18:48 -0500
From: Johannes Weiner <hannes@saeurebad.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, clameter@sgi.com,
       penberg@cs.helsinki.fi
Subject: Re: Why is the kfree() argument const?
References: <87lk6pvii0.fsf@saeurebad.de>
	<alpine.LFD.1.00.0801161026550.2806@woody.linux-foundation.org>
Date: Wed, 16 Jan 2008 23:19:46 +0100
In-Reply-To: <alpine.LFD.1.00.0801161026550.2806@woody.linux-foundation.org>
	(Linus Torvalds's message of "Wed, 16 Jan 2008 10:39:00 -0800 (PST)")
Message-ID: <87odblct19.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Linus Torvalds <torvalds@linux-foundation.org> writes:

[...]

> "const" is a pointer type issue, and is meant to make certain mis-uses 
> more visible at compile time. It has *no* other meaning, and anybody who 
> thinks it has is just setting himself up for problems.

[...]

>  - From a very obvious and very *real* caller perspective, "free()" really 
>    doesn't change the thing the pointer points to. It does something 
>    totally different: it makes the *pointer* itself invalid.
>
>    In other words, if you think that "kfree()" changed the thing you 
>    free'd, you're simply wrong. It did no such thing. The memory is 100% 
>    the same, it's just that you cannot access it any more, and if you try, 
>    you'll get somebody elses memory.
>
>    In other words, "kfree()" can be const.

[...]

> So never believe that "const" is some guarantee that the memory under the 
> pointer doesn't change.  That is *never* true. It has never been true in 
> C, since there can be arbitrary pointer aliases to that memory that aren't 
> actually const. If you think "const *p" means that the memory behind "p" 
> is immutable, you're simply wrong.

Okay, I understood that now.  A const qualifier just forbids modifying
the underlying memory _through this particular pointer_, right?

In the case of slub's kfree(), which takes a const pointer, you pass it
on to slab_free() which actually _DOES_ modification of the underlying
memory when linking the object to the freelist (as far as I understood
the code).

So if I got it right and you actually modify the memory you only got a
const pointer to, you reach a level where you _have to_ break this
policy and cast to a non-const pointer, as it is currently done in
kfree().  No?

	Hannes
