Return-Path: <linux-kernel-owner+w=401wt.eu-S1757077AbYBKPxX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757077AbYBKPxX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 10:53:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754815AbYBKPxQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 10:53:16 -0500
Received: from mx2.suse.de ([195.135.220.15]:45850 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754540AbYBKPxP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 10:53:15 -0500
Date: Mon, 11 Feb 2008 07:45:12 -0800
From: Greg KH <gregkh@suse.de>
To: Matthew Keenan <matt@opcode-solutions.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Re: Linux 2.6.22.18
Message-ID: <20080211154512.GA26178@suse.de>
References: <20080211074313.GA23195@kroah.com> <20080211074346.GB23195@kroah.com> <1202729485.24584.5.camel@bazbox.opcode-solutions.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1202729485.24584.5.camel@bazbox.opcode-solutions.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 11, 2008 at 11:31:25AM +0000, Matthew Keenan wrote:
> 
> On Sun, 2008-02-10 at 23:43 -0800, Greg Kroah-Hartman wrote:
> > diff --git a/Makefile b/Makefile
> > index 6a949eb..99c5e87 100644
> > --- a/Makefile
> > +++ b/Makefile
> > @@ -1,7 +1,7 @@
> >  VERSION = 2
> >  PATCHLEVEL = 6
> >  SUBLEVEL = 22
> > -EXTRAVERSION = .17
> > +EXTRAVERSION = .18
> >  NAME = Holy Dancing Manatees, Batman!
> >  
> >  # *DOCUMENTATION*
> > diff --git a/fs/splice.c b/fs/splice.c
> > index e263d3b..dbbe267 100644
> > --- a/fs/splice.c
> > +++ b/fs/splice.c
> > @@ -1182,6 +1182,9 @@ static int get_iovec_page_array(const struct iovec __user *iov,
> >  		if (unlikely(!base))
> >  			break;
> >  
> > +		if (!access_ok(VERIFY_READ, base, len))
> > +			break;
> > +
> >  		/*
> >  		 * Get this base offset and number of pages, then map
> >  		 * in the user pages.
> 
> Maybe I'm missing something here, but is there are reason that the patch
> for 2.6.22 differs from 2.6.2[34]? The "if(unlikely(!base))" is removed
> in the latter.

the logic is a little different in 2.6.22 and earlier in regards to this
area of code.  This way we are safer.

thanks,

greg k-h
