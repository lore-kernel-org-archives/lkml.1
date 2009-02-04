Return-Path: <linux-kernel-owner+w=401wt.eu-S1759723AbZBDXzp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759723AbZBDXzp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 18:55:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755932AbZBDXzg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 18:55:36 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52274 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754752AbZBDXzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 18:55:35 -0500
Date: Wed, 4 Feb 2009 15:55:14 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       mtk.manpages@gmail.com, linux-api@vger.kernel.org
Subject: Re: [patch/rfc] eventfd semaphore-like behavior
Message-Id: <20090204155514.6abbdc8f.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.1.10.0902041526590.6214@alien.or.mcafeemobile.com>
References: <alpine.DEB.1.10.0902041349180.6214@alien.or.mcafeemobile.com>
	<20090204150507.665b5b7c.akpm@linux-foundation.org>
	<alpine.DEB.1.10.0902041509060.6214@alien.or.mcafeemobile.com>
	<20090204152434.c8f65d52.akpm@linux-foundation.org>
	<alpine.DEB.1.10.0902041526590.6214@alien.or.mcafeemobile.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Feb 2009 15:27:45 -0800 (PST)
Davide Libenzi <davidel@xmailserver.org> wrote:

> On Wed, 4 Feb 2009, Andrew Morton wrote:
> 
> > On Wed, 4 Feb 2009 15:18:43 -0800 (PST)
> > Davide Libenzi <davidel@xmailserver.org> wrote:
> > 
> > > > > Simple test here:
> > > > > 
> > > > > http://www.xmailserver.org/eventfd-sem.c
> > > > > 
> > > > > 
> > > > > Signed-off-by: Davide Libenzi <davidel@xmailserver.org>
> > > > > 
> > > > > +/*
> > > > > + * CAREFUL: Check include/asm-generic/fcntl.h when defining
> > > > > + * new flags, since they might collide with O_* ones. We want
> > > > > + * to re-use O_* flags that couldn't possibly have a meaning
> > > > > + * from eventfd, in order to leave a free define-space for
> > > > > + * shared O_* flags.
> > > > > + */
> > > > > +#define EFD_SEMAPHORE (1 << 0)
> > > > >  #define EFD_CLOEXEC O_CLOEXEC
> > > > >  #define EFD_NONBLOCK O_NONBLOCK
> > > > >  
> > > > > +#define EFD_SHARED_FCNTL_FLAGS (O_CLOEXEC | O_NONBLOCK)
> > > > > +#define EFD_FLAGS_SET (EFD_SHARED_FCNTL_FLAGS | EFD_SEMAPHORE)
> > > > 
> > > > How would you recommend that userspace determine whether its kernel
> > > > supports this feature, bearing in mind that someone might backport this
> > > > patch into arbitrarily earlier kernel versions?
> > > > 
> > > > What should be userspace's fallback strategy if that support is not
> > > > present?
> > > 
> > > #ifdef EFD_SEMAPHORE, maybe?
> > 
> > That's compile-time.  People who ship binaries will probably want
> > to find a runtime thing for back-compatibility.
> 
> I dunno. How do they actually do when we add new flags, like the O_ ones?
> 

Dunno.  Probably try the syscall and see if it returned -EINVAL.  Does
that work in this case?  If so, it would be sensible to mention this in
the description somewhere as the approved probing method and to
maintain it.


