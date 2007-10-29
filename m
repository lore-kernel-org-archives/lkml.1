Return-Path: <linux-kernel-owner+w=401wt.eu-S1759438AbXJ2RZd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759438AbXJ2RZd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 13:25:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755780AbXJ2RZY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 13:25:24 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:60497 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753268AbXJ2RZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 13:25:23 -0400
Subject: Re: [PATCH] sysfs: add filter function to groups
From: Kay Sievers <kay.sievers@vrfy.org>
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Greg KH <greg@kroah.com>, linux-scsi <linux-scsi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1193677071.3383.56.camel@localhost.localdomain>
References: <1193671019.3383.13.camel@localhost.localdomain>
	 <1193676852.2655.21.camel@lov.site>
	 <1193677071.3383.56.camel@localhost.localdomain>
Content-Type: text/plain
Date: Mon, 29 Oct 2007 18:27:24 +0100
Message-Id: <1193678844.3782.7.camel@lov.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX18UE7bT4nxH7Tl2u4k8JgcIJiu9SHCJULjhj+k
 3UQfQ2WhmJgJ/u/ExDuXSpsOyRrj48MV+uj8ywjdFP3K/gZoTr
 r1z4n/TknVDqEtetT4ffy6pMpVSTPra
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-10-29 at 11:57 -0500, James Bottomley wrote:
> On Mon, 2007-10-29 at 17:54 +0100, Kay Sievers wrote:
> > On Mon, 2007-10-29 at 10:16 -0500, James Bottomley wrote:

> > >  struct attribute_group {
> > >  	const char		*name;
> > > +	int			(*filter_show)(struct kobject *, int);
> > 
> > Are you sure that you want to return an array index here, instead of the
> > actual attribute? Like:
> 
> Actually, it returns a true/false value indicating whether the given
> attribute should be displayed.

It isn't about the return value of the function, that's fine. You call
back with the index number (int) of the array of attributes, instead of
passing the attribute pointer (struct attribute *attr) back to ask the
device for the attribute to create.

Kay

