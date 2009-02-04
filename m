Return-Path: <linux-kernel-owner+w=401wt.eu-S1757248AbZBDX15@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757248AbZBDX15 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 18:27:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752458AbZBDX1s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 18:27:48 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:52855 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752127AbZBDX1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 18:27:47 -0500
X-AuthUser: davidel@xmailserver.org
Date: Wed, 4 Feb 2009 15:27:45 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Michael Kerrisk <mtk.manpages@gmail.com>, linux-api@vger.kernel.org
Subject: Re: [patch/rfc] eventfd semaphore-like behavior
In-Reply-To: <20090204152434.c8f65d52.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.1.10.0902041526590.6214@alien.or.mcafeemobile.com>
References: <alpine.DEB.1.10.0902041349180.6214@alien.or.mcafeemobile.com> <20090204150507.665b5b7c.akpm@linux-foundation.org> <alpine.DEB.1.10.0902041509060.6214@alien.or.mcafeemobile.com> <20090204152434.c8f65d52.akpm@linux-foundation.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Feb 2009, Andrew Morton wrote:

> On Wed, 4 Feb 2009 15:18:43 -0800 (PST)
> Davide Libenzi <davidel@xmailserver.org> wrote:
> 
> > > > Simple test here:
> > > > 
> > > > http://www.xmailserver.org/eventfd-sem.c
> > > > 
> > > > 
> > > > Signed-off-by: Davide Libenzi <davidel@xmailserver.org>
> > > > 
> > > > +/*
> > > > + * CAREFUL: Check include/asm-generic/fcntl.h when defining
> > > > + * new flags, since they might collide with O_* ones. We want
> > > > + * to re-use O_* flags that couldn't possibly have a meaning
> > > > + * from eventfd, in order to leave a free define-space for
> > > > + * shared O_* flags.
> > > > + */
> > > > +#define EFD_SEMAPHORE (1 << 0)
> > > >  #define EFD_CLOEXEC O_CLOEXEC
> > > >  #define EFD_NONBLOCK O_NONBLOCK
> > > >  
> > > > +#define EFD_SHARED_FCNTL_FLAGS (O_CLOEXEC | O_NONBLOCK)
> > > > +#define EFD_FLAGS_SET (EFD_SHARED_FCNTL_FLAGS | EFD_SEMAPHORE)
> > > 
> > > How would you recommend that userspace determine whether its kernel
> > > supports this feature, bearing in mind that someone might backport this
> > > patch into arbitrarily earlier kernel versions?
> > > 
> > > What should be userspace's fallback strategy if that support is not
> > > present?
> > 
> > #ifdef EFD_SEMAPHORE, maybe?
> 
> That's compile-time.  People who ship binaries will probably want
> to find a runtime thing for back-compatibility.

I dunno. How do they actually do when we add new flags, like the O_ ones?



- Davide


