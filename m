Return-Path: <linux-kernel-owner+w=401wt.eu-S1758789AbXJaKVR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758789AbXJaKVR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 06:21:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758632AbXJaKU6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 06:20:58 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:12597 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758551AbXJaKU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 06:20:56 -0400
Date: Wed, 31 Oct 2007 11:20:39 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Greg KH <greg@kroah.com>, James Bottomley <James.Bottomley@SteelEye.com>,
       Kay Sievers <kay.sievers@vrfy.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sysfs: add filter function to groups
Message-ID: <20071031112039.0b067ce3@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <47285063.1040508@s5r6.in-berlin.de>
References: <1193671019.3383.13.camel@localhost.localdomain>
	<1193676852.2655.21.camel@lov.site>
	<1193677071.3383.56.camel@localhost.localdomain>
	<47261F50.3050901@s5r6.in-berlin.de>
	<1193768743.3321.91.camel@localhost.localdomain>
	<20071031035506.GH14910@kroah.com>
	<20071031104103.13e07d8f@gondolin.boeblingen.de.ibm.com>
	<47285063.1040508@s5r6.in-berlin.de>
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

On Wed, 31 Oct 2007 10:52:35 +0100,
Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:

> Cornelia Huck wrote:
> > Greg KH <greg@kroah.com> wrote:
> >> On Tue, Oct 30, 2007 at 01:25:43PM -0500, James Bottomley wrote:
> >>> +	for (i = 0, attr = grp->attrs; *attr; i++, attr++)
> >>> +		if (grp->is_visible &&
> >>> +		    grp->is_visible(kobj, *attr, i))
> >>> +			sysfs_hash_and_remove(dir_sd, (*attr)->name);
> >> Hm, doesn't this break for the zillions of attribute groups that do not
> >> have the is_visible function set?
> ...
> > Would it make more sense then to turn the meaning of the callback
> > around?
> > 
> > for (...) {
> > 	if (grp->mask_out && grp->mask_out(kobj, *attr, i))
> > 		continue;
> > 	error |= sysfs_add_file(...);
> > }
> 
> 		if (!grp->is_visible ||
> 		    grp->is_visible(kobj, *attr, i))
> 			add or remove();
> 

Hm, I find that a bit harder to parse...

mask_out() would also imply that the common use case is to have all
attributes in the group created and that you need to take action to
have an attribute not created.
