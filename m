Return-Path: <linux-kernel-owner+w=401wt.eu-S1756866AbXJaLqk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756866AbXJaLqk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 07:46:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754427AbXJaLqc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 07:46:32 -0400
Received: from mx1.redhat.com ([66.187.233.31]:32807 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753709AbXJaLqb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 07:46:31 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <b1c6420f0710301703n5c330ae2idb75c9a5703d5e7c@mail.gmail.com>
References: <b1c6420f0710301703n5c330ae2idb75c9a5703d5e7c@mail.gmail.com> <20071029122759.2846.83510.stgit@warthog.procyon.org.uk> <20071029122809.2846.58795.stgit@warthog.procyon.org.uk> <b1c6420f0710300740t5c708933x7ab1716c76504c57@mail.gmail.com> <20112.1193774645@redhat.com>
To: "Suzuki Takashi" <suzuki.takashi@gmail.com>
Cc: dhowells@redhat.com, torvalds@osdl.org, akpm@linux-foundation.org,
       linux-am33-list@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [Linux-am33-list] [PATCH 2/2] MN10300: Add the MN10300/AM33 architecture to the kernel [try #2]
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Wed, 31 Oct 2007 11:46:26 +0000
Message-ID: <13581.1193831186@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Suzuki Takashi <suzuki.takashi@gmail.com> wrote:

> But people aren't, are they?

On the other hand, these particular header files are of interest to arch
maintainers.

If there are variances between CPUs that mandate different sets of registers
or different usage protocols for equivalent modules, then you will end up with
something you'll object to.

Anyway, I've discussed this with MEI, and they're willing for some flattening
to take place.  The problem is how much?  I could just move all the
cpu-am33v2/ files into the dir above, but what happens if an incompatible CPU
core is introduced?

> If cpu-am33v3/cpu-regs.h #includes cpu-am33v2/cpu-regs.h,
> people have to
> 1) open cpu-am33v3/cpu-regs.h,
> saying #include <asm/cpu-am33v2/cpu-regs.h> (and sigh).
> 2) open cpu-am33v2/cpu-regs.h.

It's an awkward situation, yes, but not one most people will be concerned
with.  There needs to be some way to multiplex alternate register sets.  The
main ways of doing that are:

 (1) #include hell

 (2) #ifdef hell

 (3) Both

Which do you prefer?

Besides, you should use emacs tags:-)

However, I'll concede that the various versions of AM33 processor should
perhaps be represented by the same CPU subdirectory (cpu-am33), using #ifdef
to add extra features.  However, should, say, an AM34 be produced that's
effectively a variant of the AM33, then that scheme falls down too.

> This decreases development efficiency.

Like I said, it'll make very little difference to most people because few
people go poking around in the arch code.

> It is not too late to split into directories

It is already split up into directories.

> And at that time asm/cpu-regs.h should #include cpu/cpu-regs.h and
> people would #include asm/cpu-regs.h for the general purpose so that
> they aren't confused which is cpu-specific and which is proc-specific.

I'm confused as to what you're talking about.  asm/cpu-regs.h would not for
general purpose at all.  It would be an arch specific header file and should
not be used by code outside of the arch.

And if all asm/cpu-regs.h does is #include asm/cpu/cpu-regs.h, then what's the
point in having it?

> > > Stranger names here.
> >
> > How so?
> 
> The file is under cpu/, but the names are mn103e010_* which is proc-specific.

Good point.  That bears moving then.

David
