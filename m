Return-Path: <linux-kernel-owner+w=401wt.eu-S1758975AbYFDP13@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758975AbYFDP13 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 11:27:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753170AbYFDP1U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 11:27:20 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:57968 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753124AbYFDP1T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 11:27:19 -0400
Date: Wed, 4 Jun 2008 18:26:47 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] quota: Split out quota_struct.h out of quota.h
Message-ID: <20080604152647.GA4189@cs181133002.pp.htv.fi>
References: <12124266712214-git-send-email-jack@suse.cz> <12124266711334-git-send-email-jack@suse.cz> <12124266712838-git-send-email-jack@suse.cz> <12124266722979-git-send-email-jack@suse.cz> <12124266723968-git-send-email-jack@suse.cz> <12124266721420-git-send-email-jack@suse.cz> <20080604135624.GA13683@cs181133002.pp.htv.fi> <20080604145130.GC16572@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080604145130.GC16572@duck.suse.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 04, 2008 at 04:51:30PM +0200, Jan Kara wrote:
> On Wed 04-06-08 16:56:24, Adrian Bunk wrote:
> > On Mon, Jun 02, 2008 at 07:11:10PM +0200, Jan Kara wrote:
>...
> > > --- a/include/linux/quota.h
> > > +++ b/include/linux/quota.h
> > > @@ -37,13 +37,11 @@
> > >  
> > >  #include <linux/errno.h>
> > >  #include <linux/types.h>
> > > +#include <linux/quota_struct.h>
> > >...
> > 
> > This breaks our userspace headers.
> > 
> > Please always run "make headers_check" after touching #include's
> > under include/
>   I didn't know this existed :) I'll use it in future. Thanks. The question
> is how to fix this. Probably the best would be if didn't have to export new
> header file, wouldn't it? We can split the headers into quota.h containing
> structures and all other userspace stuff and quota_func.h carrying other
> kernel-internal stuff like inline functions etc. Oh well...

Considering that quota.h #include's quota_struct.h it wouldn't be a 
problem if the new header also gets exported to userspace.

At least I do not have any strong opinion regarding how to best organize 
the quota headers - David (Cc'ed) might have a more input on this.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

