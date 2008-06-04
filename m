Return-Path: <linux-kernel-owner+w=401wt.eu-S1761106AbYFDPiX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761106AbYFDPiX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 11:38:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754483AbYFDPiP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 11:38:15 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:33697 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751990AbYFDPiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 11:38:14 -0400
Subject: Re: [PATCH] quota: Split out quota_struct.h out of quota.h
From: David Woodhouse <dwmw2@infradead.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080604152647.GA4189@cs181133002.pp.htv.fi>
References: <12124266712214-git-send-email-jack@suse.cz>
	 <12124266711334-git-send-email-jack@suse.cz>
	 <12124266712838-git-send-email-jack@suse.cz>
	 <12124266722979-git-send-email-jack@suse.cz>
	 <12124266723968-git-send-email-jack@suse.cz>
	 <12124266721420-git-send-email-jack@suse.cz>
	 <20080604135624.GA13683@cs181133002.pp.htv.fi>
	 <20080604145130.GC16572@duck.suse.cz>
	 <20080604152647.GA4189@cs181133002.pp.htv.fi>
Content-Type: text/plain
Date: Wed, 04 Jun 2008 16:38:06 +0100
Message-Id: <1212593886.32207.119.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-06-04 at 18:26 +0300, Adrian Bunk wrote:
> On Wed, Jun 04, 2008 at 04:51:30PM +0200, Jan Kara wrote:
> > On Wed 04-06-08 16:56:24, Adrian Bunk wrote:
> > > On Mon, Jun 02, 2008 at 07:11:10PM +0200, Jan Kara wrote:
> >...
> > > > --- a/include/linux/quota.h
> > > > +++ b/include/linux/quota.h
> > > > @@ -37,13 +37,11 @@
> > > >  
> > > >  #include <linux/errno.h>
> > > >  #include <linux/types.h>
> > > > +#include <linux/quota_struct.h>
> > > >...
> > > 
> > > This breaks our userspace headers.
> > > 
> > > Please always run "make headers_check" after touching #include's
> > > under include/
> >   I didn't know this existed :) I'll use it in future. Thanks. The question
> > is how to fix this. Probably the best would be if didn't have to export new
> > header file, wouldn't it? We can split the headers into quota.h containing
> > structures and all other userspace stuff and quota_func.h carrying other
> > kernel-internal stuff like inline functions etc. Oh well...
> 
> Considering that quota.h #include's quota_struct.h it wouldn't be a 
> problem if the new header also gets exported to userspace.
> 
> At least I do not have any strong opinion regarding how to best organize 
> the quota headers - David (Cc'ed) might have a more input on this.

To a large extent it doesn't actually matter for userspace. 
All userspace will be using <sys/quota.h> instead, because for a very
long period in our history, <linux/quota.h> would be completely broken
for userspace because it would give the v1 quota stuff. I believe that
was because we were depending on some CONFIG_xxx definition, which
doesn't exist in userspace (we _really_ should add that to headers_check
some time).

That said, the patch looks OK as long as you remember to add the new
file to unifdef-y, and as long as you have #ifdef __KERNEL__ in the
correct places in it (I can't see the updated patch with the new file
actually included, so I haven't checked).

-- 
dwmw2

