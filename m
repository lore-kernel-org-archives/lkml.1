Return-Path: <linux-kernel-owner+w=401wt.eu-S1752259AbYBJOAr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752259AbYBJOAr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 09:00:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750902AbYBJOAh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 09:00:37 -0500
Received: from fk-out-0910.google.com ([209.85.128.191]:49089 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968AbYBJOAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 09:00:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=TvkhDdzL0C9guoHkSuNa/Sx4LSFq+mOaoSnihZLQEajZ/clP+fhUVgIbg9ORdBUDyGBoQ5+jNO4D0Z8VHM6mLpu2IOsiDdx7z1oY8aY9s9Mfdz1eiKsMkElS6Oc9mlrRdYReDQdIIyOLFx4u3i5RfnyejUwwyIszWOmFlv843eU=
Date: Sun, 10 Feb 2008 15:00:00 +0100
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Jesper Juhl <jesper.juhl@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Jason Wessel <jason.wessel@windriver.com>
Subject: Re: [3/6] kgdb: core
Message-ID: <20080210135955.GA12881@joi>
References: <20080210071331.GC3851@elte.hu> <20080210124629.GA12200@joi> <9a8748490802100519h5921ce61pd90d6bec604b5c87@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9a8748490802100519h5921ce61pd90d6bec604b5c87@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 10, 2008 at 02:19:06PM +0100, Jesper Juhl wrote:
> On 10/02/2008, Marcin Slusarz <marcin.slusarz@gmail.com> wrote:
> > On Sun, Feb 10, 2008 at 08:13:31AM +0100, Ingo Molnar wrote:
> ...
> > > +
> > > +             if (CACHE_FLUSH_IS_SAFE) {
> > > +                     if (current->mm && addr < TASK_SIZE) {
> > > +                             flush_cache_range(current->mm->mmap_cache,
> > > +                                             addr, addr + BREAK_INSTR_SIZE);
> > > +                     } else {
> > > +                             flush_icache_range(addr, addr +
> > > +                                             BREAK_INSTR_SIZE);
> > > +                     }
> > > +             }
> > unneeded braces (here and in many other places)
> >
> 
> While they are not strictly needed, I for one would argue they should
> probably stay.
> 
> if (foo)
>   bar();
> 
> is not always safe in case bar() is a macro.
then fix this broken macro and leave calling code alone

> is always safe and is more robust when the code gets changed later
> since you don't accidentally end up with someone mistakenly turning it
> into
> 
> if (foo)
>   bar();
>   baz();
following coding style and reading code before submission will
catch this kind of bugs

Marcin
