Return-Path: <linux-kernel-owner+w=401wt.eu-S1757463AbYEBBN0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757463AbYEBBN0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 21:13:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758802AbYEBBNE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 21:13:04 -0400
Received: from sous-sol.org ([216.99.217.87]:42103 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758719AbYEBBND (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 21:13:03 -0400
Date: Thu, 1 May 2008 18:12:43 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Josselin Mouette <joss@debian.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Increase the default RLIMIT_MEMLOCK
Message-ID: <20080502011233.GB4018@sequoia.sous-sol.org>
References: <1209324387.4203.22.camel@shizuru> <20080501175037.01d8d3dc.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080501175037.01d8d3dc.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Andrew Morton (akpm@linux-foundation.org) wrote:
> > --- include/linux/resource.h.orig	2008-04-27 21:15:47.000000000 +0200
> > +++ include/linux/resource.h	2008-04-27 21:23:06.000000000 +0200
> > @@ -58,10 +58,11 @@
> >  #define _STK_LIM	(8*1024*1024)
> >  
> >  /*
> > - * GPG wants 32kB of mlocked memory, to make sure pass phrases
> > - * and other sensitive information are never written to disk.
> > + * The biggest widespread mlocked memory consumer is 
> > + * gnome-keyring-manager. It needs 256kB to make sure SSH/GPG 
> > + * passphrases and network passwords are never written to disk.
> >   */
> > -#define MLOCK_LIMIT	(8 * PAGE_SIZE)
> > +#define MLOCK_LIMIT	(64 * PAGE_SIZE)
> 
> gee, it seems rather arbitrary.  Perhaps we should have set it to zero on
> day one to _force_ distributors to set an appropriate RLIMIT_MEMLOCK in
> init.

Yes, it is fairly arbitrary.  The motivation was gpg, but in fact when
the patchset started gpg had already changed from 1 page to 8 pages.

http://thread.gmane.org/gmane.linux.kernel/222613/focus=222681

> We can do this of course, but does it actually help anything?  Perhaps it's
> actually a bad thing, permitting userspace developers to rely upon kernel
> defaults rather than setting things they way they should be set?

We don't want to keep changing at whim of random apps, agreed.  Feels
like a distro issue, since kernel can't even know what apps might run,
and using 8 pages was just a courtesy hint to distros.

thanks,
-chris
