Return-Path: <linux-kernel-owner+w=401wt.eu-S1755274AbXJ3JBB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755274AbXJ3JBB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 05:01:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752601AbXJ3JAw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 05:00:52 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:15565 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752682AbXJ3JAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 05:00:51 -0400
Date: Tue, 30 Oct 2007 10:00:34 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Jeff Garzik <jeff@garzik.org>, Kay Sievers <kay.sievers@vrfy.org>,
       Greg KH <greg@kroah.com>, linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sysfs: add filter function to groups
Message-ID: <20071030100034.64fd9d70@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <1193678967.3383.81.camel@localhost.localdomain>
References: <1193671019.3383.13.camel@localhost.localdomain>
	<1193676852.2655.21.camel@lov.site>
	<1193677071.3383.56.camel@localhost.localdomain>
	<20071029181814.25410e00@gondolin.boeblingen.de.ibm.com>
	<1193678646.3383.76.camel@localhost.localdomain>
	<4726180E.5030909@garzik.org>
	<1193678967.3383.81.camel@localhost.localdomain>
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

On Mon, 29 Oct 2007 12:29:27 -0500,
James Bottomley <James.Bottomley@SteelEye.com> wrote:

> On Mon, 2007-10-29 at 13:27 -0400, Jeff Garzik wrote:
> > James Bottomley wrote:
> > > visibility and creation are the same thing, aren't they?  An invisible
> > > attribute doesn't appear in the sysfs directory, so it's equivalent to
> > > the file for it not being created.
> > 
> > 
> > What about the case where it's visible at creation time, but then needs 
> > to be made selectively invisible later on?
> > 
> > That implies either a remove operation or dentry checks on each lookup?
> 
> Yes, that comes with the bitmap manipulation code.  There will be a way
> to add and remove runtime visibility.  I just wanted to get the basic
> concept agreed to first.

But visibility always comes with creation or deletion of attributes?

Perhaps what we want is to move knowledge of the attributes to the
kobject (when attributes are created/deleted), while we decide on
visibilty of the attributes (creation/deletion of sysfs entries) based
on a filter (where visibility may change, while the attribute still
exists).
