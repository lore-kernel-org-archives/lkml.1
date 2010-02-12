Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756948Ab0BLPgE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 10:36:04 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54403 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756320Ab0BLPgA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 10:36:00 -0500
Date: Fri, 12 Feb 2010 07:19:54 -0800
From: Greg KH <gregkh@suse.de>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>, kay.sievers@vrfy.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2] class: Free the class private data in class_release
Message-ID: <20100212151954.GA944@suse.de>
References: <1265801743-26079-1-git-send-email-laurent.pinchart@ideasonboard.com> <1265805169-31315-1-git-send-email-laurent.pinchart@ideasonboard.com> <1265959018.26471.5.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1265959018.26471.5.camel@localhost>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 12, 2010 at 09:16:58AM +0200, Artem Bityutskiy wrote:
> On Wed, 2010-02-10 at 13:32 +0100, Laurent Pinchart wrote:
> > Fix a memory leak by freeing the memory allocated in __class_register
> > for the class private data.
> > 
> > Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > ---
> >  drivers/base/class.c |    2 ++
> >  1 files changed, 2 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/base/class.c b/drivers/base/class.c
> > index 161746d..6e2c3b0 100644
> > --- a/drivers/base/class.c
> > +++ b/drivers/base/class.c
> > @@ -59,6 +59,8 @@ static void class_release(struct kobject *kobj)
> >  	else
> >  		pr_debug("class '%s' does not have a release() function, "
> >  			 "be careful\n", class->name);
> > +
> > +	kfree(cp);
> >  }
> >  
> >  static struct sysfs_ops class_sysfs_ops = {
> 
> This looks like 2.6.33 material for me. CC-ing Andrew.

Heh, I can handle .33 stuff just fine :)

thanks,

greg k-h
