Return-Path: <linux-kernel-owner+w=401wt.eu-S1758824AbXJ2Q6P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758824AbXJ2Q6P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 12:58:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754839AbXJ2Q56
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 12:57:58 -0400
Received: from hancock.steeleye.com ([71.30.118.248]:55249 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752300AbXJ2Q55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 12:57:57 -0400
Subject: Re: [PATCH] sysfs: add filter function to groups
From: James Bottomley <James.Bottomley@SteelEye.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Greg KH <greg@kroah.com>, linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1193676852.2655.21.camel@lov.site>
References: <1193671019.3383.13.camel@localhost.localdomain>
	 <1193676852.2655.21.camel@lov.site>
Content-Type: text/plain
Date: Mon, 29 Oct 2007 11:57:51 -0500
Message-Id: <1193677071.3383.56.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-10-29 at 17:54 +0100, Kay Sievers wrote:
> On Mon, 2007-10-29 at 10:16 -0500, James Bottomley wrote:
> > In the SCSI transport classes (and soon to be in the AEN event
> > subsystem) we have a lot of need for a grouping that doesn't include all
> > files in the group.  We basically want to show capability by which file
> > is present.  A classic example of this is the SPI transport class
> > connected to the 53c700 card.  It's incapable of doing all of the modern
> > LVD functions, so we don't show any of those capabilities in its sysfs
> > directory.  However, we have a lot of horrible logic to generate
> > separate per host groupings of attributes for this.  We would be able to
> > use the standard sysfs group attributes *if* there were a way of
> > filtering them so that certain attributes didn't appear.
> 
> Sounds fine.
>  
> > This patch is a first pass at adding a filter function to the group
> > attributes, just to see how the idea flies.  If everyone's OK with this,
> > I think the next thing that we might do is add bitmap functions (so
> > every bit in the bitmap has a name, but also might not appear) to
> > groups.
> 
> Bitmaps in the attribute groups?

Actually, no ... that would spoil our one group for all devices rule.
So they would be a set of helper functions for manipulating bitmaps, but
the bitmap would have to be in separate storage elsewhere.

> >  struct attribute_group {
> >  	const char		*name;
> > +	int			(*filter_show)(struct kobject *, int);
> 
> Are you sure that you want to return an array index here, instead of the
> actual attribute? Like:

Actually, it returns a true/false value indicating whether the given
attribute should be displayed.

>   int (*filter_show)(struct kobject *kobj, struct attribute *attr);
> 
> The names "show" and "store" are the ususal file-operation names, and we
> are not filtering a "show" here, right? Maybe "create", or "export", or
> something else might be a better name?

how about (*attribute_is_visible)?

James


