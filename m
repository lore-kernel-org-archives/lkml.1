Return-Path: <linux-kernel-owner+w=401wt.eu-S1758330AbXJ2QwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758330AbXJ2QwT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 12:52:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754385AbXJ2QwI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 12:52:08 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:52235 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753971AbXJ2QwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 12:52:07 -0400
Subject: Re: [PATCH] sysfs: add filter function to groups
From: Kay Sievers <kay.sievers@vrfy.org>
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Greg KH <greg@kroah.com>, linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1193671019.3383.13.camel@localhost.localdomain>
References: <1193671019.3383.13.camel@localhost.localdomain>
Content-Type: text/plain
Date: Mon, 29 Oct 2007 17:54:12 +0100
Message-Id: <1193676852.2655.21.camel@lov.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX18Jyuoxk1pxC1VOvsL3ebc71R1ljx3ycE9IhWM
 fStiAi8pAjUvYmPRF1phshLgkvT5ug6heZuqK5J+m2RfNG0q4f
 OaBTaeyQ9s10tXSUjaZ/d51n+Zj0vWF
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-10-29 at 10:16 -0500, James Bottomley wrote:
> In the SCSI transport classes (and soon to be in the AEN event
> subsystem) we have a lot of need for a grouping that doesn't include all
> files in the group.  We basically want to show capability by which file
> is present.  A classic example of this is the SPI transport class
> connected to the 53c700 card.  It's incapable of doing all of the modern
> LVD functions, so we don't show any of those capabilities in its sysfs
> directory.  However, we have a lot of horrible logic to generate
> separate per host groupings of attributes for this.  We would be able to
> use the standard sysfs group attributes *if* there were a way of
> filtering them so that certain attributes didn't appear.

Sounds fine.
 
> This patch is a first pass at adding a filter function to the group
> attributes, just to see how the idea flies.  If everyone's OK with this,
> I think the next thing that we might do is add bitmap functions (so
> every bit in the bitmap has a name, but also might not appear) to
> groups.

Bitmaps in the attribute groups?

>  struct attribute_group {
>  	const char		*name;
> +	int			(*filter_show)(struct kobject *, int);

Are you sure that you want to return an array index here, instead of the
actual attribute? Like:
  int (*filter_show)(struct kobject *kobj, struct attribute *attr);

The names "show" and "store" are the ususal file-operation names, and we
are not filtering a "show" here, right? Maybe "create", or "export", or
something else might be a better name?

Thanks,
Kay

