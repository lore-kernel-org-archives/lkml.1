Return-Path: <linux-kernel-owner+w=401wt.eu-S1761350AbXKERWv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761350AbXKERWv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 12:22:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758300AbXKERPg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 12:15:36 -0500
Received: from mx2.suse.de ([195.135.220.15]:42997 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758752AbXKERPe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 12:15:34 -0500
Date: Mon, 5 Nov 2007 09:11:33 -0800
From: Greg KH <gregkh@suse.de>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 34/54] Driver Core: add kobj_attribute handling
Message-ID: <20071105171133.GD12843@suse.de>
References: <20071102235758.GA9803@kroah.com> <1194047972-9850-34-git-send-email-gregkh@suse.de> <20071105134203.1c078136@gondolin.boeblingen.de.ibm.com> <1194279812.6771.11.camel@lov.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1194279812.6771.11.camel@lov.site>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 05, 2007 at 05:23:32PM +0100, Kay Sievers wrote:
> On Mon, 2007-11-05 at 13:42 +0100, Cornelia Huck wrote:
> > On Fri,  2 Nov 2007 16:59:12 -0700,
> > Greg Kroah-Hartman <gregkh@suse.de> wrote:
> > 
> > > From: Kay Sievers <kay.sievers@vrfy.org>
> > > 
> > > Add kobj_sysfs_ops to replace subsys_sysfs_ops. There is no
> > > need for special kset operations, we want to be able to use
> > > simple attribute operations at any kobject, not only ksets.
> > > 
> > > The whole concept of any default sysfs attribute operations
> > > will go away with the upcoming removal of subsys_sysfs_ops.
> > > 
> > > Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
> > > Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> > > ---
> > >  include/linux/kobject.h |   10 ++++++++++
> > >  lib/kobject.c           |   29 +++++++++++++++++++++++++++++
> > >  2 files changed, 39 insertions(+), 0 deletions(-)
> > 
> > How about adding some simple wrappers around the new kobj_attribute
> > structure? This makes the layering clearer.
> 
> > +#define KOBJ_ATTR(_name,_mode,_show,_store)		\
> > +	struct kobj_attribute kobj_attr_##_name =	\
> > +		__ATTR(_name,_mode,_show,_store)
> 
> That sounds fine.
> 
> > +extern int __must_check kobject_create_file(struct kobject *,
> > 
> > 					    struct kobj_attribute *);
> > +extern void kobject_remove_file(struct kobject *,struct kobj_attribute *);
> 
> That should usually be done by default attributes assigned to the ktype.
> Do you have a good use case, where people need to create such attributes
> individually instead?

The s390 code that was converted to use kobj_attributes :)

These look very useful, I'll go add them to the series unless Kay really
objects.

thanks,

greg k-h
