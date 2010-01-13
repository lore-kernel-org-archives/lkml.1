Return-Path: <linux-kernel-owner+w=401wt.eu-S1755256Ab0AMJ3p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755256Ab0AMJ3p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 04:29:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755246Ab0AMJ3n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 04:29:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44616 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755244Ab0AMJ3m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 04:29:42 -0500
Date: Wed, 13 Jan 2010 11:28:49 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Chris Wright <chrisw@sous-sol.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       linux-api@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH v4][RESENT] add MAP_UNLOCKED mmap flag
Message-ID: <20100113092849.GS7549@redhat.com>
References: <20100112145144.GQ7549@redhat.com>
 <20100112232145.GA10576@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100112232145.GA10576@sequoia.sous-sol.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 12, 2010 at 03:21:45PM -0800, Chris Wright wrote:
> * Gleb Natapov (gleb@redhat.com) wrote:
> >  v3->v4
> >   - return error if MAP_LOCKED | MAP_UNLOCKED is specified
> ...
> > --- a/mm/mmap.c
> > +++ b/mm/mmap.c
> > @@ -962,6 +962,12 @@ unsigned long do_mmap_pgoff(struct file *file, unsigned long addr,
> >  		if (!can_do_mlock())
> >  			return -EPERM;
> >  
> > +        if (flags & MAP_UNLOCKED)
> > +                vm_flags &= ~VM_LOCKED;
> > +
> > +        if (flags & MAP_UNLOCKED)
> > +                vm_flags &= ~VM_LOCKED;
> > +
> >  	/* mlock MCL_FUTURE? */
> >  	if (vm_flags & VM_LOCKED) {
> >  		unsigned long locked, lock_limit;
> 
> Looks like same patch applied twice rather than adding the
> (MAP_LOCKED | MAP_UNLOCKED) check.
> 
Thanks Chris, will resend.

--
			Gleb.
