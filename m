Return-Path: <linux-kernel-owner+w=401wt.eu-S1758096AbXJ2RSl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758096AbXJ2RSl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 13:18:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753854AbXJ2RSc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 13:18:32 -0400
Received: from mtagate6.de.ibm.com ([195.212.29.155]:53567 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752872AbXJ2RSb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 13:18:31 -0400
Date: Mon, 29 Oct 2007 18:18:14 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Greg KH <greg@kroah.com>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sysfs: add filter function to groups
Message-ID: <20071029181814.25410e00@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <1193677071.3383.56.camel@localhost.localdomain>
References: <1193671019.3383.13.camel@localhost.localdomain>
	<1193676852.2655.21.camel@lov.site>
	<1193677071.3383.56.camel@localhost.localdomain>
Organization: IBM Deutschland Entwicklung GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?=
 Herbert Kircher Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Oct 2007 11:57:51 -0500,
James Bottomley <James.Bottomley@SteelEye.com> wrote:

> On Mon, 2007-10-29 at 17:54 +0100, Kay Sievers wrote:
> > On Mon, 2007-10-29 at 10:16 -0500, James Bottomley wrote:
> > > This patch is a first pass at adding a filter function to the group
> > > attributes, just to see how the idea flies.  If everyone's OK with this,
> > > I think the next thing that we might do is add bitmap functions (so
> > > every bit in the bitmap has a name, but also might not appear) to
> > > groups.
> > 
> > Bitmaps in the attribute groups?
> 
> Actually, no ... that would spoil our one group for all devices rule.
> So they would be a set of helper functions for manipulating bitmaps, but
> the bitmap would have to be in separate storage elsewhere.

Can you determine which subset of the attributes you want just before
actually creating the group? Then you could do something like:

create_group(grp, kobj)
{
	grp->update_creation_mask(kobj);
	actually_create_attrs();
}

> 
> > >  struct attribute_group {
> > >  	const char		*name;
> > > +	int			(*filter_show)(struct kobject *, int);
> > 
> > Are you sure that you want to return an array index here, instead of the
> > actual attribute? Like:
> 
> Actually, it returns a true/false value indicating whether the given
> attribute should be displayed.
> 
> >   int (*filter_show)(struct kobject *kobj, struct attribute *attr);

I'd agree that using the attribute is better in this function.

> > 
> > The names "show" and "store" are the ususal file-operation names, and we
> > are not filtering a "show" here, right? Maybe "create", or "export", or
> > something else might be a better name?
> 
> how about (*attribute_is_visible)?

Well, you don't only stop the visibility, but the creation of the
attribute, so perhaps (*creation_filter)?
