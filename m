Return-Path: <linux-kernel-owner+w=401wt.eu-S1752847Ab0APWMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752847Ab0APWMS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jan 2010 17:12:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752520Ab0APWMQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jan 2010 17:12:16 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:33518 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752762Ab0APWMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jan 2010 17:12:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=mPhgAYdG2oPmekZ6kRDP7czknngobQYXs/JNKBS2TIR0ejtz9DjQNzAnNYk14oKtE8
         iUa1/se2wstaTDRSetMy94+ioUCjWWdV5M1DIzpHvI5V1eDjDRpF89rQkSqwMyPhSNbP
         svqYtBTlC67cbA8KRu7fDYdW3MXKlmOuCOhTY=
Date: Sun, 17 Jan 2010 01:12:11 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ian Campbell <ijc@hellion.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] x86 fixes
Message-ID: <20100116221211.GC5725@lenovo>
References: <20100116170338.GA17175@elte.hu> <alpine.LFD.2.00.1001161233300.13231@localhost.localdomain> <20100116205342.GA5725@lenovo> <1263676617.14137.679.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1263676617.14137.679.camel@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 16, 2010 at 09:16:56PM +0000, Ian Campbell wrote:
...
> > |
> > | > Yeah, I didn't found any explicit %ss reloading for this _particular_
> > | > case (as I marked in patch changelog). So the only suspicious is Xen
> > | > itself. So as only Christian get ability to test -- we will see the
> > | > results.
> > |
> > | The difference with Xen is that it must squash the RPL of SS (to 3 for
> > | 64 bit and 1 for 32 bit, 32 bit doesn't matter here though). Perhaps a
> > | NULL selector can only have RPL==0? (I'm away from my architecture docs
> > | so I can't check). In any case specifying a non-NULL SS selector allows
> > | the squashing to occur correctly.
> > |
> >
> > In turn reported said that only _this_ patch alone doesn't help him and
> > Ian replied we need both patches.
> >
> > Ian CC'ed if details needed.
>
> Thanks, I think you've covered or quoted everything.
>
> Although I think Linus' basic point is still valid -- why isn't a valid
> SS needed for 32 bit? The selectors have real meaning there even for
> native, don't they?
>

Well, the point was (I suppose) why we've started to set SS selector here
at all. It's due to Xen. Old code was doing so, and that happened Xen is
relating on it (as you actually said).

Also this is kernel thread which is supposed to execute in kernel space.
And kernel itself already set SS selector when it needs. So to eliminate
redunant operations we don't set SS here. And if there was not such
issue on a Xen side -- we would not set SS here as well.

Again, to be fair I just don't have rights to blame Xen here -- I rely on your
and Christian reports only.

> (I'm travelling all tomorrow and unlikely to be getting mail).
>
> Ian.
>

	-- Cyrill
