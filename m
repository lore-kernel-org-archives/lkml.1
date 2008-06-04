Return-Path: <linux-kernel-owner+w=401wt.eu-S1760702AbYFDOvn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760702AbYFDOvn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 10:51:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753870AbYFDOvd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 10:51:33 -0400
Received: from styx.suse.cz ([82.119.242.94]:43935 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751129AbYFDOvc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 10:51:32 -0400
Date: Wed, 4 Jun 2008 16:51:30 +0200
From: Jan Kara <jack@suse.cz>
To: Adrian Bunk <bunk@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] quota: Split out quota_struct.h out of quota.h
Message-ID: <20080604145130.GC16572@duck.suse.cz>
References: <12124266712214-git-send-email-jack@suse.cz> <12124266711334-git-send-email-jack@suse.cz> <12124266712838-git-send-email-jack@suse.cz> <12124266722979-git-send-email-jack@suse.cz> <12124266723968-git-send-email-jack@suse.cz> <12124266721420-git-send-email-jack@suse.cz> <20080604135624.GA13683@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080604135624.GA13683@cs181133002.pp.htv.fi>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 04-06-08 16:56:24, Adrian Bunk wrote:
> On Mon, Jun 02, 2008 at 07:11:10PM +0200, Jan Kara wrote:
> > Split some structure definitions from quota.h to quota_struct.h so that they
> > can be separately included in fs.h. This makes it possible to declare some
> > useful inline functions in quota.h because it can now include fs.h.
> > 
> > Signed-off-by: Jan Kara <jack@suse.cz>
> > ---
> >  include/linux/fs.h       |    2 +-
> >  include/linux/quota.h    |  193 +---------------------------------------------
> >  include/linux/quotaops.h |    1 +
> >  include/linux/syscalls.h |    2 +-
> >  4 files changed, 5 insertions(+), 193 deletions(-)
> >...
> 
> Missing "git-add include/linux/quota_struct.h" ?
  Probably yes, I already noticed this and mailed Andrew a patch with this
file included.

> > --- a/include/linux/quota.h
> > +++ b/include/linux/quota.h
> > @@ -37,13 +37,11 @@
> >  
> >  #include <linux/errno.h>
> >  #include <linux/types.h>
> > +#include <linux/quota_struct.h>
> >...
> 
> This breaks our userspace headers.
> 
> Please always run "make headers_check" after touching #include's
> under include/
  I didn't know this existed :) I'll use it in future. Thanks. The question
is how to fix this. Probably the best would be if didn't have to export new
header file, wouldn't it? We can split the headers into quota.h containing
structures and all other userspace stuff and quota_func.h carrying other
kernel-internal stuff like inline functions etc. Oh well...

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
